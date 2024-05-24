# Utiliser une image de base Ubuntu
FROM ubuntu:20.04

# Définir les arguments de build
ARG DEBIAN_FRONTEND=noninteractive

# Mettre à jour les paquets et installer les outils de base
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    git \
    wget \
    curl \
    vim \
    sudo \
    && rm -rf /var/lib/apt/lists/*

# Installer Python 3 et pip
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    && ln -s /usr/bin/python3 /usr/bin/python \
    && rm -rf /var/lib/apt/lists/*

# Installer les dépendances pour ONNX et PyTorch
RUN pip install numpy onnx

# Installer LibTorch
RUN wget https://download.pytorch.org/libtorch/cu113/libtorch-shared-with-deps-1.8.1%2Bcu113.zip \
    && unzip libtorch-shared-with-deps-1.8.1+cu113.zip \
    && rm libtorch-shared-with-deps-1.8.1+cu113.zip \
    && mv libtorch /usr/local/

# Définir les variables d'environnement pour LibTorch
ENV TORCH_PATH=/usr/local/libtorch
ENV LD_LIBRARY_PATH=${TORCH_PATH}/lib:$LD_LIBRARY_PATH

# Installer protobuf
RUN apt-get update && apt-get install -y \
    protobuf-compiler \
    libprotobuf-dev \
    && rm -rf /var/lib/apt/lists/*

# Installer OpenCV (optionnel, si besoin pour traitement d'image)
RUN apt-get update && apt-get install -y \
    libopencv-dev \
    && rm -rf /var/lib/apt/lists/*

# Définir le répertoire de travail
WORKDIR /workspace

# Copier les fichiers de votre projet (si nécessaire)
# COPY . /workspace

# Exemple de commande pour construire un projet C++
# RUN mkdir -p build && cd build && cmake .. && make

# Commande par défaut
CMD ["/bin/bash"]
