# Utiliser l'image de base NVIDIA CUDA 11.0.3 avec Ubuntu 20.04
FROM nvidia/cuda:11.0.3-base-ubuntu20.04

# Mettre à jour et installer les dépendances nécessaires
RUN apt-get update && apt-get upgrade -y && apt-get install -y \
    software-properties-common tzdata locales gcc make git openssh-server curl iproute2 tshark \
    ffmpeg libsm6 libxext6 && \
    rm -rf /var/lib/apt/lists/* && \
    rm /bin/sh && ln -s /bin/bash /bin/sh

# Installer Python 3.10 et ses dépendances
RUN add-apt-repository ppa:deadsnakes/ppa && \
    apt-get update && apt-get install -y --no-install-recommends \
    python3.10 python3.10-venv python3.10-dev \
    build-essential libffi-dev libssl-dev libyaml-dev && \
    rm -rf /var/lib/apt/lists/*

# Créer et activer l'environnement virtuel
RUN python3.10 -m venv /venv
ENV PATH="/venv/bin:$PATH"

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

# Définir la commande par défaut pour lancer un shell bash
CMD ["bash"]
