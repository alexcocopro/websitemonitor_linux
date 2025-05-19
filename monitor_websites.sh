#!/bin/bash

websites=(
  "https://alexcocopro.com"
  "https://rcr4wd.com"
  "https://turismocaracas.com"
  "https://zavooclubnft.com"
)

log_file="caidas_websites.txt"
website_status=() # Array asociativo para almacenar el estado de cada sitio

# Inicializar el estado de los sitios como "arriba" al inicio
for website in "${websites[@]}"; do
  website_status["$website"]="up"
done

while true; do
  for website in "${websites[@]}"; do
    status_code=$(curl -I -s -o /dev/null -w "%{http_code}" "$website")
    current_status=""
    if [ "$status_code" -ge 400 ]; then
      current_status="down"
    else
      current_status="up"
    fi

    previous_status="${website_status["$website"]}"

    if [ "$current_status" != "$previous_status" ]; then
      timestamp=$(date +"%Y-%m-%d %H:%M:%S")
      if [ "$current_status" == "down" ]; then
        echo "$timestamp - ¡CAÍDA! El sitio $website devolvió el código de estado: $status_code" >> "$log_file"
        echo "[$status_code] ¡CAÍDA! $website - Se registró la caída en $log_file"
      else # El sitio se levantó
        echo "$timestamp - ¡RECUPERACIÓN! El sitio $website ahora está funcionando (código: $status_code)" >> "$log_file"
        echo "[$status_code] ¡RECUPERACIÓN! $website - Se registró la recuperación en $log_file"
      fi
      website_status["$website"]="$current_status" # Actualizar el estado
    elif [ "$current_status" == "down" ]; then
      echo "[$status_code] $website sigue caído."
    else
      echo "[$status_code] $website sigue funcionando."
    fi
  done
  sleep 1
done

# hacerlo ejecutable con: chmod +x monitor_websites.sh