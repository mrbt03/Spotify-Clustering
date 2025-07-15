# Spotify Audio-Feature Explorer

This project applies unsupervised learning to uncover structure and insights in Spotify's "audio DNA" — a set of language-agnostic, measurable features (e.g., acousticness, energy, danceability) describing every track’s sonic profile.  

The deliverable includes both a reproducible R analysis notebook and an interactive Shiny dashboard that supports exploration, playlist curation, and cluster diagnostics.

## Project Overview

We aimed to:
- **Reduce dimensionality:** Principal Component Analysis (PCA) distills 10 audio attributes into 3 interpretable axes:
  1. **Acoustic ↔ Energy**
  2. **Studio ↔ Live/Spoken**
  3. **Long/Moody ↔ Upbeat/Groove**

- **Cluster:** Gaussian Mixture Models (GMM) identified **9 distinct sonic clusters**.
- **Diagnose clusters:** Evaluate coherence, genre mix, artist/track composition, and business relevance.
- **Prepare for operational use:** The results power an interactive dashboard for business users (e.g., PMs, curators) to interrogate and deploy.

## Data

- **Dataset:** Spotify track-level features dataset (`spotifyfeatures.csv`).
- **Features:** 10 numeric attributes (e.g., danceability, valence, tempo, loudness).
- **Preprocessing:** De-duplication, selection of numeric variables, and standardization (Z-scores).

## Methods Summary

### Principal Component Analysis (PCA)
- **Scree plot, Kaiser criterion, and diagnostic tests (VSS, MAP)** guided dimensionality choice.
- Three interpretable axes explained ~63% of variance.
- Varimax and Promax rotations ensured interpretability and orthogonality.

### Clustering
- GMM clustering using `mclust`.
- **BIC-driven model selection:** VEV structure, 9 clusters.
- Post-clustering diagnostics:
  - Cluster sizes and compactness (within-cluster variance vs overall variance)
  - Sonic profiles (mean z-scores per feature)
  - Genre, artist, and popularity distribution

## Deliverables

- **Interactive Shiny dashboard** that lets users filter and explore:
  - Extreme tracks by PCA direction
  - Cluster composition (genres, artists)
  - Popularity distribution
  - Sonic scatterplots
- **Diagnostic report in R Markdown:** Explains the PCA axes, summarizes cluster characteristics, and flags clusters with weak cohesion for refinement.

## Example Insights

- **Clear, explainable axes map directly to business needs:**  
  Product teams can tune dials for energy, groove, or "live feel" without relying on imprecise genre tags.

- **Distinct niche opportunities:**  
  Speech-heavy skits and podcasts cluster separately from mainstream pop and dance music ⇒ actionable segments for podcast promotion or explicit content filtering.

- **Popular clusters identified:**  
  Latin/EDM and Dance-Pop clusters show the highest median popularity, supporting use in retail, gym, or social playlists.

- **Clusters with weak cohesion transparently flagged:**  
  Loose clusters (e.g., Quiet Acoustic, Spoken-Word) marked as targets for refinement before operational use.

## Business Use-Case

This project framework enables a **product manager (PM) or curator to quickly auto-curate distinct, mood-driven playlists** using measurable audio features (e.g., acousticness, danceability, speechiness) rather than broad or unreliable genre metadata — and provides explainable reasons why a track fits a particular curation theme (e.g., "Mellow Pop" vs "Latin EDM").

## Contact

For questions, feedback, or collaboration opportunities, feel free to reach out or open an issue.