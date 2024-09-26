FROM debian:bookworm-slim

EXPOSE 21
EXPOSE 40000-40010

RUN apt-get update && apt-get install -y \
    vsftpd \
    && rm -rf /var/lib/apt/lists/*

RUN useradd -m ftpuser

RUN echo "ftpuser:ftppw" | chpasswd

RUN mkdir -p /home/ftpuser/ftp \
    && chown -R ftpuser:ftpuser /home/ftpuser/ftp \
    && chmod -R 755 /home/ftpuser/ftp

RUN mkdir -p /var/run/vsftpd/empty

COPY conf/vsftpd.conf /etc/vsftpd.conf
COPY /tools/ftp_entrypoint.sh /ftp_entrypoint.sh

RUN chmod +x /ftp_entrypoint.sh


CMD ["/ftp_entrypoint.sh"]