FROM nvidia/cuda:12.2.0-base-ubuntu22.04
ENV DEBIAN_FRONTEND=noninteractive

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
    libgl1-mesa-glx \
    libglib2.0-0 \
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

RUN apt-get update && apt-get install -y \
    python3.11 \
    python3.11-venv \
    python3.11-dev \
    python3.11-tk \
    build-essential \
    libffi-dev \
    libssl-dev \
    libyaml-dev \
    cmake \
    ninja-build \
    && rm -rf /var/lib/apt/lists/*

RUN python3.11 -m venv /venv

RUN /venv/bin/python3.11 -m ensurepip --upgrade \
    && /venv/bin/python3.11 -m pip install --upgrade pip setuptools wheel

ENV PATH="/venv/bin:$PATH"
ENV MPLBACKEND=Agg
ENV QT_QPA_PLATFORM=offscreen

RUN pip install --no-cache-dir \
    cloudpickle \
    cycler \
    Farama-Notifications \
    filelock \
    fsspec \
    gym \
    gymnasium \
    importlib-metadata \
    Jinja2 \
    jupyterlab \
    kiwisolver \
    MarkupSafe \
    matplotlib \
    mpmath \
    networkx \
    numpy \
    opencv-python \
    pandas \
    pillow \
    pygame \
    pyparsing \
    python-dateutil \
    pytz \
    scipy \
    six \
    stable-baselines3 \
    sympy \
    torch \
    typing_extensions \
    zipp \
    mlflow \
    optuna \
    "optuna-integration[mlflow]" \
    pyyaml \
    "onnxruntime>=1.20.0" \
    onnx \
    onnx-simplifier \
    onnxconverter-common \
    onnxruntime-tools \
    basemap \
    rasterio \
    ttkthemes \
    PyQt5 \
    h5py \
    tensorboard \
    "ray[rllib]" \
    "stable-baselines3[extra]" \
    tensorflow-probability

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 8888
CMD ["/bin/bash"]
