# Real-Time AI Audio Analysis Pipeline

A low-latency, browser-based audio streaming system built with WebRTC for real-time audio capture and AI-driven signal processing. The full-stack architecture is containerized with Docker and deployed on AWS EC2 with a fully automated CI/CD pipeline.

---

## Overview

This project implements a real-time audio pipeline that captures audio directly from the browser using WebRTC, streams it to a Flask backend, and processes it through a DSP and AI-driven signal analysis layer. The system handles speech-to-text transcription, AI response generation, and text-to-speech conversion to create a full voice interaction loop.

---

## Tech Stack

| Layer | Technology |
|---|---|
| Audio Capture | WebRTC |
| Backend | Flask (Python) |
| Signal Processing | DSP (DSP.py) |
| Speech to Text | speech_to_text.py |
| Text to Speech | text_to_speech.py |
| AI Response | ai_responce.py |
| Containerization | Docker |
| Cloud Deployment | AWS EC2 |
| CI/CD | GitHub Actions (.github/workflows/main.yml) |

---

## Features

- **Real-time audio streaming** — browser-based capture using WebRTC with minimal latency
- **Speech to text** — converts captured audio into text for processing
- **AI-driven responses** — generates intelligent responses based on transcribed input
- **Text to speech** — converts AI responses back into audio output
- **DSP processing** — digital signal processing applied to raw audio input
- **Containerized architecture** — full-stack system packaged with Docker for consistent cross-environment behavior
- **Cloud deployment** — deployed and running on AWS EC2
- **Automated CI/CD** — GitHub Actions pipeline for continuous testing and zero-downtime deployment

---

## Architecture

```
Browser (WebRTC)
      ↓
  main.py (Flask)
      ↓
  DSP.py → speech_to_text.py → ai_responce.py → text_to_speech.py
      ↓
  Audio Response (response.mp3)
      ↓
  Docker Container on AWS EC2
      ↑
  GitHub Actions CI/CD (main.yml)
```

---

## Project Structure

```
AI-Voice-bot/
├── .github/
│   └── workflows/
│       └── main.yml          # CI/CD pipeline
├── templates/
│   └── UI.html               # Frontend (WebRTC client)
├── main.py                   # Flask backend entry point
├── DSP.py                    # Digital signal processing
├── speech_to_text.py         # Audio to text transcription
├── text_to_speech.py         # Text to audio conversion
├── ai_responce.py            # AI response generation
├── config.py                 # Configuration settings
├── utils.py                  # Utility functions
├── Dockerfile                # Docker image definition
├── buildspec.yml             # AWS build specification
├── requirements.txt          # Python dependencies
└── README.md
```

---

## Getting Started

### Prerequisites

- Docker installed
- Python 3.9+
- AWS EC2 instance (for cloud deployment)

### Run Locally

```bash
# Clone the repository
git clone https://github.com/G-gabry/AI-Voice-bot.git
cd AI-Voice-bot

# Install dependencies
pip install -r requirements.txt

# Run the app
python main.py
```

Then open your browser at `http://localhost:5000`

### Run with Docker

```bash
docker build -t ai-voice-bot .
docker run -p 5000:5000 ai-voice-bot
```

---

## CI/CD Pipeline

The project uses GitHub Actions for automated deployment. Every push to `main` triggers:

1. Build the Docker image
2. Run tests
3. Deploy to AWS EC2

---

## Author

**Omar Elgabry**
Third-year Communications and Information Engineering student at Zewail City of Science and Technology.

[LinkedIn](https://linkedin.com/in/omar-elgabry-344648246) | [GitHub](https://github.com/G-gabry)

---

## License

MIT License
