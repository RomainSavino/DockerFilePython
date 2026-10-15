#!/bin/sh
# Point d'entrée de l'image AIS Sim Relay
set -e
DIR="${AIS_SIM_DIR:-/opt/ais_sim}"

case "${1:-}" in
  shell)
    exec /bin/bash
    ;;
  test)
    shift
    if [ ! -f "$DIR/test_ais.py" ]; then
        echo "test_ais.py absent de $DIR : montez le dossier du code (-v /opt/ais_sim:$DIR)" >&2
        exit 3
    fi
    exec python3 "$DIR/test_ais.py" "$@"
    ;;
  *)
    if [ ! -f "$DIR/ais_sim_relay.py" ]; then
        echo "ais_sim_relay.py absent de $DIR : montez le dossier du code (-v /opt/ais_sim:$DIR)" >&2
        exit 3
    fi
    exec python3 "$DIR/ais_sim_relay.py" "$@"
    ;;
esac
