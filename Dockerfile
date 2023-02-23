FROM nvidia/cuda:12.0.1-base-ubuntu22.04 
RUN export DEBIAN_FRONTEND=noninteractive \
  && apt-get update \
  && apt-get upgrade -y \
  && apt-get install -y \
  software-properties-common \
  tzdata locales \
  python3 python3-dev python3-pip python3-venv \
  gcc make git openssh-server curl iproute2 tshark \
  && rm -rf /var/lib/apt/lists/*
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
# Install jupyterlab and its plotly extension
RUN /venv/bin/pip3 install --no-cache-dir\
    jupyterlab>=3 \
    ipywidgets>=7.6 \
    jupyter-dash \
    ipython \
    ipykernel \
    ptvsd \
    plotly 
#Présents sur la version dockerfile donnée mais l'image ne se build pas avec 
#    eog \
#    libsm6 \
 #   libxext6 \
 #   wget
# install all other required python packages

RUN /venv/bin/pip3 install --no-cache-dir \
    abc  \
    ahrs  \
    alembic  \
    argparse  \
    beautifulsoup4  \
    bokeh  \
    collections  \
    copy  \
    csv  \
    dash  \
    dash-bootstrap-components  \
    dash_daq  \
    datetime  \
    docopt  \
    dpkt  \
    functools  \
    glob  \
    gpsd-py3  \
    gpxpy  \
    graphviz  \
    gunicorn  \
    gym  \
    hashlib  \
    h5py  \
    io  \
    ipympl  \
    itertools  \
    joblib  \
    json  \
    kaleido  \
    lxml  \
    mako  \
    math  \
    matplotlib  \
    multiprocessing  \
    numpy  \
    opencv-python  \
    openpyxl  \
    os  \
    pandas  \
    PIL  \
    pillow  \
    pprint  \
    psutil  \
    pylint  \
    pyserial  \
    python-dateutil  \
    random  \
    re  \
    requests  \
    requests_html  \
    scikit-commpy  \
    scikit-learn  \
    scipy  \
    seaborn  \
    setuptools  \
    shutil  \
    sqlalchemy  \
    struct  \
    sys  \
    tabulate  \
    tensorboardx  \
    tensorflow  \
    tifffile  \
    time  \
    torch  \
    torchvision  \
    typing  \
    uncompyle6  \
    visdom  \
    warnings  \
    xlrd  \
    xmltodict  
    

    


RUN mkdir -p /data
RUN mkdir -p /experiments
RUN mkdir -p /home/dms_search
WORKDIR /home/dms_search