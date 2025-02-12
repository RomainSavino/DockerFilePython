# Utiliser l'image de base NVIDIA CUDA 12.4 avec Ubuntu 22.04
FROM nvidia/cuda:12.4.0-base-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive

# Mettre à jour et installer les dépendances nécessaires
RUN apt-get update && apt-get upgrade -y && apt-get install -y \
    software-properties-common \
    tzdata \
    locales \
    gcc \
    make \
    git \
    openssh-server \
    curl \
    iproute2 \
    tshark \
    ffmpeg \
    libsm6 \
    libxext6 \
    postgresql-client \
    libopencv-dev \
    pkg-config \
    libboost-program-options-dev \
    && rm -rf /var/lib/apt/lists/*

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

# Installer Python 3.9 et ses dépendances
RUN add-apt-repository ppa:deadsnakes/ppa \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        python3.9 \
        python3.9-venv \
        python3.9-dev \
        build-essential \
        libffi-dev \
        libssl-dev \
        libyaml-dev \
    && rm -rf /var/lib/apt/lists/*

# Créer et activer l'environnement virtuel
RUN mkdir -p /venv
RUN python3.9 -m venv /venv
RUN echo "PATH=/venv/bin:$PATH" > /etc/profile.d/python_venv.sh

# Mettre à jour pip et installer les packages nécessaires
RUN /venv/bin/pip install --upgrade pip setuptools wheel
RUN /venv/bin/pip install --no-cache-dir \
    cloudpickle==3.1.1 \
    cycler==0.12.1 \
    Farama-Notifications==0.0.4 \
    filelock==3.17.0 \
    fsspec==2024.12.0 \
    gym==0.21.0 \
    gymnasium==1.0.0 \
    importlib-metadata==4.13.0 \
    Jinja2==3.1.5 \
    jupyterlab \
    kiwisolver==1.4.7 \
    MarkupSafe==3.0.2 \
    matplotlib==3.4.0 \
    mpmath==1.3.0 \
    networkx==3.2.1 \
    numpy==1.24.4 \
    opencv-python==4.11.0.86 \
    pandas==1.3.0 \
    pillow==11.1.0 \
    pygame==2.6.1 \
    pyparsing==3.2.1 \
    python-dateutil==2.9.0.post0 \
    pytz==2024.2 \
    scipy==1.9.0 \
    six==1.17.0 \
    stable_baselines3==2.4.1 \
    sympy==1.13.1 \
    torch==2.5.1 \
    typing_extensions==4.12.2 \
    zipp==3.21.0 \
    onnxruntime==1.18.0 \
    onnx \
    onnx-simplifier \
    onnxconverter-common \
    onnxruntime-tools

# Nettoyage final
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Optionnel : Ajouter des fichiers ou configurations supplémentaires si nécessaire
# COPY your_files /workspace/

# Point d'entrée par défaut
CMD ["/bin/bash"]
