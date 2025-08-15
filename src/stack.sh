#!/bin/bash

# === COLORS ===
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# === LOAD ENV VARIABLES ===
if [ -f .env ]; then
  export $(grep -v '^#' .env | xargs)
else
  echo -e "${RED}.env file not found. Please create one.${NC}"
  exit 1
fi

# === CONFIG ===

# List of docker-compose files to include
COMPOSE_FILES=(
  compose.network.yml
  compose.mysql.yml
  compose.n8n.yml
  compose.grafana.yml
  compose.mosquitto.yml
)

# === FUNCTIONS ===
create_network_if_missing() {
  if ! docker network inspect the-piot >/dev/null 2>&1; then
    echo -e "${YELLOW}Creating network:${NC} the-piot"
    docker network create the-piot
  fi
}

build_compose_args() {
  local args=""
  for file in "${COMPOSE_FILES[@]}"; do
    args="$args -f $file"
  done
  echo "$args"
}

show_summary() {
  echo -e "\n${BLUE}Container Summary:${NC}"
  docker ps --filter "network=the-piot" \
            --format "table {{.ID}}\t{{.Names}}\t{{.Status}}\t{{.Ports}}"
}

# === MAIN ===
COMPOSE_ARGS=$(build_compose_args)

case "$1" in
  up)
    echo -e "${BLUE}Bringing up all services...${NC}"
    create_network_if_missing
    docker compose $COMPOSE_ARGS up -d
    echo -e "${GREEN}All services are up and running.${NC}"
    show_summary
    ;;
  down)
    echo -e "${BLUE}Stopping all services...${NC}"
    docker compose $COMPOSE_ARGS down
    echo -e "${RED}All services have been stopped.${NC}"
    ;;
  restart)
    echo -e "${BLUE}Restarting all services...${NC}"
    docker compose $COMPOSE_ARGS down
    create_network_if_missing
    docker compose $COMPOSE_ARGS up -d
    echo -e "${GREEN}All services have been restarted successfully.${NC}"
    show_summary
    ;;
    summary)
    show_summary
    ;;
  *)
    echo -e "${YELLOW}Usage:${NC} $0 {up|down|restart}"
    exit 1
    ;;
esac
