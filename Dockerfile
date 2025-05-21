# Utiliser l'image de base NVIDIA CUDA 12.4 (avec toolkit) et Ubuntu 22.04
FROM nvidia/cuda:12.4.0-devel-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive

# Mettre à jour et installer les dépendances système
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

# remplacer /bin/sh par bash, config timezone & locales
RUN rm /bin/sh && ln -s /bin/bash /bin/sh \
 && ln -fs /usr/share/zoneinfo/Europe/Paris /etc/localtime \
 && dpkg-reconfigure --frontend noninteractive tzdata \
 && echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
 && echo "fr_FR.UTF-8 UTF-8" >> /etc/locale.gen \
 && locale-gen \
 && dpkg-reconfigure --frontend noninteractive locales \
 && export LC_ALL="fr_FR.UTF-8" \
 && export LC_CTYPE="fr_FR.UTF-8"

RUN mkdir -p /run/sshd

# Installer Python 3.10 et ses dépendances
RUN add-apt-repository ppa:deadsnakes/ppa \
 && apt-get update \
 && apt-get install -y --no-install-recommends \
      python3.10 \
      python3.10-venv \
      python3.10-dev \
      build-essential \
      libffi-dev \
      libssl-dev \
      libyaml-dev \
 && rm -rf /var/lib/apt/lists/*

# Créer et activer l'environnement virtuel
RUN mkdir -p /venv \
 && python3.10 -m venv /venv \
 && echo "PATH=/venv/bin:\$PATH" > /etc/profile.d/python_venv.sh

# Mettre à jour pip et setuptools
RUN /venv/bin/pip install --upgrade pip setuptools wheel

# Installer Cython
RUN /venv/bin/pip install "cython<3.0"

# Installer la majorité des packages Python, mise à jour de CuPy et ajout de cuDF
RUN /venv/bin/pip install --no-cache-dir \
        Flask flask Folium haversine jupyterlab ipywidgets jupyter-dash \
        ipython ipykernel ptvsd psycopg2-binary tensorflow keras \
        flask-restful flask-cors xgboost ahrs alembic argparse \
        beautifulsoup4 dash dash-bootstrap-components dash_daq \
        datetime docopt dpkt glob2 gpsd-py3 gpxpy graphviz \
        gunicorn gym h5py ipympl joblib kaleido lxml setuptools mako \
        matplotlib opencv-python openpyxl pandas pillow psutil \
        pylint pyserial python-dateutil requests requests_html \
        scikit-commpy scikit-learn scipy seaborn \
        sqlalchemy==1.4.1 tabulate tensorboard tifffile torch torchvision \
        uncompyle6 visdom xlrd xmltodict scikit-optimize optuna hyperopt \
        bashplotlib albumentations timm lightgbm ultralytics grad-cam \
        optuna-distributed kaleido geopandas gunicorn transformers  datasets \
        torchtext torchaudio accelerate torchsummary mlflow \
        cupy-cuda12x==13.3.0 \
        cudf-cu12==24 \
        --constraint https://rapids.ai/files/rapidsai/constraints-cuda12.txt

# Installer les outils Python complémentaires
RUN /venv/bin/pip install --no-cache-dir \
    pre-commit \
    progressbar==2.5 \
    pyrootutils==1.0.4 \
    pytest \
    rootutils==1.0.7 \
    setuptools \
    sh==2.0.6 \
    opencv-python \
    lightning \
    torchmetrics \
    hydra-core \
    hydra-colorlog \
    hydra-optuna-sweeper \
    omegaconf \
    onnxruntime==1.18.0 \
    onnx==1.16.0 \
    pickle5 \
    joblib \
    openvino-dev==2024.5.0 \
    mlflow-export-import \
    onnx-simplifier \
    onnxconverter-common \
    onnxruntime-tools \
    poethepoet \
    pre-commit \
    protobuf \
    ruff \
    scikit-image \
    thop \
    torch-pruning \
    torch-summary \
    jupyter \
    lakefs \
    neural-compressor \
    nncf

# Nettoyage final
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Point d'entrée par défaut
CMD ["/bin/bash"]
