# padogrid-grafana

Repository to host all stuff necessary for building a monitoring-ready image on top of a [PadoGrid image](https://hub.docker.com/r/padogrid/padogrid/tags). 

For the PadoGrid sources, please refer to [this](https://github.com/padogrid#padogrid) repository over on GitHub. 

The goal of building an image on top of PadoGrid is to include Grafana as well as some scripts to configure and start it in scope of the resulting container's entrypoint. 

The resulting image should support a wide range of scenarios -- for example, assuming the Prometheus instance Grafana gets pointed to in scope of configuration work contains some Hazelcast metrics, then one might think of a Helm chart that deploys the image in a Pod to a Kubernetes cluster, which then serves as the go-to monitoring station for whatever Hazelcast clusters export their metrics to the aforementioned Prometheus instance. 

The image should support being run as a standalone container outside a Kubernetes cluster, too, and therefore, the mechanisms for injecting the values necessary for configuring Grafana have to support both scenarios.
