# Base image
FROM nvidia/cuda:12.2.0-base-ubuntu20.04

# Set the working directory
WORKDIR /app

# Install necessary dependencies for RedHat 8 (RHEL/CentOS) system
RUN apt-get update && apt-get install -y \
    python3.9 \
    python3.9-dev \
    python3.9-distutils \
    python3.9-venv \
    build-essential \
    cmake \
    git \
    libatlas-base-dev \
    libopencv-dev \
    libffi-dev \
    libglib2.0-0 \
    libsm6 \
    libxext6 \
    libxrender-dev \
    libfreetype6-dev \
    libpng-dev \
    libjpeg-dev \
    && apt-get clean

# Install pip for Python 3.9
RUN curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py && \
    python3.9 get-pip.py && \
    rm get-pip.py

# Upgrade pip and setuptools
RUN python3.9 -m pip install --upgrade pip setuptools

# Install Python libraries
RUN python3.9 -m pip install \
    cloudpickle==3.1.1 \
    cycler==0.12.1 \
    Farama-Notifications==0.0.4 \
    filelock==3.17.0 \
    fsspec==2024.12.0 \
    gym==0.21.0 \
    gymnasium==1.0.0 \
    importlib-metadata==4.13.0 \
    Jinja2==3.1.5 \
    kiwisolver==1.4.7 \
    MarkupSafe==3.0.2 \
    matplotlib==3.4.0 \
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
    matplotlib==3.4.0 \
    basemap \
    rasterio \
    ttkthemes \
    PyQt5==5.15.7 \
    && pip install --no-cache-dir -U matplotlib

# Install TKinter and other GUI libraries
RUN apt-get install -y python3.9-tk

# Install Basemap dependencies
RUN apt-get install -y libgeos-dev libproj-dev

# Set up the environment variables for CUDA
ENV PATH=/usr/local/cuda-12.2/bin:$PATH
ENV CUDADIR=/usr/local/cuda-12.2

# Set the default python version to python3.9
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3.9 1
RUN update-alternatives --install /usr/bin/pip pip /usr/local/bin/pip3 1

# Expose port for Jupyter or any services running
EXPOSE 8888

# Start a default interactive shell
CMD [ "bash" ]
