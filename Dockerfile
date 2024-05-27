# Utiliser l'image de base NVIDIA CUDA 11.0.3 avec Ubuntu 20.04
FROM nvidia/cuda:11.0.3-base-ubuntu20.04
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
RUN mkdir -p /venv
RUN python3.10 -m venv /venv
RUN echo "PATH=/venv/bin:$PATH" > /etc/profile.d/python_venv.sh

# Mettre à jour pip et installer les packages nécessaires
RUN /venv/bin/pip install --upgrade pip setuptools wheel
RUN /venv/bin/pip install "cython<3.0"
RUN /venv/bin/pip install --no-cache-dir Flask Folium haversine jupyterlab ipywidgets jupyter-dash \
    ipython ipykernel ptvsd psycopg2-binary tensorflow keras flask flask-restful flask-cors \
    xgboost ahrs alembic argparse beautifulsoup4 dash dash-bootstrap-components \
    dash_daq datetime docopt dpkt glob2 gpsd-py3 gpxpy graphviz gunicorn gym h5py ipympl \
    joblib kaleido lxml setuptools mako matplotlib opencv-python openpyxl pandas pillow psutil \
    pylint pyserial python-dateutil requests requests_html scikit-commpy scikit-learn scipy \
    seaborn sqlalchemy tabulate tensorboard tifffile torch torchvision uncompyle6 \
    visdom xlrd xmltodict scikit-optimize optuna hyperopt bashplotlib albumentations timm \
    lightgbm ultralytics grad-cam optuna-distributed kaleido geopandas gunicorn transformers \
    datasets torchtext torchaudio

RUN /venv/bin/pip install --no-cache-dir pre-commit \
    progressbar==2.5 \
    pyrootutils==1.0.4 \
    pytest \
    rootutils==1.0.7 \
    setuptools \
    sh==2.0.6 \
    cupy-cuda110==12.3.0 \
    opencv-python \
    lightning \
    onnxruntime \
    torchmetrics \
    hydra-core \
    hydra-colorlog \
    hydra-optuna-sweeper \
    omegaconf \
    onnxruntime \
    onnx \
    pickle5 \
    joblib
