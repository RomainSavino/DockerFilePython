# Choix de l'image de base (ici Python 3.10 slim, ajustez selon vos besoins)
FROM python:3.10-slim

# Mise à jour et installation des paquets nécessaires
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \        # Outils de compilation
    cmake \                  # Pour d'autres projets de build
    python3-tk \             # Pour Tkinter
    python3-pyqt5 \          # PyQt5 via apt (optionnel si vous préférez pip)
    libx11-dev libxext-dev libxrender-dev libxi-dev libxrandr-dev libxcursor-dev \
    fdisk \                  # Gestion des partitions
    parted \                 # Autre utilitaire de partition
    lsof \                   # Permet de lister les fichiers ouverts
    git \                    # Souvent pratique
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir \
    numpy \
    pandas \
    matplotlib \
    seaborn \
    scikit-learn \
    requests \
    pyinstaller \            # Pour compiler vos applications Python en binaires
    openpyxl

# Définir le répertoire de travail
WORKDIR /app
