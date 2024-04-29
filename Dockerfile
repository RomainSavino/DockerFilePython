# Stage 1: Python Setup
FROM python:3.10-slim-buster as python-base

# Set up environment
ENV DEBIAN_FRONTEND=noninteractive
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

# Python environment setup
RUN python -m venv /venv
ENV PATH="/venv/bin:$PATH"

# Install Python packages
RUN pip install --upgrade pip && \
    pip install --no-cache-dir Flask Folium haversine jupyterlab ipywidgets jupyter-dash \
    ipython ipykernel ptvsd psycopg2 tensorflow keras flask flask-restful flask-cors \
    xgboost ahrs alembic argparse beautifulsoup4 bokeh dash dash-bootstrap-components \
    dash_daq datetime docopt dpkt glob2 gpsd-py3 gpxpy graphviz gunicorn gym h5py ipympl \
    joblib kaleido lxml mako matplotlib numpy opencv-python openpyxl pandas pillow psutil \
    pylint pyserial python-dateutil requests requests_html scikit-commpy scikit-learn scipy \
    seaborn setuptools sqlalchemy tabulate tensorboard tifffile torch torchvision uncompyle6 \
    visdom xlrd xmltodict scikit-optimize optuna hyperopt bashplotlib albumentations timm \
    lightgbom ultralytics grad-cam optuna-distributed kaleido geopandas gunicorn transformers \
    datasets torchtext torchaudio

# Stage 2: NVIDIA CUDA Base
FROM nvidia/cuda:11.0.3-base-ubuntu20.04 as cuda-base

# Copy Python environment from python-base
COPY --from=python-base /venv /venv
ENV PATH="/venv/bin:$PATH"

# Install system dependencies
RUN apt-get update && apt-get upgrade -y && apt-get install -y \
    software-properties-common tzdata locales gcc make git openssh-server curl iproute2 tshark \
    ffmpeg libsm6 libxext6 && \
    rm -rf /var/lib/apt/lists/* && \
    rm /bin/sh && ln -s /bin/bash /bin/sh

# Set timezone and locale
RUN ln -fs /usr/share/zoneinfo/Europe/Paris /etc/localtime && \
    dpkg-reconfigure --frontend noninteractive tzdata && \
    echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen && \
    echo "fr_FR.UTF-8 UTF-8" >> /etc/locale.gen && \
    locale-gen && \
    dpkg-reconfigure --frontend noninteractive locales

# SSH setup
RUN mkdir -p /run/sshd

# Prepare working directory and data directories
RUN mkdir -p /data /experiments /home
WORKDIR /home

# Set command to run on container start
CMD ["/usr/sbin/sshd", "-D"]
