# Homeassistant docker playground

This repository is made to help people try and test things with docker HA
setup.

The aim is automate an installation with some features and reproduce it to tweak
them.

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
$ docker compose down -v
```

If you want to erase datas too, you can use:

```sh
$ sudo rm -rf volumes/
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

## Sources

### Automation

Some thread that helped me for automating HA setup:

- https://community.home-assistant.io/t/how-to-add-new-user-with-command-line-or-even-to-change-user-password-with-command-line/158730/10
- https://community.home-assistant.io/t/how-to-automate-initial-onboarding-set-up/377143
