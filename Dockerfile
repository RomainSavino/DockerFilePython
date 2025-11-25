FROM nvidia/cuda:12.2.0-base-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive

# Mise à jour et installation des dépendances de base
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
    libgl1-mesa-glx \
    libglib2.0-0 \
    && rm -rf /var/lib/apt/lists/*

# Activer le dépôt universe (pour libgeos-dev, libproj-dev, etc.)
RUN add-apt-repository -y universe && apt-get update && rm -rf /var/lib/apt/lists/*

# Remplacer sh par bash
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# Configuration du fuseau horaire et des locales
RUN ln -fs /usr/share/zoneinfo/Europe/Paris /etc/localtime \
    && dpkg-reconfigure --frontend noninteractive tzdata \
    && export LC_ALL="fr_FR.UTF-8" \
    && export LC_CTYPE="fr_FR.UTF-8" \
    && echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
    && echo "fr_FR.UTF-8 UTF-8" >> /etc/locale.gen \
    && locale-gen \
    && dpkg-reconfigure --frontend noninteractive locales

RUN mkdir -p /run/sshd

# Installer Python 3.11 depuis les dépôts officiels d'Ubuntu 22.04
RUN apt-get update && apt-get install -y \
    python3.11 \
    python3.11-venv \
    python3.11-dev \
    python3.11-tk \
    build-essential \
    libffi-dev \
    libssl-dev \
    libyaml-dev \
    && rm -rf /var/lib/apt/lists/*

# Créer et activer l’environnement virtuel
RUN python3.11 -m venv /venv

# Installer/mettre à jour pip, setuptools, wheel
RUN /venv/bin/python3.11 -m ensurepip --upgrade \
    && /venv/bin/python3.11 -m pip install --upgrade pip==21.3.1 setuptools==65.5.0 wheel==0.38.0

# Ajouter venv au PATH
ENV PATH="/venv/bin:$PATH"

# Paramètres pour rendu headless (évite les erreurs GUI)
ENV MPLBACKEND=Agg
ENV QT_QPA_PLATFORM=offscreen

# Installer les paquets Python nécessaires pour RL et MLflow
RUN pip install --no-cache-dir \
    cloudpickle \
    cycler \
    Farama-Notifications \
    filelock \
    fsspec \
    gym \
    gymnasium \
    importlib-metadata \
    Jinja2 \
    jupyterlab \
    kiwisolver \
    MarkupSafe \
    matplotlib \
    mpmath \
    networkx \
    numpy \
    opencv-python \
    pandas \
    pillow \
    pygame \
    pyparsing \
    python-dateutil \
    pytz \
    scipy \
    six \
    stable-baselines3 \
    sympy \
    torch \
    typing_extensions \
    zipp \
    mlflow \
    onnxruntime==1.18.0 \
    onnx \
    onnx-simplifier \
    onnxconverter-common \
    onnxruntime-tools \
    basemap \
    rasterio \
    ttkthemes \
    PyQt5 \
    h5py \
    tensorboard \
    ray[rllib] \
    stable-baselines3[extra] \
    tensorflow-probability

# Nettoyage final
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 8888

CMD ["/bin/bash"]
