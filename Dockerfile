# Utilise CentOS 7, dont la glibc est 2.17
FROM centos:7

# Mise à jour de base + dépôts EPEL
RUN yum -y update && \
    yum -y install epel-release && \
    yum clean all

# Installer les outils de compilation + Python 3.6 + dépendances graphiques
RUN yum -y groupinstall "Development Tools" && \
    yum -y install \
        cmake \
        python36 \
        python36-devel \
        python36-setuptools \
        python36-tkinter \
        qt5-qtbase-devel \
        git \
        parted \
        fdisk \
        lsof \
        xauth \
        xorg-x11-server-Xorg && \
    yum clean all

# Créer des liens symboliques pour appeler python3/pip3 facilement
RUN ln -s /usr/bin/python3.6 /usr/bin/python3 || true && \
    ln -s /usr/bin/pip3.6 /usr/bin/pip3 || true && \
    pip3 install --upgrade pip

# Installer les librairies Python nécessaires via pip
RUN pip3 install --no-cache-dir \
    numpy \
    pandas \
    matplotlib \
    seaborn \
    scikit-learn \
    requests \
    pyinstaller \
    openpyxl \
    pyqt5

# Définir le dossier de travail
WORKDIR /app

# (Optionnel) Copier votre code si besoin
# COPY . /app

CMD ["python3"]
