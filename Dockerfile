FROM nvidia/cuda:12.2.0-base-ubuntu20.04

ENV DEBIAN_FRONTEND=noninteractive

# Install necessary dependencies
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

# Replace SH with BASH
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

# Install Python 3.9 and its dependencies
RUN add-apt-repository ppa:deadsnakes/ppa \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        python3.9 \
        python3.9-venv \
        python3.9-dev \
        build-essential \
        libffi-dev \
        libssl-dev \
        libyaml-dev \
    && rm -rf /var/lib/apt/lists/*

# Create and activate the virtual environment
RUN mkdir -p /venv
RUN python3.9 -m venv /venv

# Ensure pip is installed and up-to-date
RUN /venv/bin/python3.9 -m ensurepip --upgrade
RUN /venv/bin/python3.9 -m pip install --upgrade pip==21.3.1 setuptools==65.5.0 wheel==0.38.0

# Install necessary Python packages
ENV PATH="/venv/bin:$PATH"
RUN pip install --no-cache-dir \
    cloudpickle==3.1.1 \
    cycler==0.12.1 \
    Farama-Notifications==0.0.4 \
    filelock==3.17.0 \
    fsspec==2024.12.0 \
    gym==0.21.0 \
    gymnasium==1.0.0 \
    importlib-metadata==4.13.0 \
    Jinja2==3.1.5 \
    jupyterlab \
    kiwisolver==1.4.7 \
    MarkupSafe==3.0.2 \
    matplotlib==3.8.4 \
    mpmath==1.3.0 \
    networkx==3.2.1 \
    numpy==1.24.4 \
    opencv-python==4.11.0.86 \
    pandas==1.3.0 \
    pillow==11.1.0 \
    pygame==2.6.1 \
    pyparsing==3.2.1 \
    python-dateutil==2.9.0.post0 \
    pytz==2024.2 \
    scipy==1.9.0 \
    six==1.17.0 \
    stable_baselines3==2.4.1 \
    sympy==1.13.1 \
    torch==2.5.1 \
    typing_extensions==4.12.2 \
    zipp==3.21.0 \
    onnxruntime==1.18.0 \
    onnx \
    onnx-simplifier \
    onnxconverter-common \
    onnxruntime-tools \
    basemap \
    rasterio \
    ttkthemes \
    PyQt5==5.15.7 

# Install Tkinter and other GUI libraries
RUN apt-get install -y python3.9-tk

# Install Basemap dependencies
RUN apt-get install -y libgeos-dev libproj-dev

# Final cleanup
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 8888

CMD ["/bin/bash"]
