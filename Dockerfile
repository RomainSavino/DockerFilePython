# Utiliser l'image de base NVIDIA CUDA 11.3.1 avec Ubuntu 20.04
FROM nvidia/cuda:11.3.1-runtime-ubuntu20.04
ENV DEBIAN_FRONTEND=noninteractive

# Mettre à jour et installer les dépendances nécessaires
RUN apt-get update && apt-get upgrade -y && apt-get install -y \
    software-properties-common tzdata locales gcc make git openssh-server curl iproute2 tshark \
    ffmpeg libsm6 libxext6 postgresql-client libopencv-dev pkg-config libboost-program-options-dev && \
    rm -rf /var/lib/apt/lists/* && \
    rm /bin/sh && ln -s /bin/bash /bin/sh

# replace SH with BASH 
RUN rm /bin/sh && ln -s /bin/bash /bin/sh
RUN ln -fs /usr/share/zoneinfo/Europe/Paris /etc/localtime \
  && dpkg-reconfigure --frontend noninteractive tzdata \
  && export LC_ALL="fr_FR.UTF-8" \
  && export LC_CTYPE="fr_FR.UTF-8" \
  && echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
  && echo "fr_FR.UTF-8 UTF-8" >> /etc/locale.gen \
  && locale-gen \
  && dpkg-reconfigure --frontend noninteractive locales
RUN mkdir -p /run/sshd

# Installer Python 3.10 et ses dépendances
RUN add-apt-repository ppa:deadsnakes/ppa && \
    apt-get update && apt-get install -y --no-install-recommends \
    python3.10 python3.10-venv python3.10-dev \
    build-essential libffi-dev libssl-dev libyaml-dev && \
    rm -rf /var/lib/apt/lists/*

# Créer et activer l'environnement virtuel
RUN python3.10 -m venv /venv
ENV PATH="/venv/bin:$PATH"

# Installer PyTorch version 1.11.0 avec CUDA 11.3
RUN pip install --no-cache-dir torch==1.11.0+cu113 torchvision==0.12.0+cu113 torchaudio==0.11.0+cu113 -f https://download.pytorch.org/whl/torch_stable.html

# Installer numpy version <2
RUN pip install "numpy<2"

# Installer les bibliothèques Python supplémentaires avec des versions compatibles
RUN pip install --no-cache-dir \
    matplotlib==3.7.1 \
    seaborn==0.12.2 \
    pandas \
    scikit-learn \
    Pillow

# Script de vérification
RUN echo 'import torch; print(f"PyTorch version: {torch.__version__}"); print(f"CUDA version: {torch.version.cuda}"); print(f"CUDA available: {torch.cuda.is_available()}"); print(f"Number of GPUs: {torch.cuda.device_count()}")' > /check_gpu.py

CMD ["python3.10", "/check_gpu.py"]
