FROM postgres:16

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      postgresql-16-tds-fdw \
      freetds-dev \
 && rm -rf /var/lib/apt/lists/*
