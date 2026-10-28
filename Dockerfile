FROM python:3.10-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /app1

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential gdal-bin libgdal-dev libgeos-dev \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt /app1/
RUN pip install --no-cache-dir -r requirements.txt \
    && pip install --no-cache-dir gunicorn whitenoise

COPY . /app1/

ENV GOOGLE_APPLICATION_CREDENTIALS=/app1/earth-engine-486705-90d2d5209baa.json

RUN SECRET_KEY=build DB_NAME=x DB_USER=x DB_PASSWORD=x DB_HOST=x \
    python manage.py collectstatic --noinput

RUN sed -i 's/\r$//' /app1/all_commands.sh && chmod +x /app1/all_commands.sh

EXPOSE 8000

CMD ["/app1/all_commands.sh"]
