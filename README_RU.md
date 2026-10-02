# Filament Sensor Switch v4 for ZMOD

Плагин для Flashforge Adventurer 5M / 5M Pro с ZMOD.

Управляет штатным датчиком движения филамента `e0_sensor`.

## Логика v4

Перед печатью плагин устанавливает состояние датчика по типу материала, переданному из слайсера:

- если материал гибкий/мягкий — отключает датчик движения;
- если тип материала непустой и не распознан как гибкий — включает датчик движения;
- если тип материала пустой или не передан — сохраняет текущее состояние и выводит предупреждение.

При следующей печати PLA после TPU датчик автоматически включится при вызове `FILAMENT_SENSOR_PREPARE MATERIAL=PLA`.
Плагин не определяет материал физически: он использует тип, переданный OrcaSlicer. Необычные названия гибких материалов, не содержащие перечисленные ниже признаки, считаются обычными; для них используйте `FILAMENT_SENSOR_PREPARE_FLEX`.
Ручное управление действует до следующего вызова `FILAMENT_SENSOR_PREPARE` с непустым типом материала.

## Материалы, считающиеся гибкими

По умолчанию распознаются по имени типа материала:

- TPU, включая TPU95A / TPU-95A / TPU85A и т.п.;
- TPE;
- FLEX, включая REC FLEX;
- PEBA;
- SOFT;
- RUBBER;
- REC.

Проверка регистронезависимая и работает по вхождению текста.

## Автоматическое определение из OrcaSlicer

OrcaSlicer предоставляет `filament_type[]` как встроенный параметр материала. Для AD5M с одним экструдером добавьте **перед `START_PRINT`** в Machine start G-code:

```gcode
FILAMENT_SENSOR_PREPARE MATERIAL={filament_type[0]}
START_PRINT EXTRUDER_TEMP=[nozzle_temperature_initial_layer] BED_TEMP=[bed_temperature_initial_layer_single]
SET_PRINT_STATS_INFO TOTAL_LAYER=[total_layer_count]
```

Примеры результата:

```text
TPU      -> датчик OFF
TPU95A   -> датчик OFF
TPE      -> датчик OFF
REC-FLEX -> датчик OFF
PEBA     -> датчик OFF
PLA      -> датчик ON
PETG     -> датчик ON
ABS      -> датчик ON
ASA      -> датчик ON
PC       -> датчик ON
```

## Если профиль материала имеет необычное название

Можно принудительно отключить датчик в стартовом G-code конкретного профиля:

```gcode
FILAMENT_SENSOR_PREPARE_FLEX
```

Либо вызвать:

```gcode
FILAMENT_SENSOR_PREPARE MATERIAL=TPU
```

## Ручное управление

```gcode
FILAMENT_SENSOR_ON
FILAMENT_SENSOR_OFF
FILAMENT_SENSOR_TOGGLE
FILAMENT_SENSOR_STATUS
```

## Важно

Плагин не переопределяет `START_PRINT` и `_USER_START_PRINT`, не использует `delayed_gcode` и не включает датчик сам по переходу принтера в состояние printing.

Для работы именно штатного motion sensor ZMOD должен использовать `e0_sensor`. В ZMOD глобальный выбор датчика движения задаётся отдельно:

```gcode
SAVE_ZMOD_DATA MOTION_SENSOR=1
```

При использовании датчика движения документация ZMOD рекомендует отключить аналогичную обработку датчика на родном экране, иначе штатный интерфейс тоже может поставить печать на паузу.

## Установка как внешний ZMOD-плагин

Пример `mod_data/user.moonraker.conf`:

```ini
[update_manager filament_sensor_switch]
type: git_repo
channel: dev
path: /root/printer_data/config/mod_data/plugins/filament_sensor_switch
origin: https://github.com/Trixter619/filament-sensor-adm.git
is_system_service: False
primary_branch: main
```

После добавления репозитория:

```gcode
ENABLE_PLUGIN name=filament_sensor_switch
```

Удаление:

```gcode
DISABLE_PLUGIN name=filament_sensor_switch
```
