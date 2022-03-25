## Polynote Docker File

Polynote is a polyglot notebook developed by Netflix, allowing the user to mix and match Python, Scala/Spark, SQL and Vega cells and easily pass objects between them. 

### Example usage on Linux.

Build the docker image with `docker build -t polynote_docker`. 

Run the image using (for example):  
`docker run -dp {host_port}:{container_port} -v {host_wdir}:{container_wdir} polynote_docker:latest`  
where the host directory `host_wdir` is mapped to the container working directory `container_wdir`. In the example Docker file included here, the port 8192 is exposed. 

