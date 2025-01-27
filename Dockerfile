FROM centos:7.9.2009

# Patcher les fichiers .repo pour pointer vers vault.centos.org
RUN sed -i 's|^mirrorlist=|#mirrorlist=|g' /etc/yum.repos.d/CentOS-Base.repo && \
    sed -i 's|^#baseurl=|baseurl=|g' /etc/yum.repos.d/CentOS-Base.repo && \
    sed -i 's|mirror.centos.org/centos/$releasever|vault.centos.org/7.9.2009|g' /etc/yum.repos.d/CentOS-Base.repo

# Mise à jour + installation
RUN yum -y update && yum -y install epel-release && yum clean all

# Ensuite, tu peux installer tes paquets comme Python 3, etc.
RUN yum -y groupinstall "Development Tools" && \
    yum -y install python36 python36-devel python36-setuptools python36-tkinter \
                   qt5-qtbase-devel git parted fdisk lsof xauth xorg-x11-server-Xorg && \
    yum clean all

# Liens symboliques
RUN ln -s /usr/bin/python3.6 /usr/bin/python3 || true && \
    ln -s /usr/bin/pip3.6 /usr/bin/pip3 || true && \
    pip3 install --upgrade pip

# Installer les librairies Python
RUN pip3 install --no-cache-dir numpy pandas matplotlib seaborn scikit-learn requests \
    pyinstaller openpyxl pyqt5

WORKDIR /app
CMD ["python3"]
