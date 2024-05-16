# Base image with Python 3.10
FROM python:3.10-buster as python-base

ENV DEBIAN_FRONTEND=noninteractive
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8
ENV TZ=Europe/Paris

RUN echo 'tzdata tzdata/Areas select Europe' | debconf-set-selections
RUN echo 'tzdata tzdata/Zones/Europe select Paris' | debconf-set-selections

# Create a virtual environment with Python 3.10
RUN python3.10 -m venv /venv
ENV PATH="/venv/bin:$PATH"

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    libffi-dev \
    libssl-dev \
    python3.10-dev \
    libyaml-dev

# Upgrade pip and install packages inside the virtual environment
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

# CUDA base image
FROM nvidia/cuda:11.0.3-base-ubuntu20.04 as cuda-base

COPY --from=python-base /venv /venv
ENV PATH="/venv/bin:$PATH"

RUN apt-get update && apt-get upgrade -y && apt-get install -y \
    software-properties-common tzdata locales gcc make git openssh-server curl iproute2 tshark \
    ffmpeg libsm6 libxext6 && \
    rm -rf /var/lib/apt/lists/* && \
    rm /bin/sh && ln -s /bin/bash /bin/sh

RUN ln -fs /usr/share/zoneinfo/Europe/Paris /etc/localtime \
  && dpkg-reconfigure --frontend noninteractive tzdata \
  && export LC_ALL="fr_FR.UTF-8" \
  && export LC_CTYPE="fr_FR.UTF-8" \
  && echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
  && echo "fr_FR.UTF-8 UTF-8" >> /etc/locale.gen \
  && locale-gen \
  && dpkg-reconfigure --frontend noninteractive locales

RUN mkdir -p /run/sshd

RUN mkdir -p /data /experiments /home
WORKDIR /home
