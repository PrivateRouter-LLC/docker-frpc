FROM alpine:3.15

ARG FRP_VERSION

COPY entrypoint.sh /entrypoint.sh

RUN case "$(uname -m)" in \
        x86_64) ARCH='amd64';; \
        aarch64) ARCH='arm64';; \
        armv7l) ARCH='arm';; \
        *) echo "unsupported architecture $(uname -m)"; exit 1 ;; \
    esac; \
    cd /opt; \
    wget --no-check-certificate -c https://github.com/fatedier/frp/releases/download/v${FRP_VERSION}/frp_${FRP_VERSION}_linux_${ARCH}.tar.gz; \
    tar zxf frp_${FRP_VERSION}_linux_${ARCH}.tar.gz;  \
    cp frp_${FRP_VERSION}_linux_${ARCH}/frpc /usr/bin/; \
    mkdir -p /etc/frp; \
    cp frp_${FRP_VERSION}_linux_${ARCH}/frpc.ini /etc/frp; \
    rm -rf frp_${FRP_VERSION}_linux_${ARCH}.tar.gz frp_${FRP_VERSION}_linux_${ARCH}; \
    chmod +x /entrypoint.sh

ENTRYPOINT /entrypoint.sh
