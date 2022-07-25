# rebased/repackaged base image that only updates existing packages
FROM mbentley/debian:bullseye
LABEL maintainer="Matt Bentley <mbentley@mbentley.net>"

# install dependencies
RUN sed -i 's/main/main contrib non-free/g' /etc/apt/sources.list &&\
  apt-get update &&\
  DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y ca-certificates flac jq lame libffi-dev libssl-dev locales mkvtoolnix p7zip-full par2 python3-setuptools python3-pip unrar unzip wget &&\
  echo 'LANG="en_US.UTF-8"' >> /etc/default/locale &&\
  sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
  locale-gen &&\
  rm -rf /var/lib/apt/lists/*

# set major.minor version we want to install
ARG SABNZBD_MAJ_MIN="3.6"
ARG SABNZBD_VERSION

# install sabnzbd from source
RUN cd /tmp &&\
  SABNZBD_VERSION="$(if [ -z "${SABNZBD_VERSION}" ]; then wget -q -O - https://api.github.com/repos/sabnzbd/sabnzbd/releases | jq -r '.[]|.tag_name' | grep -F "${SABNZBD_MAJ_MIN}." | grep -viE '(RC)|(Beta)' | head -n 1; else echo "${SABNZBD_VERSION}"; fi)" &&\
  wget -nv "https://github.com/sabnzbd/sabnzbd/releases/download/${SABNZBD_VERSION}/SABnzbd-${SABNZBD_VERSION}-src.tar.gz" &&\
  tar xvf "SABnzbd-${SABNZBD_VERSION}-src.tar.gz" &&\
  rm "SABnzbd-${SABNZBD_VERSION}-src.tar.gz" &&\
  mv "SABnzbd-${SABNZBD_VERSION}" /opt/sabnzbd &&\
  cd /opt/sabnzbd &&\
  python3 -m pip install --no-cache-dir -r requirements.txt -U

# install nzb-notify (https://github.com/caronc/nzb-notify)
RUN cd /tmp &&\
  NZB_NOTIFY_VERSION="$(if [ -z "${NZB_NOTIFY_VERSION}" ]; then wget -q -O - https://api.github.com/repos/caronc/nzb-notify/releases | jq -r '.[]|.tag_name' | head -n 1; else echo "${NZB_NOTIFY_VERSION}"; fi)" &&\
  wget -nv "https://github.com/caronc/nzb-notify/archive/refs/tags/${NZB_NOTIFY_VERSION}.tar.gz" &&\
  tar xvf "${NZB_NOTIFY_VERSION}.tar.gz" &&\
  mv nzb-notify-* /opt/nzb-notify &&\
  rm "${NZB_NOTIFY_VERSION}.tar.gz" &&\
  cd /opt/nzb-notify &&\
  pip install --no-cache-dir -r requirements.txt &&\
  ln -s /usr/bin/python3 /usr/local/bin/python

# create non-root user
RUN ln -sf /usr/share/zoneinfo/US/Eastern /etc/localtime &&\
  groupadd -g 501 sabnzbd &&\
  useradd -u 501 -g 501 -d /etc/sabnzbd sabnzbd &&\
  mkdir -p /etc/sabnzbd/scripts &&\
  cd /etc/sabnzbd/scripts &&\
  ln -s /opt/nzb-notify/Notify.py . &&\
  ln -s /opt/nzb-notify/sabnzbd-notify.py . &&\
  ln -s /opt/nzb-notify/Notify . &&\
  chown -R sabnzbd:sabnzbd /etc/sabnzbd

# set default environment variables
ENV LANG=en_US.UTF-8 \
  LANGUAGE=en_US:en \
  LC_ALL=en_US.UTF-8

USER sabnzbd
EXPOSE 8080
WORKDIR /opt/sabnzbd
ENTRYPOINT ["python3","-OO","SABnzbd.py"]
CMD ["--config-file","/etc/sabnzbd","--browser","0","--console","--server",":8080"]
