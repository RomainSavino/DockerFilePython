# Utiliser l'image de base NVIDIA CUDA 11.4.3 avec Ubuntu 20.04
FROM nvidia/cuda:11.3.1-runtime-ubuntu20.04
ENV DEBIAN_FRONTEND=noninteractive

# Mettre à jour et installer les dépendances nécessaires
RUN apt-get update && apt-get upgrade -y && apt-get install -y \
    software-properties-common tzdata locales gcc make git openssh-server curl iproute2 tshark \
    ffmpeg libsm6 libxext6 libopencv-dev pkg-config libboost-program-options-dev && \
    rm -rf /var/lib/apt/lists/*

# Configuration de la localisation
RUN ln -fs /usr/share/zoneinfo/Europe/Paris /etc/localtime \
    && dpkg-reconfigure --frontend noninteractive tzdata \
    && echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
    && echo "fr_FR.UTF-8 UTF-8" >> /etc/locale.gen \
    && locale-gen \
    && update-locale LANG=fr_FR.UTF-8

# Installer Python 3.10 et ses dépendances
RUN add-apt-repository ppa:deadsnakes/ppa && \
    apt-get update && apt-get install -y --no-install-recommends \
    python3.10 python3.10-venv python3.10-dev \
    build-essential libffi-dev libssl-dev libyaml-dev && \
    rm -rf /var/lib/apt/lists/*

# Créer et activer l'environnement virtuel
RUN python3.10 -m venv /venv
ENV PATH="/venv/bin:$PATH"

# Installer PyTorch version 1.12.1 avec CUDA 11.3
RUN pip install --no-cache-dir torch==1.11.0+cu113 torchvision==0.12.0+cu113 torchaudio==0.11.0+cu113 -f https://download.pytorch.org/whl/torch_stable.html
RUN pip install "numpy<2"
RUN echo 'import torch; print(f"PyTorch version: {torch.__version__}"); print(f"CUDA version: {torch.version.cuda}"); print(f"CUDA available: {torch.cuda.is_available()}"); print(f"Number of GPUs: {torch.cuda.device_count()}")' > /check_gpu.py

CMD ["python3.10", "/check_gpu.py"]
