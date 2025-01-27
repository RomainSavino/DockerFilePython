# Utiliser une image de base Ubuntu LTS
FROM ubuntu:22.04

# Définir les variables d'environnement pour éviter les interactions pendant l'installation
ENV DEBIAN_FRONTEND=noninteractive

# Mettre à jour les paquets et installer les dépendances de base
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y \
        build-essential \      
        python3 \          
        python3-pip \      
        python3-dev \          
        python3-tk \          
        libqt5widgets5 \      
        qt5-default \         
        libgl1-mesa-dev \     
        git \                  
        curl \             
        vim \           
        nano \          
        wget \           
        unzip \            
        zip \                
        ffmpeg \                  
        libsm6 libxext6 libxrender-dev \ 
    && rm -rf /var/lib/apt/lists/*

# Installer les packages Python nécessaires
RUN pip3 install --upgrade pip && \
    pip3 install \
        PyQt5 \               
        PyInstaller \            
        pandas \                
        numpy \               
        matplotlib \             
        requests \               
        sqlalchemy \            
        flask \                
        jupyter \               
        scikit-learn \           
        Pillow \                 
        beautifulsoup4 \         
        lxml \                    

# Configurer le répertoire de travail
WORKDIR /app

# Copier les fichiers de l'application dans le conteneur
COPY . /app

# Commande par défaut à exécuter lorsque le conteneur démarre
CMD ["bash"]
