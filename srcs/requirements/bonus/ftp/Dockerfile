FROM debian:bookworm-slim

EXPOSE 21
EXPOSE 40000-40010

RUN apt-get update && apt-get install -y \
	vsftpd \
	&& rm -rf /var/lib/apt/lists/*

RUN useradd -m ftpuser

RUN echo "ftpuser:ftppw" | chpasswd

RUN mkdir -p /home/ftpuser/ftp \
	&& chown ftpuser:ftpuser /home/ftpuser/ftp \
	&& chmod 755 /home/ftpuser/ftp

RUN mkdir -p /var/run/vsftpd/empty

COPY conf/vsftpd.conf /etc/vsftpd.conf

CMD ["/usr/sbin/vsftpd", "/etc/vsftpd.conf"]