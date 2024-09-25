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
RUN pip install --no-cache-dir torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118

Installer tous les paquets nécessaires en une seule commande
RUN pip install --no-cache-dir \
    torchmetrics==1.0.0 \
    torchtext==0.15.2 \
    accelerate==0.21.0 \
    haversine jupyterlab ipywidgets jupyter-dash \
    ipython ipykernel ptvsd psycopg2-binary tensorflow keras  \
    ahrs alembic argparse beautifulsoup4 dash dash-bootstrap-components \
    dash_daq datetime docopt dpkt glob2 gpsd-py3 gpxpy graphviz gunicorn gym h5py ipympl \
    joblib kaleido lxml mako matplotlib opencv-python openpyxl pandas pillow psutil \
    pylint pyserial python-dateutil scikit-commpy scikit-learn scipy \
    seaborn sqlalchemy==1.4.1 tabulate tensorboard tifffile uncompyle6 \
    visdom xlrd xmltodict scikit-optimize optuna bashplotlib albumentations \
    optuna-distributed kaleido geopandas torchsummary \
    mlflow \
    pre-commit \
    progressbar==2.5 \
    pyrootutils==1.0.4 \
    pytest \
    rootutils==1.0.7 \
    sh==2.0.6 \
    opencv-python \
    onnxruntime \
    omegaconf \
    onnx \
    pickle5 \
    joblib \
    docker

# Supprimer les dossiers inutiles pour libérer de l'espace
RUN rm -rf /usr/share/dotnet /opt/ghc /usr/local/share/boost /opt/hostedtoolcache

# À la fin du build, imprimer la version de torch
RUN python -c "import torch; print(f'Version de torch installée: {torch.__version__}')"
