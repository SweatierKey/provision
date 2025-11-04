#!/usr/bin/env bash

script_dir="$(dirname "$(realpath "$0")")"

# Lista host: puoi anche leggerla da file
HOSTS=$(cat "${script_dir}"/../infra.inv)

eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa

#USER="root"

for h in "${HOSTS[@]}"; do
	echo "ACCA: $h"
  HOST="${h%%:*}"
  PORT="${h##*:}"
  
  echo "Pinging $HOST:$PORT..."
  
  ssh -o BatchMode=yes -o ConnectTimeout=5 -p "$PORT" "$HOST" "echo OK" \
    && echo "SUCCESS: $HOST:$PORT" \
    || echo "FAILED: $HOST:$PORT"
done

ssh-agent -k
