FROM python:3.10

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
    gfortran \
    pkg-config \
    libstdc++6 \
    libblas-dev \
    liblapack-dev \
    openssl \
 && rm -rf /var/lib/apt/lists/*

# Install Ollama
RUN curl -fsSL https://ollama.com/install.sh | sh

# Preload model (optional)
RUN ollama serve & sleep 12 && ollama pull tinyllama

# Create self-signed SSL cert
RUN mkdir -p /app/ssl && \
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /app/ssl/key.pem \
    -out /app/ssl/cert.pem \
    -subj "/CN=localhost"

# Copy requirements and install packages
COPY requirements.txt .
RUN pip install --upgrade pip && \
    pip install torch --extra-index-url https://download.pytorch.org/whl/cpu && \
    pip install -r requirements.txt

# Copy app code
COPY . .

EXPOSE 8000

CMD bash -c "ollama serve & gunicorn --certfile=ssl/cert.pem --keyfile=ssl/key.pem -w 4 -b 0.0.0.0:8000 main:app"
