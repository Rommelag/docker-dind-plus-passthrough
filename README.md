# docker-dind-plus-passthrough
The official docker:dind with Mellanox/docker-passthrough-plugin installed on top.

## How?
```
docker pull rommelag/dind-plus-passthrough
```

## Where
[Over at DockerHUB](https://hub.docker.com/r/rommelag/dind-plus-passthrough/)

## What / Why
Docker networking has some limitations. It can, for example, not easily pass host-managed devices into the containers NetNS. To redeem this, the great guys at [Mellanox](https://github.com/Mellanox) have written [a docker plugin/networking-driver](https://github.com/Mellanox/docker-passthrough-plugin).

The original Mellanox-Docker creates a container that runs the driver and is meant to back-inject the driver into a running host-sided-`dockerd` via `-v`-mounts. Contrary to this, we extend the original `docker:dind` with the Mellanox-Driver, thus creating a more convenient environment in which to run.
