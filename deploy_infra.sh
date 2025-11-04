#!/usr/bin/env bash

containers=5
inv="infra.inv"
containers_list="containers_list"

# Build my-rhel7-ssh image
podman build -t my-rhel7-ssh .
# Pulisco l'inv file
> "$inv"

for i in $(seq 1 $containers); do
  podman run --replace -d --name rhel7-$i -p $((2221 + i)):22 my-rhel7-ssh
  echo "root@localhost:$((2221 + i))" >> "$inv"
  echo "rhel7-$i" >> "$containers_list"
done
