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
    python3-tk \
    libx11-dev \
    libgtk-3-dev \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Définir la version de Python à installer
ENV PYTHON_VERSION=3.10.12

# Télécharger, compiler et installer Python avec l'option --enable-shared
RUN wget https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tgz \
    && tar -xzf Python-${PYTHON_VERSION}.tgz \
    && cd Python-${PYTHON_VERSION} \
    && ./configure --enable-optimizations --enable-shared \
    && make -j$(nproc) \
    && make altinstall \
    && cd .. \
    && rm -rf Python-${PYTHON_VERSION} Python-${PYTHON_VERSION}.tgz

# Créer un lien symbolique pour python3.10
RUN ln -s /usr/local/bin/python3.10 /usr/bin/python3.10

# Ajouter /usr/local/lib au chemin des bibliothèques dynamiques et mettre à jour ldconfig
RUN echo "/usr/local/lib" > /etc/ld.so.conf.d/python3.10.conf \
    && ldconfig

# Mettre à jour pip
RUN python3.10 -m pip install --upgrade pip

# Installer les paquets Python nécessaires
RUN python3.10 -m pip install --no-cache-dir \
    pyinstaller \
    pillow \
    PIL \
    && ln -s /usr/local/lib/libpython3.10.so /usr/lib/libpython3.10.so

# Créer un répertoire de travail pour l'application
WORKDIR /app
