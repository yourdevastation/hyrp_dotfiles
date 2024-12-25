#!/bin/bash

# Проверяем статус Bluetooth
STATUS=$(bluetoothctl show | grep "Powered" | awk '{print $2}')

if [ "$STATUS" == "yes" ]; then
    # Если включен, выключаем
	bluetoothctl power off
	sleep 0.2
    notify-send "Bluetooth" "Отключен"
else
    # Если выключен, включаем
	bluetoothctl power on
	sleep 0.2
    notify-send "Bluetooth" "Включен"
fi

