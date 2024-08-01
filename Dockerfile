# Utilise une image de base Ubuntu
FROM ubuntu:20.04

# Empêche les invites de questions pendant l'installation des paquets
ENV DEBIAN_FRONTEND=noninteractive

# Met à jour les paquets existants et installe Firefox et ses dépendances
RUN apt-get update && \
    apt-get install -y firefox-esr \
                       x11-apps \
                       dbus-x11 \
                       xauth \
                       x11-xserver-utils \
                       libdbus-glib-1-2 \
                       libgtk-3-0 \
                       libasound2 && \
    apt-get clean

# Ajoute un utilisateur non-root pour exécuter Firefox
RUN useradd -ms /bin/bash firefox

# Définit l'utilisateur non-root comme utilisateur actuel
USER firefox

# Dossier de travail
WORKDIR /home/firefox

# Commande pour lancer Firefox
CMD ["firefox"]
