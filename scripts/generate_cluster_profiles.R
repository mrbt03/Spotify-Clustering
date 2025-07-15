# ------------------------------------------- #
#  Generate PCA, clustering & summary objects #
#  (adds one-hot genre, key, mode, time_sig)   #
# ------------------------------------------- #

library(tidyverse)
library(mclust)

message("▶︎ Loading CSV …")
df <- read_csv("data/spotifyfeatures.csv", show_col_types = FALSE) |>
  distinct(track_id, .keep_all = TRUE)

# ---------- 1. build modelling matrix ----------
# numeric audio features
num_cols <- c("acousticness","danceability","duration_ms","energy",
              "instrumentalness","liveness","loudness",
              "speechiness","tempo","valence")

num_mat  <- df |> select(all_of(num_cols)) |> scale()

# one-hot encode low-cardinality categoricals
cat_mat  <- model.matrix(~ genre + key + mode + time_signature - 1, data = df)

# optional: centre/scale dummies to mean0/var1 (makes PCs weight them ∼equally)
cat_mat  <- scale(cat_mat)

data_mat <- cbind(num_mat, cat_mat)

# ---------- 2. PCA (3 comps keeps >60% var.) ----------
pca_obj    <- prcomp(data_mat, center = FALSE, scale. = FALSE)   # already scaled
pca_scores <- as.data.frame(pca_obj$x[, 1:3])

# ---------- 3. Gaussian-mixture clustering ----------
set.seed(12345)
clust_obj      <- Mclust(data_mat)
classification  <- factor(clust_obj$classification)

# ---------- 4. cluster means for numeric audio vars ----------
cluster_means <- aggregate(num_mat,
                           by = list(cluster = classification), FUN = mean) |>
  select(-cluster)

# ---------- 5. genre tallies ----------
genre_df <- df |>
  mutate(cluster = classification) |>
  count(cluster, genre, name = "Frequency")

top_genres_per_cluster <- genre_df |>
  group_by(cluster) |>
  slice_max(Frequency, n = 5, with_ties = FALSE) |>
  ungroup()

# ---------- 6. FULL ranked song / artist tables ----------
top_songs <- df |>
  mutate(cluster = classification) |>
  arrange(cluster, desc(popularity)) |>
  select(cluster, track_name, artist_name, popularity)

top_artists <- df |>
  mutate(cluster = classification) |>
  group_by(cluster, artist_name) |>
  summarise(
    n_tracks       = n(),
    avg_popularity = mean(popularity, na.rm = TRUE),
    .groups        = "drop"
  ) |>
  arrange(cluster, desc(avg_popularity))

# ---------- 7. metadata for scatter / extremes ----------
metadata <- df |>
  select(track_name, artist_name, popularity) |>
  bind_cols(pca_scores, cluster = classification)

# ---------- 8. save objects ----------
dir.create("shiny_app", showWarnings = FALSE)

saveRDS(pca_scores,              "shiny_app/pca_scores.rds")
saveRDS(classification,          "shiny_app/classification.rds")
saveRDS(cluster_means,           "shiny_app/cluster_means.rds")
saveRDS(genre_df,                "shiny_app/genre_frequency_df.rds")
saveRDS(top_genres_per_cluster,  "shiny_app/top_genres_per_cluster.rds")
saveRDS(top_songs,               "shiny_app/top_songs.rds")      # no hard cap
saveRDS(top_artists,             "shiny_app/top_artists.rds")    # no hard cap
saveRDS(metadata,                "shiny_app/metadata.rds")

message("✅  Objects written to shiny_app/ (now with one-hot categoricals!)")
