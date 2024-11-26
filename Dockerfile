# Utiliser l'image de base Ubuntu 20.04
FROM ubuntu:20.04

# Installer les dépendances nécessaires
RUN apt-get update && apt-get install -y \
    wget \
    unzip \
    libgomp1 \
    libasound2 \
    libatk1.0-0 \
    libc6 \
    libcairo2 \
    libdbus-1-3 \
    libfontconfig1 \
    libfreetype6 \
    libgcc1 \
    libgdk-pixbuf2.0-0 \
    libglib2.0-0 \
    libgtk2.0-0 \
    libnspr4 \
    libpango-1.0-0 \
    libstdc++6 \
    libx11-6 \
    libxcomposite1 \
    libxcursor1 \
    libxdamage1 \
    libxext6 \
    libxfixes3 \
    libxft2 \
    libxi6 \
    libxrandr2 \
    libxrender1 \
    libxtst6 \
    zlib1g \
    libnss3 \
    libssl1.1

# Définir le dossier de travail pour MATLAB Runtime
WORKDIR /opt/mcr

# Télécharger et installer MATLAB Runtime R2020b

# Télécharger et installer MATLAB Runtime R2020b

RUN
 wget -O /tmp/MATLAB_Runtime_R2020b_glnxa64.zip 
"https://ssd.mathworks.com/supportfiles/downloads/R2020b/Release/8/deployment_files/installer/complete/glnxa64/MATLAB_Runtime_R2020b_Update_8_glnxa64.zip"
 && 
\

    unzip /tmp/MATLAB_Runtime_R2020b_glnxa64.zip -d /tmp/matlab_runtime && 
\

    /tmp/matlab_runtime/install -mode silent -agreeToLicense yes -destinationFolder /opt/mcr

# Définir les variables d'environnement pour MATLAB Runtime R2020b
ENV LD_LIBRARY_PATH=/opt/mcr/v98/runtime/glnxa64:/opt/mcr/v98/bin/glnxa64:/opt/mcr/v98/sys/os/glnxa64:/opt/mcr/v98/extern/bin/glnxa64
ENV XAPPLRESDIR=/opt/mcr/v98/X11/app-defaults

# Définir le dossier de travail pour l'exécutable
WORKDIR /app

# Définir l'entrée par défaut (modifiable lors de l'exécution)
ENTRYPOINT ["./votre_executable"]
