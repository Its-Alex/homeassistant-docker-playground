# Homeassistant docker playground

This repository is made to help people try and test things with docker HA
setup.

The aim is automate an installation with some features and reproduce it to tweak
them.

- [Homeassistant docker playground](#homeassistant-docker-playground)
  - [How to start](#how-to-start)
  - [How to stop](#how-to-stop)
  - [MQTT](#mqtt)
    - [Generating MQTT passwords](#generating-mqtt-passwords)
  - [Sources](#sources)
    - [Automation](#automation)

## How to start

You can launch a configuration with [HA](https://fr.wikipedia.org/wiki/Home_Assistant),
[Postgres](https://www.postgresql.org/) using [up.sh](./scripts/up.sh):

```sh
$ ./scripts/up.sh
[+] Running 4/4
 ✔ Network home-assistant-config_default                     Created
 ✔ Container home-assistant-config-music-assistant-server-1  Healthy
 ✔ Container home-assistant-config-postgres-1                Healthy
 ✔ Container home-assistant-config-homeassistant-1           Healthy
{"auth_code":"907dd8fda2c94c3ea3352343e960de3d"}%
```

## How to stop

To stop the service you can simply run:

```sh
$ ./scripts/down.sh
```

If you want to erase datas too, you can use:

```sh
$ ./scripts/down.sh --volumes
```

## MQTT

This repositoy choose to use [mosquitto](https://mosquitto.org/) as MQTT broker.
Two users are already created in `config/mosquitto/passwd`:
- Homeassistant:
  - Username: **homeassistant**
  - Password: **password**
- Zigbee2MQTT:
  - Username: **zigbee2mqtt**
  - Password: **password**

By default Homeassistant MQTT integration is not enabled (due to difficulty to
set it enabled in [infrastructure as code](https://en.wikipedia.org/wiki/Infrastructure_as_code)).
You must enable it manually following [Homeassistant MQTT documentation](https://www.home-assistant.io/integrations/mqtt).

### Generating MQTT passwords

Passwords are stored in `config/mosquitto/passwd` and must be hashed with `mosquitto_passwd`. Using the same image as in the stack:

**Create a new password file** (overwrites existing; use only for the first user):

```sh
docker run --rm -v "$(pwd)/config/mosquitto:/mosquitto/config" eclipse-mosquitto \
  mosquitto_passwd -b -c /mosquitto/config/passwd USERNAME PASSWORD
```

**Add a user** to an existing file (do not use `-c`):

```sh
docker run --rm -v "$(pwd)/config/mosquitto:/mosquitto/config" eclipse-mosquitto \
  mosquitto_passwd -b /mosquitto/config/passwd USERNAME PASSWORD
```

Replace `USERNAME` and `PASSWORD`. After changing `passwd`, restart Mosquitto: `docker compose restart mosquitto`. Update `docker-compose.yml` (e.g. zigbee2mqtt env) and/or `config/homeassistant/secrets.yaml` if you change credentials.

## Zigbee2mqtt

All [Zigbee2MQTT](https://www.zigbee2mqtt.io/) configuration is done via environment variables in
[docker-compose.yml](./docker-compose.yml). This repository is set up to use
[Sonoff Zigbee Dongle 3.0](https://sonoff.tech/fr-fr/products/sonoff-zigbee-3-0-usb-dongle-plus-zbdongle-e)
using [Ember ZNet](https://www.silabs.com/software-and-tools/zigbee-emberznet)
with a baudrate of 115200.

I flashed my dongle using the website of [silabs-firmware-builder](https://github.com/darkxst/silabs-firmware-builder).

If your setup is not exactly the same, you should probably update the [Zigbee2MQTT](https://www.zigbee2mqtt.io/)
configuration.

## Sources

### Automation

Some thread that helped me for automating HA setup:

- https://community.home-assistant.io/t/how-to-add-new-user-with-command-line-or-even-to-change-user-password-with-command-line/158730/10
- https://community.home-assistant.io/t/how-to-automate-initial-onboarding-set-up/377143
