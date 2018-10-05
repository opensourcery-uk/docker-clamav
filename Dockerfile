FROM opensourcery/debian:buster-slim
LABEL maintainer "open.source@opensourcery.uk"

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get dist-upgrade -y \
 && apt-get install -y clamav-daemon \
 && apt-get install -y supervisor \
 && apt-get clean \
 && rm -r /var/lib/apt/lists/*

RUN sed -i 's/Foreground false/Foreground true/' /etc/clamav/freshclam.conf \
 && sed -i 's/Foreground false/Foreground true/' /etc/clamav/clamd.conf \
 && sed -i 's/LocalSocket.*$//g' /etc/clamav/clamd.conf \
 && sed -i 's/FixStaleSocket.*$/TCPSocket 3310/' /etc/clamav/clamd.conf

ADD supervisord-clamd /etc/supervisor/conf.d/clamd.conf
ADD supervisord-freshclam /etc/supervisor/conf.d/freshclam.conf

ADD entrypoint.sh /entrypoint.sh
RUN chmod 755 /entrypoint.sh

#EXPOSE 11333 11334

ENTRYPOINT ["/entrypoint.sh"]
