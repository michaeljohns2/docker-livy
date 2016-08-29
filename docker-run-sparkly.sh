docker run --rm -it \
 --ulimit nofile=9999:9999 \
 -v "$(pwd)/conf/livy.conf":/apps/livy-server-0.3.0-SNAPSHOT/conf/livy.conf \
 -v "$(pwd)/upload":/apps/livy-server-0.3.0-SNAPSHOT/upload \
 -v "$(pwd)/spark-conf/spark-defaults.conf":/usr/local/spark/conf/spark-defaults.conf \
 -v "$(pwd)/entrypoint.sh":/entrypoint.sh \
 -p 8998:8998 \
 --name sparkly local/livy-spark
