FROM docker.io/library/debian:bookworm-slim

LABEL org.opencontainers.image.title="ais-sim-relay" \
      org.opencontainers.image.description="Runtime Python/Tk pour AIS Sim Relay"

RUN apt-get update \
 && apt-get install -y --no-install-recommends python3 python3-tk fonts-dejavu-core \
 && rm -rf /var/lib/apt/lists/*

COPY entrypoint.sh /usr/local/bin/ais-entrypoint
RUN chmod 755 /usr/local/bin/ais-entrypoint

WORKDIR /opt/ais_sim
ENV AIS_SIM_DIR=/opt/ais_sim \
    AIS_SIM_CONF=/opt/ais_sim/conf.txt \
    PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    LANG=C.UTF-8

ENTRYPOINT ["/usr/local/bin/ais-entrypoint"]
CMD []
