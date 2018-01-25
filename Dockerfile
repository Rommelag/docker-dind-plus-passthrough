# Thankfully both golang:latest and docker:dind use the same alpine … we just
# hope it stays this way!
FROM golang

# Pull docker-passthrough-plugin build-dependencies
RUN go get github.com/vishvananda/netlink github.com/Sirupsen/logrus \
	github.com/codegangsta/cli github.com/docker/go-plugins-helpers/network \
	github.com/docker/libnetwork/options github.com/docker/libnetwork/netlabel

# Clone to go-path-convenition location
RUN mkdir -p /go/src/github.com/gopher-net \
	&& git clone https://github.com/Mellanox/docker-passthrough-plugin.git /go/src/github.com/gopher-net/docker-passthrough-plugin
WORKDIR /go/src/github.com/gopher-net/docker-passthrough-plugin
# Build
RUN CGO_ENABLED=0 go install -v

# Multistage-build this artifact into docker-dind
FROM docker:dind

COPY --from=0 /go/bin/docker-passthrough-plugin /usr/local/bin/
RUN mkdir /etc/docker \
	&& echo '{"ipv6":true, "fixed-cidr-v6": "fd4b:02f8:9d37:5621::/64"}' > /etc/docker/daemon.json

# … And emulate the original entrypoint / cmd
ENTRYPOINT ["sh", "-c", "/usr/local/bin/docker-passthrough-plugin & /usr/local/bin/dockerd-entrypoint.sh"]
CMD sh
