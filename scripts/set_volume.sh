#!/bin/bash

# Получаем текущую громкость
volume=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print $2}' | sed 's/%//')

# Проверяем, не превышает ли громкость 95%
if (( $(echo "$volume < 0.95" | bc -l) )); then
  wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+
else
  wpctl set-volume @DEFAULT_AUDIO_SINK@ 100%
fi

