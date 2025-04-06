FROM python:3.10

WORKDIR /app

# Install all system dependencies
RUN apt-get update && \
    apt-get install -y \
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
        liblapack-dev \
    && rm -rf /var/lib/apt/lists/*

# Install Ollama CLI
RUN curl -fsSL https://ollama.com/install.sh | sh

# Optionally preload model
RUN ollama serve & sleep 12 && ollama pull phi

# Copy requirements first for caching
COPY requirements.txt .

# Install Python dependencies, including the ollama module
RUN pip install --upgrade pip && \
    pip install torch --extra-index-url https://download.pytorch.org/whl/cpu && \
    pip install -r requirements.txt

# Copy the rest of the application code
COPY . .

EXPOSE 8000

# Start Ollama and the Flask app using Gunicorn
CMD bash -c "ollama serve & gunicorn -w 4 -b 0.0.0.0:8000 main:app"
