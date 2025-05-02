# mbentley/sabnzbd

docker image for sabnzbd (from source)
based off of debian:bookworm

## Tags

* `latest`, `4.5`, `4` ([Dockerfile](./Dockerfile))
* `4.4`  ([Dockerfile](./Dockerfile))
* `rc` ([Dockerfile](./Dockerfile))

### Archived Tags

These tags still exist but are no longer getting security updates:

* `4.3`  ([Dockerfile](./Dockerfile))
* `4.2` ([Dockerfile](./Dockerfile))
* `4.1` ([Dockerfile](./Dockerfile))
* `4.0` ([Dockerfile](./Dockerfile))
* `3.7`, `3` ([Dockerfile](./Dockerfile))

To pull this image:
`docker pull mbentley/sabnzbd`

Example usage:
`docker run -d -p 8080:8080 --restart=always -v /data/sabnzbd:/etc/sabnzbd mbentley/sabnzbd`

Note: In this example, all contents of `/data/sabnzbd` must be owned by `501:501` on the host.

To build the pre-release version, set the build-arg `SABNZBD_PRERELEASE` to `true`.
