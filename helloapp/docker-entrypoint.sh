#!/bin/sh
set -e

if [ "$1" = "run" ]; then
    shift
    export FLASK_APP=main.py
    export FLASK_ENV=production
    flask db upgrade
    gunicorn --workers 1 \
      --bind 0.0.0.0:8000 \
      --access-logfile=- \
      --error-logfile=- \
      main:app
fi

if [ "$1" = "test" ]; then
    shift
    pip3 install -r requirements/test.txt
    pytest
fi

exec "$@"
