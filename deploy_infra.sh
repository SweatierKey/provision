#!/usr/bin/env bash

containers=15
inv="infra.inv"

# Build my-rhel7-ssh image
podman build -t my-rhel7-ssh .
# Pulisco l'inv file
> "$inv"

for i in $(seq 1 $containers); do
  podman run --replace -d --name rhel7-$i -p $((2221 + i)):22 my-rhel7-ssh
  echo rhel7-$i $((2221 + i)) >> "$inv"
done

