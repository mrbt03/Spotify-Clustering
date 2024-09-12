# Spotify Music Attribute Analysis

This project explores the characteristics of Spotify music tracks using Principal Component Analysis (PCA) and clustering techniques. It aims to uncover underlying music attributes and provide insights for potential business applications, such as playlist curation, marketing strategies, and enhanced user engagement.

## Project Overview

The goal of this project is to analyze and cluster music tracks based on their attributes from the Spotify dataset. By applying PCA and clustering, we can identify distinct musical traits and categorize tracks into meaningful groups. These insights are valuable for music producers, streaming services, and other stakeholders looking to understand and leverage music characteristics for business benefits.

## Data

- **Dataset**: Spotify Features dataset (`SpotifyFeatures.csv`), containing various musical attributes like acousticness, danceability, energy, and more.
- **Data Source**: The dataset is read from a CSV file provided in the `/kaggle/input/spotify-data` directory.

## Methods

1. **Data Preparation**:
   - Removed duplicate tracks to avoid skewing the results.
   - Selected only numerical variables relevant for PCA by removing categorical columns (e.g., genre, artist, track names).
   - Standardized the data to ensure all variables have equal weight during analysis.

2. **Principal Component Analysis (PCA)**:
   - Conducted PCA to reduce dimensionality and identify underlying patterns in the data.
   - Scree plots and Kaiser Criterion were used to determine the optimal number of components.
   - Varimax and promax rotations were applied to enhance interpretability.
   - Three principal components were selected, each capturing different aspects of the music attributes.

3. **Clustering Analysis**:
   - Applied Gaussian Mixture Models (GMM) using the `mclust` package to classify tracks into clusters.
   - Determined the optimal number of clusters using the Bayesian Information Criterion (BIC).
   - Nine distinct clusters were identified, each representing unique combinations of musical attributes.

4. **Business Implications**:
   - Identified business use cases for each cluster, providing actionable insights for playlist curation, targeted marketing, and customer experience enhancement in various commercial settings.

## Key Findings

- **Principal Component 1**: Represents "Acoustic and Energy Dynamics" – a contrast between acoustic and electronic music elements, useful for curating content that spans soft to energetic music preferences.
- **Principal Component 2**: Represents "Expressiveness and Live Experience" – tracks with live performance features and spoken content, valuable for live venues and event organizers.
- **Principal Component 3**: Represents "Rhythmic and Emotional Depth" – captures danceable and emotionally positive tracks, ideal for energizing environments like retail spaces or fitness centers.

## Clustering Results

### Top Clusters and Use Cases

1. **Subdued Acoustic**: Mellow tracks, suitable for reflective environments like yoga studios.
2. **Instrumental and Calm**: Calm instrumental tracks, ideal for art galleries or libraries.
3. **Mellow and Melodic**: Serene background music, fitting for meditation centers.
4. **Live and Energetic**: High-energy, live-recorded tracks, perfect for social settings.
5. **Upbeat and Dynamic**: Energetic music, versatile for retail shops, bars, or parties.
6. **Expressive and Intense**: Focus on spoken word and performance arts, suitable for event settings.
7. **Instrumental Focus**: Long instrumental pieces for minimal distraction, ideal for study spaces.
8. **Calm and Melancholic**: Subdued music for fine dining or quiet areas.
9. **Popularity and Tempo**: Catchy and mainstream genres, best for malls or casual dining.

## Conclusion

The project provides valuable insights into the characteristics and business applications of different music types. By leveraging PCA and clustering techniques, stakeholders in the music and entertainment industry can make data-driven decisions to enhance user experiences and optimize marketing strategies.

## Contact

For questions or more information, feel free to reach out or open an issue in this repository.
