# I am using the image defined in https://github.com/sebastiandaberdaku/spark-with-glue-builder/releases/tag/spark-v3.5.1
FROM sdaberdaku/spark-with-glue-builder:v3.5.1 AS builder

# Starting with a clean image
FROM python:3.10.14-slim-bookworm

ARG spark_uid=185

RUN groupadd --system --gid=${spark_uid} spark; \
    useradd  --system --uid=${spark_uid} --gid=spark --create-home spark

# INSTALL Java and other packages
RUN apt-get update; \
    apt-get install -y --no-install-recommends openjdk-17-jre tini procps gettext-base; \
    rm -rf /var/lib/apt/lists/*

ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
ENV SPARK_HOME=/opt/spark
ENV HADOOP_HOME=/opt/hadoop
ENV HADOOP_COMMON_LIB_NATIVE_DIR="${HADOOP_HOME}/lib/native"
ENV HADOOP_OPTS="${HADOOP_OPTS} -Djava.library.path=${HADOOP_HOME}/lib/native"
ENV PATH="${PATH}:/home/spark/.local/bin:${JAVA_HOME}/bin:${SPARK_HOME}/bin:${SPARK_HOME}/sbin:${HADOOP_HOME}/bin"

COPY --from=builder /opt/spark/dist/ ${SPARK_HOME}/
COPY --from=builder /opt/hadoop/ ${HADOOP_HOME}/

RUN chown -R spark:spark ${SPARK_HOME}/; \
    chown -R spark:spark ${HADOOP_HOME}/

RUN cp ${SPARK_HOME}/kubernetes/dockerfiles/spark/entrypoint.sh /opt/entrypoint.sh; \
    chmod a+x /opt/entrypoint.sh; \
    cp ${SPARK_HOME}/kubernetes/dockerfiles/spark/decom.sh /opt/decom.sh; \
    chmod a+x /opt/decom.sh

# switch to spark user
USER spark
WORKDIR /home/spark

COPY ./requirements.txt .
RUN pip install --no-cache-dir --trusted-host pypi.python.org --editable ${SPARK_HOME}/python -r requirements.txt

ENTRYPOINT ["/opt/entrypoint.sh"]