# 1. Image de base
FROM nvidia/cuda:12.4.0-base-ubuntu22.04

# 2. Variables d'environnement pour l'OS
ENV DEBIAN_FRONTEND=noninteractive \
    TZ=Europe/Paris \
    LC_ALL=fr_FR.UTF-8 \
    LC_CTYPE=fr_FR.UTF-8 \
    # Ajout du venv au PATH pour utiliser directement "python" et "pip"
    PATH="/venv/bin:$PATH"

# 3. Installation des dépendances système, configuration timezone/locales
RUN apt-get update && apt-get install -y --no-install-recommends \
    software-properties-common \
    tzdata locales gcc make git curl wget \
    openssh-server iproute2 tshark ffmpeg \
    libsm6 libxext6 libopencv-dev pkg-config \
    postgresql-client libboost-program-options-dev \
    gnupg ca-certificates \
    # Configuration Timezone
    && ln -fs /usr/share/zoneinfo/$TZ /etc/localtime \
    && dpkg-reconfigure --frontend noninteractive tzdata \
    # Configuration Locales
    && echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
    && echo "fr_FR.UTF-8 UTF-8" >> /etc/locale.gen \
    && locale-gen \
    && dpkg-reconfigure --frontend noninteractive locales \
    # Préparation SSH
    && mkdir -p /run/sshd \
    # Remplacement de SH par BASH
    && rm /bin/sh && ln -s /bin/bash /bin/sh \
    # Nettoyage apt
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# 4. Installation de Grafana et Python 3.10
RUN wget -q -O - https://packages.grafana.com/gpg.key | apt-key add - \
    && echo "deb https://packages.grafana.com/oss/deb stable main" | tee /etc/apt/sources.list.d/grafana.list \
    && add-apt-repository ppa:deadsnakes/ppa -y \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
    grafana \
    python3.10 python3.10-venv python3.10-dev \
    build-essential libffi-dev libssl-dev libyaml-dev \
    # Nettoyage apt
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# 5. Création de l'environnement virtuel Python et mise à jour des outils de base
RUN python3.10 -m venv /venv \
    && pip install --no-cache-dir --upgrade pip setuptools wheel "cython<3.0"

# 6. Installation des packages Python (nettoyés, sans doublons, compatibles CUDA 12)
RUN pip install --no-cache-dir \
    # Frameworks Web & API
    flask flask-restful flask-cors gunicorn dash dash-bootstrap-components dash_daq \
    # Manipulation de données et fichiers
    pandas scipy numpy h5py openpyxl xlrd xmltodict dpkt \
    # Deep Learning & Machine Learning
    tensorflow keras torch torchvision torchaudio accelerate torchsummary torchmetrics lightning \
    scikit-learn xgboost lightgbm ultralytics \
    # Computer Vision
    opencv-python pillow albumentations tifffile grad-cam \
    # Modèles, Optimisation & Déploiement
    transformers datasets torchtext timm onnx onnxruntime==1.18.0 skl2onnx openvino-dev==2024.5.0 \
    scikit-optimize optuna optuna-distributed hyperopt shap \
    # Base de données & MLOps
    mlflow sqlalchemy psycopg2-binary alembic \
    # Visualisation & Géospatial
    matplotlib seaborn ipympl bashplotlib graphviz folium haversine gpsd-py3 gpxpy geopandas kaleido \
    # Outils de développement, Jupyter & Divers
    jupyterlab ipywidgets jupyter-dash ipython ipykernel ptvsd \
    beautifulsoup4 requests requests_html lxml mako \
    psutil pylint python-dateutil tabulate tensorboard uncompyle6 docopt glob2 \
    joblib progressbar==2.5 pyrootutils==1.0.4 pytest rootutils==1.0.7 sh==2.0.6 \
    hydra-core hydra-colorlog hydra-optuna-sweeper omegaconf \
    # CuPy pour CUDA 12 (corrige l'erreur cupy-cuda110)
    cupy-cuda12x

# 7. Nettoyage final des fichiers temporaires
RUN rm -rf /tmp/* /var/tmp/*

# 8. Configuration de l'espace de travail
WORKDIR /workspace
# Optionnel : COPY your_files /workspace/

# 9. Point d'entrée
CMD ["/bin/bash"]
