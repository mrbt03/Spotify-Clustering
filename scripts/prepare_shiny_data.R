# Quick loader that returns a named list
load_shiny_data <- function(path = "shiny_app") {
  list(
    pca_scores     = readRDS(file.path(path, "pca_scores.rds")),
    classification = readRDS(file.path(path, "classification.rds")),
    cluster_means  = readRDS(file.path(path, "cluster_means.rds")),
    genre_df       = readRDS(file.path(path, "genre_frequency_df.rds")),
    top_genres     = readRDS(file.path(path, "top_genres_per_cluster.rds"))
  )
}

