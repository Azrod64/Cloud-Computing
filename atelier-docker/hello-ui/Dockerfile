#FROM python:3.6.10-alpine3.11
FROM python:3.9.19-alpine3.19

# Sane defaults for pip
ENV PIP_NO_CACHE_DIR off
ENV PIP_DISABLE_PIP_VERSION_CHECK on

RUN apk add --update build-base linux-headers pcre pcre-dev

COPY requirements.txt /app/
RUN pip install --upgrade pip && \
    pip install -r /app/requirements.txt

RUN addgroup -g 1000 -S uwsgi && \
    adduser -u 1000 -S uwsgi -G uwsgi

COPY ./app /app

WORKDIR /app/

# Logging
RUN mkdir -p /var/log/uwsgi/app/

# Cleanups
RUN apk del build-base linux-headers pcre-dev

EXPOSE 5000

CMD ["/usr/local/bin/uwsgi", "--ini", "uwsgi.ini"]