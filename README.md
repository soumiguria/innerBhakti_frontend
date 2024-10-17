# InnerBhakti_assignment Frontend

## Overview
The Inner Bhakti application is a meditation platform designed to provide users with various meditation programs and audio tracks. This frontend application allows users to browse programs, listen to audio tracks, and enjoy a seamless meditation experience.

## Table of Contents
- [Features](#features)
- [Technologies Used](#technologies-used)
- [Getting Started](#getting-started)
- [API Endpoints](#api-endpoints)
- [Installation](#installation)
- [Usage](#usage)

## Features
- Browse a list of meditation programs.
- View details of each program, including audio tracks.
- Play, pause, rewind, and forward audio tracks.
- Share audio links with others.
- Responsive design for various screen sizes.

## Technologies Used
- Flutter: For building the mobile application.
- Just Audio: For audio playback functionality.
- HTTP: For making API requests.
- Dart: Programming language for Flutter.
- Provider or Shared Preferences: For state management and persisting user preferences (like favorite tracks).

## Getting Started
To run this application locally, follow these steps:

1. Clone the repository:
   ```bash
   git clone https://github.com/soumiguria/innerBhakti_frontend.git

2. Navigate to the project directory:
```bash
cd innerBhakti_frontend

```

## Installation

Install the required dependencies:
```bash
flutter pub get
flutter run
```

## Screenshots
<img src="https://github.com/user-attachments/assets/fd6dd304-55c2-45ff-9e3f-b27c88ecbd7d" alt="Program List Screen" width="300" />
<img src="https://github.com/user-attachments/assets/4abe1fab-f565-4d90-9800-809eb591ea04" alt="Program Details Screen" width="300" />
<img src="https://github.com/user-attachments/assets/b37cb043-680e-4ead-91cd-8105b290a681" alt="Audio Player Screen" width="300" />


## API Endpoints

This application interacts with the backend API hosted on Render. Below are the main API endpoints used:

- **GET /api/programs**
  - Fetch a list of meditation programs.
  
- **GET /api/programs/:id**
  - Fetch details of a specific program, including audio tracks.
  
- **POST /api/programs**
  - (For backend use) Create a new program with audio tracks.
 

# Download APK
You can download the latest version of the Inner Bhakti app from the link below:

- [Download APK](https://drive.google.com/file/d/1SuuUY47TJ3kpvecB5PdJ_mDWerXgZefv/view?usp=sharing)

 
