FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y \
	php-cli \
	php-json \
	php-mysql \
	curl \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

WORKDIR /var/www/html

RUN curl -L -o adminer.php https://github.com/vrana/adminer/releases/download/v4.8.1/adminer-4.8.1.php

EXPOSE 8080

CMD ["php", "-S", "0.0.0.0:8080", "adminer.php"]
