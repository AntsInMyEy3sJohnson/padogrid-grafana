FROM docker.io/padogrid/padogrid:0.9.32

USER 0

ENV USER=padogrid
ENV GROUP=padogrid
ENV USER_HOME=/opt/padogrid

ARG GRAFANA_VERSION=10.2.3
# Caution: To be filled by build tools like buildx
# Example:
# docker buildx build --push --platform linux/amd64,linux/arm64 --tag <your tag> .
# --> 'TARGETARCH' will contain 'amd64' and 'arm64', respectively
ARG TARGETARCH

RUN curl -sL https://dl.grafana.com/enterprise/release/grafana-enterprise-$GRAFANA_VERSION.linux-$TARGETARCH.tar.gz | tar xz -C $USER_HOME/products
RUN chown -R $USER:$GROUP $USER_HOME/products/grafana-v$GRAFANA_VERSION

COPY --chown=$USER:$GROUP --chmod=+x scripts/*.sh $USER_HOME/

USER $USER

ENTRYPOINT /bin/bash -c "source $USER_HOME/.bashrc && $USER_HOME/configure_and_launch_grafana.sh"

