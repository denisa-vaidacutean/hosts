#!/bin/bash

# Funcție care verifică validitatea unei asocieri IP-Host
check_ip_host() {
    local host="$1"
    local ip="$2"
    local dns_server="$3"

    # Verifică asocierea utilizând serverul DNS specificat
    resolved_ip=$(dig +short "$host" @"$dns_server")
    if [[ "$resolved_ip" == "$ip" ]]; then
        echo "Asociere validă: $host -> $ip"
    else
        echo "Asociere invalidă: $host -> $ip (DNS spune: $resolved_ip)"
    fi
}

# Parcurge liniile din /etc/hosts
while read -r line; do
    # Ignoră liniile goale sau comentariile
    [[ "$line" =~ ^#.*$ || -z "$line" ]] && continue

    # Extrage adresa IP și numele de host
    ip=$(echo "$line" | awk '{print $1}')
    host=$(echo "$line" | awk '{print $2}')

    # Verifică dacă linia conține un format valid
    if [[ "$ip" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        # Apelează funcția cu un server DNS implicit (ex: 8.8.8.8)
        check_ip_host "$host" "$ip" "8.8.8.8"
    else
        echo "Linie invalidă: $line"
    fi
done < /etc/hosts
