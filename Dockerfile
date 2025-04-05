# Use official Python base image
FROM python:3.10-slim

# Set working directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    curl \
    git \
    ffmpeg \
    build-essential \
    libsndfile1 \
 && rm -rf /var/lib/apt/lists/*

# Install Ollama
RUN curl -fsSL https://ollama.com/install.sh | sh

# Optionally preload model (remove if you prefer pull at runtime)
RUN ollama serve & sleep 12 && ollama pull phi

# Copy your project files
COPY . .

# Install Python dependencies
RUN pip install --upgrade pip && pip install -r requirements.txt

# Expose port your app runs on
EXPOSE 8000

# Start Ollama and your Flask app with Gunicorn
CMD bash -c "ollama serve & gunicorn -w 4 -b 0.0.0.0:8000 main:app"
