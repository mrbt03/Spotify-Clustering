##############################################
#  Spotify Audio-Feature Explorer · shiny    #
#  Full app.R                                #
##############################################

# Load in libraries
library(shiny)
library(tidyverse)
library(plotly)
library(DT)
library(tidytext)
library(forcats)
library(scales)

# ── PATH TO PRE-COMPUTED ARTEFACTS ──────────────────────────────────────
# These are saved from the notebook
root <- "~/Spotify-Clustering/"

scores_df <- readRDS(file.path(root, "models/scores_df.rds"))      
meta_df   <- readRDS(file.path(root, "models/df_with_cluster.rds")) %>%
  select(-cluster)                                    

scores_df$cluster <- as.character(scores_df$cluster)
clusters          <- sort(unique(scores_df$cluster))

# ── HUMAN-READABLE CLUSTER DESCRIPTIONS ────────────────────────────────
cluster_lookup <- tribble(
  ~cluster, ~Description,
  "1","Mellow-Pop (mid-tempo, soft)",
  "2","Baseline Mix (average across any feature)",
  "3","Quiet Acoustic / Neo-Classical",
  "4","Rap & R-B Groove",
  "5","Latin / EDM Party",
  "6","Spoken-Word / Skits",
  "7","Long-Form Alt-Rock",
  "8","Ballads & Singer-Songwriter",
  "9","Dance-Pop Hit Factory"
)

# ── PCA AXIS CAPTIONS (from your factor analysis) ───────────────────────
pc_caption <- c(
  PC1 = "PC1  ← Acoustic | Energy →",
  PC2 = "PC2  ← Studio | Live/Spoken →",
  PC3 = "PC3  ← Long/Moody | Upbeat Groove →"
)

num_cols <- c("acousticness","danceability","duration_ms","energy",
              "instrumentalness","liveness","loudness",
              "speechiness","tempo","valence")

plt_pal <- if(length(clusters) <= 12) "Set3" else "Paired"

# ─── UI ─────────────────────────────────────────────────────────────────
ui <- fluidPage(
  titlePanel("Spotify Audio-Feature Explorer"),
  sidebarLayout(
    sidebarPanel(
      selectizeInput("cluster_sel","Clusters:",
                     choices  = clusters, selected = clusters, multiple = TRUE,
                     options  = list(plugins = list("remove_button"),
                                     placeholder = "select clusters…")
      ),
      actionButton("toggle_clusters","Select / Deselect all"),
      sliderInput("pop_range","Popularity:",0,100,c(50,100)),
      hr(),
      selectInput("pc_x","X-axis PC",choices=c("PC1","PC2","PC3")),
      selectInput("pc_y","Y-axis PC",choices=c("PC1","PC2","PC3"),selected="PC2")
    ),
    mainPanel(
      tabsetPanel(
        tabPanel("PCA Scatter",
                 plotlyOutput("pcaPlot",height=520), br(),
                 fluidRow(
                   column(4,
                          h4("Cluster Descriptions"),
                          tableOutput("clusterDescTbl")
                   ),
                   column(8,
                          h4("PC Extremes (Top 10 Tracks)"),
                          tabsetPanel(
                            tabPanel("High PC1", DTOutput("hiPC1")),
                            tabPanel("Low PC1",  DTOutput("loPC1")),
                            tabPanel("High PC2", DTOutput("hiPC2")),
                            tabPanel("Low PC2",  DTOutput("loPC2"))
                          )
                   )
                 )
        ),
        tabPanel("Cluster Inspector",
                 selectInput("detail_cluster","Cluster:",choices=clusters),
                 fluidRow(
                   column(6, plotOutput("topGenrePlot")),
                   column(6, plotOutput("topArtistPlot"))
                 ),
                 DTOutput("topSongsDT")
        ),
        tabPanel("Q1 · Genre Mix", plotOutput("genrePlot")),
        tabPanel("Q2 · Audio DNA (z-scores)", plotOutput("radarPlot")),
        tabPanel("Q3 · Popularity", plotOutput("popPlot")),
        tabPanel("Q4 · Energy vs Mood", plotOutput("energyValPlot")),
        tabPanel("Q5 · Duration vs Tempo", plotOutput("durTempoPlot"))
      )
    )
  )
)

# ─── SERVER ─────────────────────────────────────────────────────────────
server <- function(input, output, session){
  # Select/deselect all
  observeEvent(input$toggle_clusters, {
    updateSelectizeInput(session, "cluster_sel",
                         selected = if(length(input$cluster_sel)==length(clusters)) character(0) else clusters)
  })
  
  # Reactive filter
  filt_df <- reactive({
    req(input$cluster_sel)
    scores_df %>%
      filter(cluster %in% input$cluster_sel) %>%
      left_join(meta_df, by = "track_id") %>%
      filter(between(popularity,input$pop_range[1],input$pop_range[2]))
  })
  
  # ── PCA Scatter ────────────────────────────────────────────────────────
  output$pcaPlot <- renderPlotly({
    d <- filt_df() %>% slice_head(n=30000)
    p <- ggplot(d,
                aes(x = .data[[input$pc_x]], y = .data[[input$pc_y]],
                    color = cluster,
                    text = paste0("<b>",track_name,"</b><br>Artist: ",artist_name,
                                  "<br>Popularity: ", popularity))
    ) +
      geom_point(alpha=0.7,size=2) +
      scale_color_brewer(palette=plt_pal) +
      labs(
        x = pc_caption[input$pc_x],
        y = pc_caption[input$pc_y],
        title = paste("PCA:", pc_caption[input$pc_x], "vs", pc_caption[input$pc_y])
      ) +
      theme_minimal()
    ggplotly(p, tooltip="text") %>%
      layout(legend=list(title=list(text="Cluster")))
  })
  
  # Cluster descriptions
  output$clusterDescTbl <- renderTable({
    cluster_lookup %>%
      filter(cluster %in% input$cluster_sel) %>%
      arrange(cluster)
  }, colnames=TRUE, bordered=TRUE)
  
  # mk_extreme with tidy-eval
  mk_extreme <- function(dat, pc, high=TRUE) {
    pc_sym <- sym(pc)
    df2 <- if(high) {
      dat %>% arrange(desc(!!pc_sym))
    } else {
      dat %>% arrange(!!pc_sym)
    }
    df2 %>% slice_head(n=10) %>%
      select(Track=track_name, Artist=artist_name, Popularity=popularity)
  }
  
  # Render the four extremes tables
  observeEvent(filt_df(), {
    d <- filt_df(); x <- input$pc_x; y <- input$pc_y
    output$hiPC1 <- renderDT(mk_extreme(d, x, TRUE),
                             options=list(dom='tp',pageLength=10))
    output$loPC1 <- renderDT(mk_extreme(d, x, FALSE),
                             options=list(dom='tp',pageLength=10))
    output$hiPC2 <- renderDT(mk_extreme(d, y, TRUE),
                             options=list(dom='tp',pageLength=10))
    output$loPC2 <- renderDT(mk_extreme(d, y, FALSE),
                             options=list(dom='tp',pageLength=10))
  })
  
  # Keep Inspector dropdown in sync
  observe({
    updateSelectInput(session, "detail_cluster",
                      choices = input$cluster_sel,
                      selected = isolate(input$detail_cluster) %||% input$cluster_sel[1]
    )
  })
  detail_df <- reactive({ filt_df() %>% filter(cluster == input$detail_cluster) })
  
  # Cluster Inspector plots/tables
  output$topGenrePlot <- renderPlot({
    detail_df() %>% count(genre, sort=TRUE) %>% slice_head(n=10) %>%
      ggplot(aes(fct_reorder(genre,n),n,fill=genre))+
      geom_col(show.legend=FALSE)+coord_flip()+theme_minimal()+
      labs(title="Top Genres",y="Count",x=NULL)
  })
  output$topArtistPlot <- renderPlot({
    detail_df() %>% count(artist_name, sort=TRUE) %>% slice_head(n=10) %>%
      ggplot(aes(fct_reorder(artist_name,n),n,fill=artist_name))+
      geom_col(show.legend=FALSE)+coord_flip()+theme_minimal()+
      labs(title="Top Artists",y="Count",x=NULL)
  })
  output$topSongsDT <- renderDT({
    detail_df() %>% arrange(desc(popularity)) %>% slice_head(n=10) %>%
      select(Track=track_name,Artist=artist_name,Popularity=popularity)
  }, options=list(dom='tp'))
  
  # Q1: Genre Mix
  output$genrePlot <- renderPlot({
    filt_df() %>% count(cluster,genre) %>%
      group_by(cluster) %>% slice_max(n,n=5) %>% ungroup() %>%
      ggplot(aes(reorder_within(genre,n,cluster),n,fill=cluster))+
      geom_col(show.legend=FALSE)+coord_flip()+
      facet_wrap(~cluster,scales="free_y")+
      scale_x_reordered()+
      scale_fill_brewer(palette=plt_pal)+
      theme_minimal()+labs(
        title="Top 5 Genres per Cluster", x=NULL, y="Count"
      )
  })
  
  # Q2: Audio DNA radar (z-scores)
  output$radarPlot <- renderPlot({
    z <- filt_df() %>% mutate(across(all_of(num_cols), scale)) %>%
      group_by(cluster) %>% summarise(
        across(all_of(num_cols), mean),
        .groups = "drop"
      ) %>% pivot_longer(-cluster)
    ggplot(z, aes(name,value,group=cluster,color=cluster))+
      geom_line(linewidth=1)+geom_point(size=2)+coord_polar()+
      scale_color_brewer(palette=plt_pal)+
      theme_minimal()+ theme(axis.text.x = element_text(angle=45,hjust=1))+
      labs(title="Cluster Audio Fingerprints (z-scores)",x="",y="")
  })
  
  # Q3: Popularity
  output$popPlot <- renderPlot({
    ggplot(filt_df(), aes(cluster,popularity,fill=cluster))+
      geom_violin(trim=FALSE)+geom_boxplot(width=.1,outlier.shape=NA)+
      scale_fill_brewer(palette=plt_pal)+theme_minimal()+
      labs(title="Popularity by Cluster",x="Cluster",y="Popularity")
  })
  
  # Q4: Energy vs Mood
  output$energyValPlot <- renderPlot({
    ggplot(filt_df() %>% slice_head(n=30000),
           aes(energy,valence,color=cluster))+
      geom_point(alpha=.35,size=.8)+
      scale_color_brewer(palette=plt_pal)+theme_minimal()+
      labs(title="Energy vs Mood (Valence)")
  })
  
  # Q5: Duration vs Tempo
  output$durTempoPlot <- renderPlot({
    ggplot(filt_df() %>% slice_head(n=30000),
           aes(duration_ms/60000,tempo,color=cluster))+
      geom_point(alpha=.35,size=.8)+
      scale_color_brewer(palette=plt_pal)+theme_minimal()+
      labs(
        title="Duration vs Tempo",
        x="Duration (minutes)", y="Tempo (BPM)"
      )
  })
}

# ─── LAUNCH ─────────────────────────────────────────────────────────────
shinyApp(ui, server)
