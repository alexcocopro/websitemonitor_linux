#!/bin/bash

while IFS= read -r ip; do
  if ping -c 1 -W 1 "$ip" &> /dev/null; then
    echo "$ip está activo"
    break  # Sale del bucle si una IP responde
  else
    echo "$ip no responde"
  fi
done < ips.txt

echo "Script finalizado."


# Hazlo ejecutable con: chmod +x monitor_websites.sh

# Elaborado por Alex Cabello Leiva - AlexCocoPro

echo "Script elaborado por Alex Cabello Leiva - AlexCocoPro"