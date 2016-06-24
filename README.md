# docker-livy
A Docker image for [Livy, the REST Spark Server](https://github.com/cloudera/livy).

## Running 

##### Original (tobilg)
The image found in dockerhub can be run with (not local customization unless you rebuild it, see next section). 

`docker run -p 8998:8998 -d tobilg/livy`
which will expose the port `8998` on the Docker host for this image.

##### Customized
- build the dockerfile locally and tag it, e.g. `docker build -t local/livy-spark:latest .`
- can expose volumes from which to customize configuration (example belows assumes overlay driver, e.g. centos host config [here](https://gist.github.com/cpswan/4dd60dd3b000a514f6bf))
`docker run --rm -it \
  --ulimit nofile=9999:9999 \
  -v "$(pwd)/conf/livy.conf":/apps/livy-server-0.3.0-SNAPSHOT/conf/livy.conf \
  -v "$(pwd)/docker-repos/docker-livy/upload":/apps/livy-server-0.3.0-SNAPSHOT/upload \
  -p 8998:8998 \
  --name sparkly local/livy-spark`

## Details

Have a look at the [official docs](https://github.com/cloudera/livy#rest-api) to see how to use the Livy REST API.
