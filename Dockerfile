FROM docker.io/padogrid/padogrid:0.9.30

USER 0

ARG USER=padogrid
ARG GROUP=padogrid
ARG USER_HOME=/opt/padogrid
ARG GRAFANA_VERSION=10.2.0

RUN curl -sL https://dl.grafana.com/enterprise/release/grafana-enterprise-${GRAFANA_VERSION}.linux-amd64.tar.gz | tar xz -C ${USER_HOME}/products
RUN chown -R $USER:$GROUP ${USER_HOME}/products/grafana-${GRAFANA_VERSION}
RUN echo "alias ll=\"ls -lisah\"" >> $USER_HOME/.bashrc

COPY --chown=$USER:$GROUP --chmod=+x scripts/*.sh ${USER_HOME}/

USER $USER

CMD ["/bin/bash" ".padogrid_start"]
