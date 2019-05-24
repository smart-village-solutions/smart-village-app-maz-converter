#!/bin/sh

set -e

DB=${DB_HOST:-db:5432}

dockerize -wait tcp://$DB -timeout 30s

npm set audit false
rake db:migrate

exec "$@"
