# Choix de l'image de base (ici Python 3.10 slim, ajustez selon vos besoins)
FROM python:3.10-slim

# Mise à jour et installation des paquets nécessaires
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    cmake \
    python3-tk \
    python3-pyqt5 \
    libx11-dev libxext-dev libxrender-dev libxi-dev libxrandr-dev libxcursor-dev \
    fdisk \
    parted \   
    lsof \
    git \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir \
    numpy \
    pandas \
    matplotlib \
    seaborn \
    scikit-learn \
    requests \
    pyinstaller \
    openpyxl

# Définir le répertoire de travail
WORKDIR /app
