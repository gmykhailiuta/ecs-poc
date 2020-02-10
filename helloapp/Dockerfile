FROM alpine:3.7

RUN apk add --update ca-certificates python3 python3-dev gcc postgresql-dev musl-dev curl
RUN pip3 install --no-cache-dir --upgrade --force-reinstall pip setuptools wheel

RUN mkdir -p /srv/app
ADD . /srv/app
RUN pip3 install --no-cache-dir -r /srv/app/requirements/runtime.txt

RUN adduser -s /bin/bash -D -u 1000 -h /srv/app app
RUN chown -R app.app /srv/app
USER app

COPY docker-entrypoint.sh /srv/app

ENV PYTHONUNBUFFERED=1
ENV PYTHONPATH=$PYTHONPATH:/srv/app
ENV PATH=$PATH:/srv/app/.local/bin

EXPOSE 8080
WORKDIR /srv/app

HEALTHCHECK --interval=10s --timeout=3s \
  CMD curl -f http://127.0.0.1:8000/healthcheck || exit 1

ENTRYPOINT ["/srv/app/docker-entrypoint.sh"]
CMD ["run"]
