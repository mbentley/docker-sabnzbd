FROM debian:jessie
MAINTAINER Matt Bentley <mbentley@mbentley.net>

RUN (sed -i 's/main/main contrib non-free/g' /etc/apt/sources.list &&\
  apt-get update &&\
  DEBIAN_FRONTEND=noninteractive apt-get install -y sabnzbdplus)
RUN (ln -sf /usr/share/zoneinfo/US/Eastern /etc/localtime &&\
  groupadd -g 501 sabnzbd &&\
  useradd -u 501 -g 501 -d /etc/sabnzbd sabnzbd &&\
  mkdir /etc/sabnzbd &&\
  chown -R sabnzbd:sabnzbd /etc/sabnzbd)

USER sabnzbd
EXPOSE 8080
ENTRYPOINT ["/usr/bin/sabnzbdplus","--config-file","/etc/sabnzbd","--browser","0","--console","--server"]
CMD [":8080"]
