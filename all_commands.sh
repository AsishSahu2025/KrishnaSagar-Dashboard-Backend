#!/bin/bash

mkdir -p /app1/logs

echo "Starting Remote sensing script..."
python manage.py testing >> /app1/logs/Remote_sensing.log 2>&1 &

echo "Starting Django server (gunicorn)..."
exec gunicorn krishnasagar_dashboard.wsgi:application \
    --bind 0.0.0.0:8000 \
    --workers 3 \
    --timeout 120 \
    --access-logfile - \
    --error-logfile -
