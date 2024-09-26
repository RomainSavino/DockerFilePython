# Utiliser l'image de base NVIDIA CUDA 11.8.0 avec Ubuntu 20.04
FROM nvidia/cuda:11.8.0-runtime-ubuntu20.04

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Paris

# Mettre à jour et installer les dépendances nécessaires
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        software-properties-common tzdata locales gcc make git curl \
        ffmpeg libsm6 libxext6 postgresql-client libopencv-dev pkg-config libboost-program-options-dev && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone && \
    echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen && \
    echo "fr_FR.UTF-8 UTF-8" >> /etc/locale.gen && \
    locale-gen && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Installer Python 3.10 et ses dépendances
RUN add-apt-repository ppa:deadsnakes/ppa && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        python3.10 python3.10-venv python3.10-dev \
        build-essential libffi-dev libssl-dev libyaml-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Créer et activer l'environnement virtuel
RUN python3.10 -m venv /venv
ENV PATH="/venv/bin:$PATH"

# Mettre à jour pip et installer les packages de base
RUN pip install --no-cache-dir --upgrade pip setuptools wheel

# Installer PyTorch avec le support CUDA 11.8
RUN pip install --no-cache-dir torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu117

# Supprimer les dossiers inutiles pour libérer de l'espace
RUN rm -rf /usr/share/dotnet /opt/ghc /usr/local/share/boost /opt/hostedtoolcache

# À la fin du build, imprimer la version de torch
RUN python -c "import torch; print(f'Version de torch installée: {torch.__version__}')"
