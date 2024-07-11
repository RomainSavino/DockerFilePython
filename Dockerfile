# Utiliser l'image de base NVIDIA CUDA 11.4.3 avec Ubuntu 20.04
FROM nvidia/cuda:11.4.3-runtime-ubuntu20.04
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
RUN pip install --no-cache-dir torch==1.12.1+cu113 torchvision==0.13.1+cu113 torchaudio==0.12.1 --extra-index-url https://download.pytorch.org/whl/cu113

# Mettre à jour pip et installer les packages nécessaires
RUN pip install --upgrade pip setuptools wheel
RUN pip install "cython<3.0"

# Installer scikit-learn en dernier pour éviter les conflits de versions avec torch
RUN pip install --no-cache-dir scikit-learn

# Installer les autres packages nécessaires
RUN pip install --no-cache-dir jupyterlab ipywidgets jupyter-dash \
    ipython ipykernel ptvsd tensorflow keras \
    xgboost ahrs alembic argparse beautifulsoup4 dash dash-bootstrap-components \
    dash_daq datetime docopt dpkt glob2 gpsd-py3 gpxpy graphviz gunicorn gym h5py ipympl \
    joblib kaleido lxml setuptools mako matplotlib opencv-python openpyxl pandas pillow psutil \
    pylint pyserial python-dateutil requests requests_html scikit-commpy scipy \
    seaborn sqlalchemy==1.4.1 tabulate tensorboard tifffile visdom xlrd xmltodict scikit-optimize \
    optuna hyperopt albumentations timm  optuna-distributed \
    kaleido geopandas gunicorn datasets torchtext \
    hydra-optuna-sweeper omegaconf joblib lightning

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Installer les autres packages nécessaires
RUN pip install --no-cache-dir pre-commit \
    pyrootutils==1.0.4 \
    pytest \
    rootutils==1.0.7 \
    setuptools \
    sh==2.0.6 \
    opencv-python
