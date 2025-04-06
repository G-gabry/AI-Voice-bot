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
    libsndfile1-dev \
    libffi-dev \
    libssl-dev \
    liblapack-dev \
    gfortran \
    libblas-dev \
    libatlas-base-dev \
    libstdc++6 \
    pkg-config \
 && rm -rf /var/lib/apt/lists/*

# Install Ollama
RUN curl -fsSL https://ollama.com/install.sh | sh

# Optionally preload model
RUN ollama serve & sleep 12 && ollama pull phi

# Copy and install Python dependencies
COPY requirements.txt .

# Install torch before whisper
RUN pip install --upgrade pip && \
    pip install torch --extra-index-url https://download.pytorch.org/whl/cpu && \
    pip install -r requirements.txt

# Copy the rest of the project
COPY . .

# Expose app port
EXPOSE 8000

# Start Ollama and your Flask app
CMD bash -c "ollama serve & gunicorn -w 4 -b 0.0.0.0:8000 main:app"
