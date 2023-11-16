FROM docker.io/padogrid/padogrid:0.9.30

USER 0

ENV USER=padogrid
ENV GROUP=padogrid
ENV USER_HOME=/opt/padogrid

ARG GRAFANA_VERSION=10.2.0

RUN curl -sL https://dl.grafana.com/enterprise/release/grafana-enterprise-$GRAFANA_VERSION.linux-amd64.tar.gz | tar xz -C $USER_HOME/products
RUN chown -R $USER:$GROUP $USER_HOME/products/grafana-$GRAFANA_VERSION

COPY --chown=$USER:$GROUP --chmod=+x scripts/*.sh $USER_HOME/

USER $USER

ENTRYPOINT /bin/bash -c "source $USER_HOME/.bashrc && $USER_HOME/configure_and_launch_grafana.sh"

