FROM debian:bookworm-slim

EXPOSE 3306

RUN apt-get update && apt-get install -y \
    mariadb-server \
    vim

RUN mkdir -p /var/lib/mysql

RUN chown -R mysql:mysql /var/lib/mysql && \
    chmod -R 755 /var/lib/mysql

COPY tools/script.sh /script.sh

RUN chmod +x /script.sh

COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

ENTRYPOINT ["/script.sh"]
