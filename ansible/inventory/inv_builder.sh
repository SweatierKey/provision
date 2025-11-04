#!/usr/bin/env bash

set -euo pipefail

script_dir="$(dirname "$(realpath "$0")")"

# Nome dei file di output
INI_FILE="${script_dir}/inventory.ini"
YAML_FILE="${script_dir}/inventory.yml"

# Lista di host (puoi anche leggere da un file)
#HOST_LIST=$(cat "$1")
HOST_LIST="$(cat "${script_dir}/../../infra.inv")"

# -------------------
# Creazione INI
# -------------------
echo "[myservers]" > $INI_FILE
while IFS= read -r line; do
    # Separiamo user, host e porta
    user=$(echo $line | cut -d'@' -f1)
    host_port=$(echo $line | cut -d'@' -f2)
    host=$(echo $host_port | cut -d':' -f1)
    port=$(echo $host_port | cut -d':' -f2)
    echo "$host ansible_user=$user ansible_port=$port" >> $INI_FILE
done <<< "$HOST_LIST"

echo "Inventory INI generato in $INI_FILE"

# -------------------
# Creazione YAML
# -------------------
echo "all:" > $YAML_FILE
echo "  children:" >> $YAML_FILE
echo "    myservers:" >> $YAML_FILE
echo "      hosts:" >> $YAML_FILE

while IFS= read -r line; do
    user=$(echo $line | cut -d'@' -f1)
    host_port=$(echo $line | cut -d'@' -f2)
    host=$(echo $host_port | cut -d':' -f1)
    port=$(echo $host_port | cut -d':' -f2)
    # Creiamo un nome unico per l'host
    host_name="${host}_${port}"
    echo "        $host_name:" >> $YAML_FILE
    echo "          ansible_host: $host" >> $YAML_FILE
    echo "          ansible_port: $port" >> $YAML_FILE
    echo "          ansible_user: $user" >> $YAML_FILE
done <<< "$HOST_LIST"

echo "Inventory YAML generato in $YAML_FILE"
