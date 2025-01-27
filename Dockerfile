# Utiliser Debian 10 (Buster) comme image de base
FROM debian:10

# Définir des variables d'environnement pour éviter les interactions lors de l'installation
ENV DEBIAN_FRONTEND=noninteractive

# Mettre à jour les paquets et installer les dépendances nécessaires
RUN apt-get update && apt-get install -y \
    build-essential \
    wget \
    libssl-dev \
    zlib1g-dev \
    libncurses5-dev \
    libncursesw5-dev \
    libreadline-dev \
    libsqlite3-dev \
    libgdbm-dev \
    libdb5.3-dev \
    libbz2-dev \
    libexpat1-dev \
    liblzma-dev \
    tk-dev \
    libffi-dev \
    libjpeg-dev \
    libpng-dev \
    libx11-dev \
    libgtk-3-dev \
    && rm -rf /var/lib/apt/lists/*

# Installer wget et autres outils nécessaires pour télécharger Python
RUN apt-get update && apt-get install -y wget curl

# Télécharger et compiler Python 3.10. Vous pouvez ajuster la version si nécessaire
ENV PYTHON_VERSION=3.10.12
RUN wget https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tgz \
    && tar -xzf Python-${PYTHON_VERSION}.tgz \
    && cd Python-${PYTHON_VERSION} \
    && ./configure --enable-optimizations \
    && make -j$(nproc) \
    && make altinstall \
    && cd .. \
    && rm -rf Python-${PYTHON_VERSION} Python-${PYTHON_VERSION}.tgz

# Créer un lien symbolique pour python3.10
RUN ln -s /usr/local/bin/python3.10 /usr/bin/python3.10

# Mettre à jour pip
RUN python3.10 -m pip install --upgrade pip

# Installer les paquets Python nécessaires
RUN python3.10 -m pip install --no-cache-dir \
    pyinstaller \
    pillow \
    tkinter

# Créer un répertoire de travail pour l'application
WORKDIR /app
