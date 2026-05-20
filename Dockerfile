FROM nvidia/cuda:12.2.0-base-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV PATH="/venv/bin:$PATH"
ENV MPLBACKEND=Agg
ENV QT_QPA_PLATFORM=offscreen

# ======================
# System packages
# ======================

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
    libgl1-mesa-glx \
    libglib2.0-0 \
    postgresql-client \
    libopencv-dev \
    pkg-config \
    libboost-program-options-dev \
    cmake \
    ninja-build \
    libproj-dev \
    proj-data \
    proj-bin \
    libgeos-dev \
    && rm -rf /var/lib/apt/lists/*

RUN add-apt-repository -y universe && apt-get update && rm -rf /var/lib/apt/lists/*

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

# ======================
# Python 3.11 + venv
# ======================

RUN apt-get update && apt-get install -y \
    python3.11 \
    python3.11-venv \
    python3.11-dev \
    python3.11-tk \
    build-essential \
    libffi-dev \
    libssl-dev \
    libyaml-dev \
    && rm -rf /var/lib/apt/lists/*

RUN python3.11 -m venv /venv

RUN /venv/bin/python3.11 -m ensurepip --upgrade \
    && /venv/bin/python3.11 -m pip install --upgrade pip setuptools wheel

# ======================
# Scientific core
# ======================

RUN pip install --no-cache-dir \
    cloudpickle \
    cycler \
    filelock \
    fsspec \
    importlib-metadata \
    Jinja2 \
    kiwisolver \
    MarkupSafe \
    mpmath \
    networkx \
    numpy \
    pandas \
    pillow \
    pyparsing \
    python-dateutil \
    pytz \
    scipy \
    six \
    sympy \
    typing_extensions \
    zipp \
    pyyaml \
    lxml \
    tabulate \
    xlrd \
    openpyxl \
    xmltodict \
    tifffile \
    scikit-image \
    scikit-learn \
    scikit-optimize \
    scikit-commpy \
    xgboost \
    lightgbm \
    seaborn \
    matplotlib \
    kaleido \
    geopandas \
    rasterio \
    haversine \
    gpxpy \
    graphviz \
    basemap

# ======================
# Web / API / Viz
# ======================

RUN pip install --no-cache-dir \
    Flask \
    flask-restful \
    flask-cors \
    gunicorn \
    requests \
    requests_html \
    beautifulsoup4 \
    Folium \
    dash \
    dash-bootstrap-components \
    dash_daq \
    jupyter-dash \
    streamlit \
    bashplotlib \
    psycopg2-binary \
    sqlalchemy \
    alembic

# ======================
# Jupyter / Dev tools
# ======================

RUN pip install --no-cache-dir \
    jupyterlab \
    ipywidgets \
    ipython \
    ipykernel \
    ipympl \
    jupyter \
    pre-commit \
    pytest \
    pylint \
    ruff \
    poethepoet \
    progressbar==2.5 \
    pyrootutils==1.0.4 \
    rootutils==1.0.7 \
    sh==2.0.6 \
    ptvsd \
    docopt \
    argparse \
    mako \
    protobuf

# ======================
# ML / DL frameworks
# ======================

RUN pip install --no-cache-dir \
    torch \
    torchvision \
    torchaudio \
    torchtext \
    torchmetrics \
    torchsummary \
    torch-summary \
    torch-pruning \
    thop \
    lightning \
    accelerate \
    tensorflow \
    keras \
    tensorflow-probability \
    transformers \
    datasets \
    timm \
    albumentations \
    ultralytics \
    grad-cam \
    nncf \
    neural-compressor

# ======================
# Reinforcement Learning
# ======================

RUN pip install --no-cache-dir \
    gym \
    gymnasium \
    Farama-Notifications \
    pygame \
    stable-baselines3 \
    "stable-baselines3[extra]" \
    "ray[rllib]"

# ======================
# Experiment tracking / HPO
# ======================

RUN pip install --no-cache-dir \
    mlflow \
    mlflow-export-import \
    optuna \
    "optuna-integration[mlflow]" \
    optuna-distributed \
    hyperopt \
    hydra-core \
    hydra-colorlog \
    hydra-optuna-sweeper \
    omegaconf \
    tensorboard \
    lakefs

# ======================
# ONNX / Optimization
# ======================

RUN pip install --no-cache-dir \
    "onnxruntime>=1.20.0" \
    onnx \
    onnx-simplifier \
    onnxconverter-common \
    onnxruntime-tools \
    openvino-dev==2024.5.0

# ======================
# Misc packages
# ======================

RUN pip install --no-cache-dir \
    h5py \
    joblib \
    psutil \
    pyserial \
    dpkt \
    glob2 \
    gpsd-py3 \
    ahrs \
    ttkthemes \
    PyQt5 \
    opencv-python \
    datetime \
    py-cpuinfo

# ======================
# CUDA 12.x extras (machine 1 only at runtime)
# ======================

RUN pip install --no-cache-dir \
    cupy-cuda12x==13.3.0 \
    cudf-cu12==24.12.0

# ======================
# Cleanup
# ======================

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 8888
CMD ["/bin/bash"]
