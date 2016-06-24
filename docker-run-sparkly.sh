docker run --rm -it \
  --ulimit nofile=9999:9999 \
  -v "$(pwd)/conf/livy.conf":/apps/livy-server-0.3.0-SNAPSHOT/conf/livy.conf \
  -v "$(pwd)/docker-repos/docker-livy/upload":/apps/livy-server-0.3.0-SNAPSHOT/upload \
  -p 8998:8998 \
  --name sparkly local/livy-spark
