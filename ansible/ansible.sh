#!/usr/bin/env bash

script_dir="$(dirname "$(realpath "$0")")"

# Lista host: puoi anche leggerla da file
HOSTS=$(cat "${script_dir}"/../infra.inv)

eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa

IFS=$'\n'
for h in $HOSTS; do
	# echo "ACCA: $h"
	HOST="${h%%:*}"
	PORT="${h##*:}"

	echo "Pinging $USER@$HOST:$PORT..."

	ssh \
		-o BatchMode=yes \
		-o ConnectTimeout=5 \
		-o StrictHostKeyChecking=no \
		-o UserKnownHostsFile=/dev/null \
		-p "$PORT" \
		"$HOST" "echo OK" 2>/dev/null 1>&2 \
		&& echo "SUCCESS: $USER@$HOST:$PORT" \
		|| echo "FAILED: $USER@$HOST:$PORT"

done

ssh-agent -k
