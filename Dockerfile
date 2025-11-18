FROM nvidia/cuda:12.2.0-base-ubuntu20.04

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

# Installer Python 3.9 depuis deadsnakes, incluant Tkinter
RUN add-apt-repository -y ppa:deadsnakes/ppa \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        python3.9 \
        python3.9-venv \
        python3.9-dev \
        python3.9-tk \
        build-essential \
        libffi-dev \
        libssl-dev \
        libyaml-dev \
    && rm -rf /var/lib/apt/lists/*

# Dépendances natives pour Basemap (GEOS, PROJ)
RUN apt-get update && apt-get install -y libgeos-dev libproj-dev && rm -rf /var/lib/apt/lists/*

# Créer et activer l’environnement virtuel
RUN mkdir -p /venv && python3.9 -m venv /venv

# Installer/mettre à jour pip, setuptools, wheel
RUN /venv/bin/python3.9 -m ensurepip --upgrade \
    && /venv/bin/python3.9 -m pip install --upgrade pip==21.3.1 setuptools==65.5.0 wheel==0.38.0

# Ajouter venv au PATH
ENV PATH="/venv/bin:$PATH"

# Paramètres pour rendu headless (évite les erreurs GUI)
ENV MPLBACKEND=Agg
ENV QT_QPA_PLATFORM=offscreen

# Installer les paquets Python nécessaires
RUN pip install --no-cache-dir \
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
    matplotlib==3.8.4 \
    mpmath==1.3.0 \
    networkx==3.2.1 \
    numpy==1.24.4 \
    opencv-python==4.11.0.86 \
    pandas\
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
    onnxruntime-tools \
    basemap \
    rasterio \
    ttkthemes \
    PyQt5==5.15.7

# Nettoyage final
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 8888

CMD ["/bin/bash"]
