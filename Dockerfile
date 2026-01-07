FROM postgres:16.11

ARG PATRONI_VERSION=3.2.1
ENV PATRONI_VERSION=${PATRONI_VERSION}
ENV LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
ENV PATRONI_HOME=/opt/patroni
ENV PGHOME=/home/postgres
ENV PATH="/opt/patroni-venv/bin:${PATH}"

RUN export DEBIAN_FRONTEND=noninteractive && \
    echo 'APT::Install-Recommends "0";\nAPT::Install-Suggests "0";' > /etc/apt/apt.conf.d/01norecommend && \
    apt-get update -y && \
    apt-get install -y \
        curl jq locales git build-essential libpq-dev \
        python3 python3-dev python3-pip python3-wheel python3-setuptools python3-venv \
        python3-pystache python3-requests patchutils binutils \
        postgresql-common libevent-2.1-7 libevent-pthreads-2.1-7 brotli libbrotli1 python3-psycopg2 && \
    localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

RUN python3 -m venv /opt/patroni-venv && \
    /opt/patroni-venv/bin/pip install --upgrade pip && \
    /opt/patroni-venv/bin/pip install psycopg2-binary six psutil cdiff "patroni[kubernetes]==${PATRONI_VERSION}"

RUN mkdir -p ${PGHOME} && \
    sed -i "s|/var/lib/postgresql.*|${PGHOME}:/bin/bash|" /etc/passwd && \
    chmod 664 /etc/passwd && \
    mkdir -p ${PGHOME}/pgdata/pgroot && \
    chgrp -R 0 ${PGHOME} && \
    chown -R postgres ${PGHOME} && \
    chmod -R 775 ${PGHOME}

COPY scripts/ /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh /usr/bin/post_init.sh

VOLUME /home/postgres/pgdata
USER postgres
WORKDIR /home/postgres

EXPOSE 5432 8008

CMD ["/bin/bash", "/usr/bin/entrypoint.sh"]