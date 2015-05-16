mbentley/sabnzbd
================

docker image for sabnzbd

To pull this image:
`docker pull mbentley/sabnzbd`

Example usage:
`docker run -d -p 8000:8080 -restart=always -v /data/sabnzbd:/etc/sabnzbd mbentley/sabnzbd 192.168.0.100:8080`

Note: In this example, all contents of `/data/sabnzbd` must be owned by `501:501` on the host.  The command at runtime `192.168.0.100:8080` specifies the ip and port to bind to as sabnzbd defaults to localhost only.
