FROM debian:bookworm-slim

EXPOSE 3306

RUN apt-get update && apt-get install -y mariadb-server

RUN apt-get update && apt-get install -y vim

RUN mkdir -p /var/lib/mysql

COPY tools/script.sh /

RUN chmod +x /script.sh

COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

ENTRYPOINT ["bash","/script.sh"]