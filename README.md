# padogrid-hazelmon

## Introduction

Repository to host all stuff necessary for building a monitoring-ready image on top of a [PadoGrid image](https://hub.docker.com/r/padogrid/padogrid/tags). 

For the PadoGrid sources, please refer to [this](https://github.com/padogrid#padogrid) repository over on GitHub. 

The PadoGrid base image the `padogrid-hazelmon` image builds on comes with a couple of very useful Grafana dashboards for monitoring Hazelcast clusters. What the `padogrid-hazelmon` image adds on top is both Grafana itself plus a couple of scripts to configure it and import said dashboards so everything's nicely set up once the image is started as a container. 

Thanks to the base image's Grafana dashboards, the focus of this repository, and the `padogrid-hazelmon` image, is clearly the monitoring of Hazelcast clusters, but since the dashboards rely on metrics scraped by Prometheus and the image's configuration allows for a Prometheus endpoint to be specified (_requires_ one, in fact, see _Usage_ section below), you might as well use it for other purposes or in other contexts.

You can find a ready-to-use image based on this repository's [Dockerfile](./Dockerfile) on DockerHub in the form of the [`padogrid-hazelmon` image](https://hub.docker.com/r/antsinmyey3sjohnson/padogrid-hazelmon).

## Usage
Although the scripts contained in this repository perform much of the configuration work necessary for setting up Grafana and importing the base image's dashboards, there are two pieces of information that still have to be specified: 

* `PADO_MONITORING_HAZELCAST_METRICS_LABEL`: The label Prometheus has attached to the Hazelcast metrics to distinguish them between logical namespaces. For example, in a Kubernetes cluster, this is usually simply `namespace` or `kubernetes_namespace`. In case you do wish to use the `padogrid-hazelmon` image outside the context of Hazelcast cluster monitoring, simply set this to a dummy value.
* `PADO_MONITORING_PROMETHEUS_URL`: The URL of the Prometheus instance you wish this image's Grafana instance to read metrics from. In a Kubernetes cluster, the endpoint would typically be the FQDN of the Service object that provides access to the Prometheus Pod or Pods, i.e. something like this: `http://prometheus-service.prometheus.svc.cluster.local:9090`

### Example For Plain Container Usage
In case you would like to spin up a simple container based on the `padogrid-hazelmon` image, the following command might come in handy:

```bash
docker run -it --rm \
    -e PADO_MONITORING_HAZELCAST_METRICS_LABEL=namespace \
    -e PADO_MONITORING_PROMETHEUS_URL=http://10.211.55.6:9090 \
    antsinmyey3sjohnson/padogrid-hazelmon:0.9.32.0
```

(For usage in Podman, simply provide `podman` rather than `docker` in the above command.)

### Example For Helm Chart Usage
Hazeltest's monitoring stack makes extensive use of the `padogrid-hazelmon` image, and you can find a Helm chart that deploys the image to a Kubernetes cluster in Hazeltest's [`resources/charts` directory](https://github.com/AntsInMyEy3sJohnson/hazeltest/tree/main/resources/charts).


