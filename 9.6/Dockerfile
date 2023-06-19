# -*- mode: Dockerfile; tab-width: 4;indent-tabs-mode: nil;-*-
# vim: ts=4 sw=4 ft=Dockerfile et: 1
FROM mubox/base

# Create directories
RUN mkdir -p /var/log/gomicro

# Install arping
RUN apt-get update -qq && \
    apt-get install -y iputils-arping cron && \
    apt-get clean all && \
    rm -rf /var/lib/apt/lists/*

USER gomicro

# Install binaries
RUN rm -rf /data/var/db/pkgin && \
    /data/bin/pkgin -y up && \
    /data/bin/pkgin -y in \
        postgresql96-client \
        postgresql96-contrib \
        postgresql96-plperl \
        postgresql96-plpython \
        postgresql96-pltcl \
        postgresql96-postgis \
        postgresql96-server && \
    rm -rf /data/var/db/pkgin/cache

USER root

RUN rm -rf /var/gomicro/db/pkgin && \
    /opt/gomicro/bin/pkgin -y up && \
    /opt/gomicro/bin/pkgin -y in \
        rsync && \
    rm -rf /var/gomicro/db/pkgin/cache

RUN /opt/gomicro/bin/gem install remote_syslog_logger

# Install hooks
RUN mkdir -p /opt/microbox/hooks && \
    mkdir -p /var/microbox && \
    curl \
      -f \
      -k \
      https://s3.amazonaws.com/tools.microbox.cloud/hooks/postgresql-stable.tgz \
        | tar -xz -C /opt/microbox/hooks && \
    curl \
      -f \
      -k \
      -o /var/microbox/hooks.md5 \
      https://s3.amazonaws.com/tools.microbox.cloud/hooks/postgresql-stable.md5

# Cleanup disk
RUN rm -rf \
        /var/lib/apt/lists/* \
        /tmp/* \
        /var/tmp/*

WORKDIR /data

# Run runit automatically
CMD [ "/opt/gomicro/bin/microinit" ]
