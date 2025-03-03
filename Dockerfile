FROM rockylinux:9

# Installe dnf-plugins-core pour pouvoir utiliser "dnf download --resolve"
RUN dnf install -y dnf-plugins-core && \
    dnf clean all

# Crée un répertoire pour stocker les RPM téléchargés
WORKDIR /rpms

# Télécharge xorg-x11-xauth avec toutes ses dépendances
RUN dnf download --resolve xorg-x11-xauth
