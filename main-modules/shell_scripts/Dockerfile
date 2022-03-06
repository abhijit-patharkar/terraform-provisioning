#This is a sample Image
FROM ubuntu
MAINTAINER demousr@gmail.com
ARG alarm_action
RUN apt-get update
RUN apt-get -y upgrade
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get -y install curl
RUN apt-get -y install awscli
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install tzdata
EXPOSE 80
CMD [“echo”,”Image created Metrics”]
COPY ./ ./
RUN echo "instance id is $instance_id"
RUN chmod +x /metrics.sh
RUN bash /metrics.sh metric1
CMD tail -f /dev/null
