# mbentley/sabnzbd

docker image for sabnzbd (from source)
based off of debian:bookworm

## Tags

* `latest`, `4.2`, `4` ([Dockerfile](./Dockerfile))
* `4.1`, ([Dockerfile](./Dockerfile))
* `4.0`, ([Dockerfile](./Dockerfile))
* `3.7`, `3` ([Dockerfile](./Dockerfile))
* `rc` ([Dockerfile.rc](./Dockerfile.rc))

To pull this image:
`docker pull mbentley/sabnzbd`

Example usage:
`docker run -d -p 8080:8080 --restart=always -v /data/sabnzbd:/etc/sabnzbd mbentley/sabnzbd`

Note: In this example, all contents of `/data/sabnzbd` must be owned by `501:501` on the host.
