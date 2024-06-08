# spark-glue-python
Apache Spark with AWS Glue metastore and Python docker image

# Features
Base Image: Uses sdaberdaku/spark-with-glue-builder:v3.5.1 as the base image.

Python Version: Uses Python 3.10.14-slim-bookworm.

User Setup: Creates a system user 'spark' with a specified UID and GID for running Spark processes.

Java and Other Packages: Installs OpenJDK 17, Tini, Procps, and Gettext-base.

Environment Variables: Sets up environment variables for Java, Spark, and Hadoop.

Spark and Hadoop Installation: Copies Spark and Hadoop binaries from the builder image to the specified directories.

Permissions: Adjusts ownership of Spark and Hadoop directories to the 'spark' user.

Entrypoint Setup: Copies and configures the entrypoint and decommission scripts for Spark.

Python Dependencies: Installs PySpark and other dependencies listed in the requirements.txt file.

## Included JARs
The current Docker image inherits a series of JARs from its builder image.

Here is a summary of the JAR files that are included in the Docker image (under /opt/spark/jars):
1. AWS Glue Data Catalog Spark Client JAR: `aws-glue-datacatalog-spark-client-3.5.1.jar`
2. AWS Java SDK bundle library: `aws-java-sdk-bundle-1.12.262.jar`
3. Hadoop AWS library: `hadoop-aws-3.3.4.jar`
4. Wildfly OpenSSL library: `wildfly-openssl-1.0.7.Final.jar`
5. PostgreSQL library: `postgresql-42.6.0.jar`
6. Checker Qual: `checker-qual-3.31.0.jar`
7. delta-spark: `delta-spark_2.12-3.2.0.jar`
8. antlr4-runtime: `antlr4-runtime-4.9.3.jar`
9. delta-storage: `delta-storage-3.2.0.jar`
10. delta-storage-s3-dynamodb: `delta-storage-s3-dynamodb-3.2.0.jar`

## Hadoop Native Libraries:

Hadoop native libraries are downloaded and installed in the /opt/hadoop directory.

## Instructions
Follow these instructions to build the Docker image:

1. Clone this repository:
```bash
git clone https://github.com/sebastiandaberdaku/spark-glue-python.git
cd spark-glue-python
docker build -t sdaberdaku/spark-glue-python:v3.5.1-python3.10.14 . --network host
docker push sdaberdaku/spark-glue-python:v3.5.1-python3.10.14
```
