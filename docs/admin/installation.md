# Installing the server

The TMS server is one program plus a folder of web files. It needs no database server, no installer and no internet connection once it is on the machine.

## What you need

- A laptop or small computer that stays on for the whole event. Any modern machine is more than enough.
- A place on the venue network that the other devices can reach. See [Network planning](networking.md).

## Choose how to run it

=== "Windows"

    1. Download the Windows build from the [releases page](https://github.com/CJBuchel/TMS/releases).
    2. Unzip it to a folder you can find again, for example `C:\TMS`.
    3. Double-click `tms_server.exe`, or run it from a terminal opened in that folder.

    The first time, Windows Firewall asks whether to allow network access. **Allow it** for the network you are on, otherwise other devices cannot connect.

=== "Linux"

    1. Download the Linux build from the [releases page](https://github.com/CJBuchel/TMS/releases).
    2. Unpack the archive and start the server from inside the unpacked folder:

    ```bash
    cd tms
    ./tms_server
    ```

=== "macOS"

    1. Download the macOS build from the [releases page](https://github.com/CJBuchel/TMS/releases).
    2. Unpack it and start the server from a terminal inside the folder:

    ```bash
    cd tms
    ./tms_server
    ```

    If macOS blocks the program because it was downloaded from the internet, allow it in **System Settings → Privacy & Security**.

=== "Docker"

    ```bash
    docker pull cjbuchel/tms
    docker run -d -p 8080:8080 --name tms cjbuchel/tms
    ```

    The event data lives inside the container. To keep it across container upgrades, mount a volume for the working folder:

    ```bash
    docker run -d -p 8080:8080 \
      -v tms-data:/tms/tms.kvdb \
      -v tms-backups:/tms/backups \
      --name tms cjbuchel/tms
    ```

!!! important "Always start the server from its own folder"
    The server looks for its web files, log settings and database relative to the folder it is started in. Starting it from somewhere else will fail or create a second, empty event.

## Check it is running

When the server starts it prints a line like:

```text
Hosting on http://192.168.1.20:8080
```

Open that address in a browser on another device. You should see the TMS home screen. Then follow the [quick start](../getting-started/quick-start.md).

## What is in the server folder

| Item | What it is |
| --- | --- |
| `tms_server` | The server program |
| `tms_client/` | The web client that the server hosts at `/ui` |
| `log_config/` | Settings for what is written to the logs |
| `tms.kvdb/` | The event database. Created on first run. **Do not edit or delete it while the server is running.** |
| `backups/` | Automatic and manual backups, as `.zip` files |
| `logs/` | Log files. See [Logs and files](../support/logs.md). |
| `cert.pem`, `key.rsa` | The certificate and key used when the server runs with `--tls` |

## Starting a new event

Each server folder holds one event. For a new event, either:

- unpack a fresh copy of TMS into a new folder, or
- log in as admin and use **Purge** in Setup to empty the current one.

Keeping one folder per event means you always have the complete record of past events.

## Upgrading

1. Stop the server.
2. Take a copy of the whole server folder.
3. Unpack the new version into a new folder.
4. Copy your `backups` folder across, start the new server, and restore the most recent backup from the **Backups** page.

Restoring through the server, instead of copying the `tms.kvdb` folder by hand, lets the new version check the data as it loads.

## Stopping the server

Close the terminal window or press ++ctrl+c++ in it. Everything is saved as it happens, so there is nothing to save first.
