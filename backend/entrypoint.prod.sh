#!/bin/sh

if [ "$DATABASE" = "postgres" ]
then
    echo "Waiting for postgres..."

    # This requires 'netcat-openbsd' which we added to the Dockerfile
    while ! nc -z $SQL_HOST $SQL_PORT; do
      sleep 0.1
    done

    echo "PostgreSQL started"
fi

# Use the 'app' directory we defined as WORKDIR
python manage.py migrate --noinput
python manage.py collectstatic --no-input

exec "$@"