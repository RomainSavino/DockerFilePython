FROM nvidia/cuda:11.0.3-base-ubuntu20.04 

RUN export DEBIAN_FRONTEND=noninteractive \
  && apt-get update \
  && apt-get upgrade -y \
  && apt-get install -y \
  software-properties-common \
  tzdata locales \
  python3 python3-dev python3-pip python3-venv \
  gcc make git openssh-server curl iproute2 tshark zip unzip \
  nvidia-utils-460 \
  && rm -rf /var/lib/apt/lists/*

#dependences pour OpenCv
RUN apt-get update && apt-get install ffmpeg libsm6 libxext6  -y


# replace SH with BASH 
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# Locales gen
RUN ln -fs /usr/share/zoneinfo/Europe/Paris /etc/localtime \
  && dpkg-reconfigure --frontend noninteractive tzdata \
  && export LC_ALL="fr_FR.UTF-8" \
  && export LC_CTYPE="fr_FR.UTF-8" \
  && echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
  && echo "fr_FR.UTF-8 UTF-8" >> /etc/locale.gen \
  && locale-gen \
  && dpkg-reconfigure --frontend noninteractive locales

# SSH run folder
RUN mkdir -p /run/sshd

# create python venv
RUN mkdir -p /venv \
  && python3 -m venv /venv/

RUN echo "PATH=/venv/bin:$PATH" > /etc/profile.d/python_venv.sh

RUN /venv/bin/pip3 install --upgrade pip --no-cache-dir

# Install Pyinstaller 
RUN /venv/bin/pip3 install pyinstaller --no-cache-dir

# Install jupyterlab and its plotly extension
RUN /venv/bin/pip3 install --no-cache-dir\
    jupyterlab>=3 \
    ipywidgets>=7.6 \
    jupyter-dash==0.4.2 \
    ipython==8.11.0 \
    ipykernel==6.21.2 \
    ptvsd==4.3.2 \
    plotly==5.13.1 


# install all other required python packages
# Not adding basics python libraries, but we can import them in code directly
RUN /venv/bin/pip3 install --no-cache-dir \
    ahrs==0.3.1  \
    alembic==1.10.1  \
    argparse==1.1  \
    beautifulsoup4==4.11.2  \
    bokeh==3.0.3  \
    dash==2.8.1  \
    dash-bootstrap-components  \
    dash_daq==0.5.0  \
    datetime  \
    docopt==0.6.2  \
    dpkt==1.9.8  \
    glob2==0.7  \ 
    gpsd-py3  \
    gpxpy==1.5.0 \
    graphviz==0.20.1  \
    gunicorn==20.1.0  \
    gym==0.26.2  \
    h5py==3.8.0  \
    ipympl==0.9.3  \
    joblib==1.2.0  \
    kaleido==0.2.1  \ 
    lxml==4.9.2 \
    mako==1.2.4  \
    matplotlib  \
    numpy==1.24.2  \
    opencv-python  \
    openpyxl==3.1.1  \
    pandas==1.5.3  \
    pillow  \
    psutil==5.9.4  \
    pylint==2.16.4  \
    pyserial  \
    python-dateutil  \
    requests==2.28.2  \
    requests_html  \
    scikit-commpy  \
    scikit-learn  \
    scipy==1.10.1  \
    seaborn==0.12.2  \
    setuptools==44.0.0  \
    sqlalchemy==2.0.5.post1  \
    tabulate==0.9.0  \
    tensorboard==2.12.0 \
    tifffile==2023.2.28  \
    torch==1.13.1  \ 
    torchvision==0.14.1  \
    uncompyle6==3.9.0  \
    visdom==0.2.4  \
    xlrd==2.0.1  \
    xmltodict==0.13.0 \
    scikit-optimize \
    optuna \
    hyperopt \
    bashplotlib \
    albumentations \
    timm \
    lightgbm \
    ultralytics \
    grad-cam \
    optuna-distributed \
    folium \
    plotly \
    kaleido \
    geopandas \
    PyQt5 \
    pymysql \
    cryptography \
    pg8000 \
    asyncpg \
    pgdb \
    psycopg2-binary \
    transformers \
    torchaudio \
    cudatoolkit==11.1
    

#Create Directories
RUN mkdir -p /data
RUN mkdir -p /experiments
RUN mkdir -p /home/
WORKDIR /home/
