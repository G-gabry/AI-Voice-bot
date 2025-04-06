# Use a more compatible slim base
FROM python:3.10-slim-bullseye

# Set working directory
WORKDIR /app

# Install system-level dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        curl \
        git \
        ffmpeg \
        build-essential \
        libsndfile1 \
        libsndfile1-dev \
        libffi-dev \
        libssl-dev \
        gfortran \
        pkg-config \
        libstdc++6 \
        libblas-dev \
        liblapack3 && \
    rm -rf /var/lib/apt/lists/*

# Install Ollama
RUN curl -fsSL https://ollama.com/install.sh | sh

# Preload model (optional step)
RUN ollama serve & sleep 12 && ollama pull phi

# Copy requirements and install Python dependencies
COPY requirements.txt .

RUN pip install --upgrade pip && \
    pip install torch --extra-index-url https://download.pytorch.org/whl/cpu && \
    pip install -r requirements.txt

# Copy the rest of the code
COPY . .

# Expose port
EXPOSE 8000

# Start Ollama and the Flask app
CMD bash -c "ollama serve & gunicorn -w 4 -b 0.0.0.0:8000 main:app"

