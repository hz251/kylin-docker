FROM java:8-jre

MAINTAINER Kyligence Inc

WORKDIR /tmp

RUN set -x \
    && apt-get update && apt-get install -y wget vim telnet ntp \
    && update-rc.d ntp defaults

ARG MIRROE=www-us.apache.org

# Installing Kylin
ARG KYLIN_VERSION=2.5.2
# COPY apache-kylin-${KYLIN_VERSION}-bin-hbase1x.tar.gz .
RUN set -x \
    && wget -q https://${MIRROR}/dist/kylin/apache-kylin-${KYLIN_VERSION}/apache-kylin-${KYLIN_VERSION}-bin-hbase1x.tar.gz \
    && tar -xzvf apache-kylin-${KYLIN_VERSION}-bin-hbase1x.tar.gz -C /usr/local/ \
    && mv /usr/local/apache-kylin-${KYLIN_VERSION}-bin /usr/local/kylin
ENV KYLIN_HOME=/usr/local/kylin

# Setting the PATH environment variable
ENV PATH=$PATH:$JAVA_HOME/bin:$KYLIN_HOME/bin

# Cleanup
RUN rm -rf /tmp/*

WORKDIR /root
EXPOSE 7070

VOLUME /usr/local/kylin/logs

ENTRYPOINT ["sh", "-c", "/usr/local/kylin/bin/kylin.sh start; bash"]
