# Spotify Audio-Feature Explorer  

👉 [**Live Demo**](https://mrbt03.shinyapps.io/spotify-clustering/)  

This project applies **unsupervised learning** to Spotify’s “audio DNA” (acousticness, energy, danceability, etc.) to reveal structure in music beyond genre labels.  
Deliverables include both a **reproducible R analysis** and an **interactive Shiny dashboard** for exploration, playlist curation, and cluster diagnostics.  

---

## 🔑 Highlights

- **Dimensionality reduction:** PCA distilled 10 audio features into 3 interpretable axes:  
  1. Acoustic ↔ Energy  
  2. Studio ↔ Live/Spoken  
  3. Moody ↔ Upbeat/Groove  

- **Clustering:** Gaussian Mixture Models (GMM) identified **9 distinct sonic groups**, each with measurable cohesion and business relevance.  

- **Dashboard:** Business-facing Shiny app enables filtering, scatterplot exploration, and quick cluster summaries for PMs, curators, and analysts.  

---

## 📊 Data

- **Source:** Spotify track-level audio features (`spotifyfeatures.csv`)  
- **Variables:** 10 numeric features (danceability, valence, tempo, loudness, etc.)  
- **Preprocessing:** De-duplication, standardization (Z-scores), numeric-only subset  

---

## ⚙️ Methods

### Principal Component Analysis (PCA)
- Scree plots, VSS/MAP diagnostics, and rotation (Varimax & Promax) guided axis selection  
- Final model: 3 axes explaining ~63% of variance  

### Clustering
- GMM with BIC-driven model selection (`mclust`, VEV structure)  
- Diagnostics included:  
  - Within vs. between cluster variance  
  - Mean z-profiles of features  
  - Genre, artist, and popularity distribution  

---

## 🖥 Deliverables

- **Interactive Shiny Dashboard**  
  - PCA scatterplots with cluster coloring  
  - Cluster composition (genre, artist, popularity)  
  - Exploration of “extreme” tracks along PCA axes  

- **R Markdown Analysis Report**  
  - PCA methodology and axis interpretation  
  - Cluster summaries and diagnostics  
  - Flags for low-cohesion clusters  

---

## 📌 Example Insights

- **Explainable controls:** Axes map directly to levers like *energy*, *groove*, and *live feel*, enabling transparent playlist design  
- **Actionable segmentation:** Spoken-word skits/podcasts separated cleanly from mainstream pop — useful for filtering or targeting content  
- **Commercial value:** Latin/EDM and Dance-Pop clusters surfaced as high-popularity, high-engagement groups (retail, fitness, social use cases)  
- **Quality control:** Weak clusters (e.g., Quiet Acoustic, Spoken-Word) flagged for refinement before operational rollout  

---

## 💼 Business Relevance

Traditional genre tags are inconsistent and subjective. This project shows how **measurable, explainable features** can drive:  
- Mood-driven playlist curation  
- Market segmentation (by sonic profile, not label)  
- Transparent, data-driven decisions for product managers and curators  

---
