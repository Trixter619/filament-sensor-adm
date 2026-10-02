#!/bin/sh
set -e

echo "Filament Sensor Switch v4 plugin installed"
echo "Macros: FILAMENT_SENSOR_ON, FILAMENT_SENSOR_OFF, FILAMENT_SENSOR_TOGGLE, FILAMENT_SENSOR_STATUS, FILAMENT_SENSOR_PREPARE, FILAMENT_SENSOR_PREPARE_FLEX"
echo "Before print: flexible materials disable the sensor; other non-empty material types enable it. Empty material leaves the state unchanged."
