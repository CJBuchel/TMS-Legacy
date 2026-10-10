# Logs and files

When something goes wrong, the server's logs and the layout of its folder tell you most of what you need.

## The server folder

```text
tms/
├── tms_server          the server program (tms_server.exe on Windows)
├── tms_client/         the web client served at /ui
├── log_config/         logging settings
├── tms.kvdb/           the event database
├── backups/            backup .zip files
├── logs/
│   ├── tms.log         server activity
│   └── db.log          database and live-data activity
├── cert.pem            TLS certificate, when used
└── key.rsa             TLS private key, when used
```

## Log files

| File | Contains |
| --- | --- |
| `logs/tms.log` | Logins, scoresheet submissions, calculated scores, match and timer events, integrity messages, errors |
| `logs/db.log` | Device connections and disconnections, subscriptions to live data, data changes |

Each file grows to 10 MB, then is renamed to `tms.1.log` (or `db.1.log`) and a new file is started. Up to ten old files are kept.

The same messages are printed in the server's terminal window as they happen.

### Reading a log line

```text
[2026-10-10 18:13:49 WARN tms_server::database::extensions::game_score_sheet_extensions LINE: 68] Calculated score for: Table 1, 530
```

| Part | Meaning |
| --- | --- |
| `2026-10-10 18:13:49` | When it happened, in the server computer's local time |
| `WARN` | The level: `INFO`, `WARN` or `ERROR` |
| `tms_server::...` | Which part of the server wrote it |
| `LINE: 68` | The line in the source code |
| The rest | The message |

!!! note "Not every WARN or ERROR is a problem"
    Some routine events are logged at a higher level so that they stand out. A scoresheet rejected by validation, or an integrity message such as `[E003]`, appears as an `ERROR` line. That is the system working as intended.

### Useful things to search for

| Search for | To find |
| --- | --- |
| `Calculated score for` | Every scoresheet the server accepted, with table and score |
| `Failed to submit GameScoreSheet` | Scoresheets the server rejected, and why |
| `Login attempt failed` | Wrong passwords |
| `connected` / `disconnected` | Devices joining and leaving |
| `Hosting on` | The address the server started on |
| `Tunnel active` | Remote access coming up |

## Changing how much is logged

The files in `log_config` control what is written. Release builds use `release_log4rs.yaml`.

```yaml title="log_config/release_log4rs.yaml (extract)"
root:
  level: info # (1)!
  appenders:
    - tms_server_stdout
    - tms_server
```

1. Change to `debug` for much more detail, or `warn` for less. The server re-reads this file every 30 seconds, so you do not need to restart it.

Use `debug` only while investigating a problem. It records every message between the server and each device.

## The database

`tms.kvdb` is a folder, not a single file. Treat it as a unit:

- **Do not** open, edit, move or delete anything inside it while the server is running.
- **Do not** copy it as a way of taking a backup. Use the [Backups page](../admin/backups.md), which produces a consistent snapshot.

## On the client

The connection page (cog icon) shows the client's **version** and **build** number. Include both when reporting a problem.

In a web browser, the developer console (usually ++f12++) shows errors from the client. A screenshot of anything red there is useful in a bug report.

## What to send with a bug report

- [ ] TMS version and build
- [ ] The platform the server runs on (Windows, Linux, macOS or Docker)
- [ ] What you were doing and what you expected
- [ ] `logs/tms.log` and `logs/db.log` covering the time of the problem
- [ ] A backup of the event, if the problem can be reproduced from it and it contains nothing confidential

Report issues at [github.com/CJBuchel/TMS/issues](https://github.com/CJBuchel/TMS/issues).

!!! warning "Check before you share"
    A backup contains team names, usernames and passwords for that event. Share it only with someone you trust, and never post it publicly.
