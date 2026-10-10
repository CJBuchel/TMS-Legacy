# THIS PROJECT IS UNDER MAINTENANCE
# DO NOT CONTRIBUTE TO THIS LEGACY CODE
- Checkout the [master](https://github.com/CJBuchel/TMS/tree/master) and [rebuild](https://github.com/CJBuchel/TMS/tree/rebuild) branches for contributing

<p align="center">
  <img src="https://raw.githubusercontent.com/CJBuchel/TMS/legacy/images/TMS_LOGO.png"/>
</p>

## Tournament Management System

- FLL Event Management System: A comprehensive and locally hosted solution for scoring, storing and ignoring. Replacing paper and hard set schedules for live modifiable event data. Including digital scoring, timers, live schedules, scoreboards, match/score tracking, snapshots rollbacks and more.

| Project Status                                                                                                                                                                                                                  | Pulls                                                             | Version                                                                                | Size                                                                                         |
| ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------- | -------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------- |
| [![Build Status](https://dev.azure.com/ConnorBuchel0890/ConnorBuchel/_apis/build/status%2FCJBuchel.TMS?branchName=legacy)](https://dev.azure.com/ConnorBuchel0890/ConnorBuchel/_build/latest?definitionId=24&branchName=legacy) | ![Docker Pulls](https://img.shields.io/docker/pulls/cjbuchel/tms) | ![Docker Image Version (latest by date)](https://img.shields.io/docker/v/cjbuchel/tms) | ![Docker Image Size (latest by date)](https://img.shields.io/docker/image-size/cjbuchel/tms) |

<p align="center">
  <img src="https://raw.githubusercontent.com/CJBuchel/TMS/legacy/images/prom1.png" width="400" style="margin-right: 10px"/>
  <img src="https://raw.githubusercontent.com/CJBuchel/TMS/legacy/images/prom3.png" width="400"/>
</p>

<p align="center">
  <img src="https://raw.githubusercontent.com/CJBuchel/TMS/legacy/images/prom2.png" width="400" height="550" style="margin-right: 10px"/>
  <img src="https://raw.githubusercontent.com/CJBuchel/TMS/legacy/images/prom4.png" width="400" height="550"/>
</p>

## Documentation

Full documentation is at **[cjbuchel.github.io/TMS](https://cjbuchel.github.io/TMS/)**.

| I want to... | Go to |
| --- | --- |
| Understand what TMS does | [How TMS works](https://cjbuchel.github.io/TMS/getting-started/overview/) |
| Set up an event | [Quick start](https://cjbuchel.github.io/TMS/getting-started/quick-start/) |
| Find the guide for my role (referee, head referee, judge advisor, ...) | [Roles at a glance](https://cjbuchel.github.io/TMS/roles/) |
| Install and configure the server | [Installing the server](https://cjbuchel.github.io/TMS/admin/installation/) |
| Fix a problem | [Troubleshooting](https://cjbuchel.github.io/TMS/support/troubleshooting/) |
| Build from source | [Building from source](https://cjbuchel.github.io/TMS/dev/building/) |

The documentation source is in [`docs/`](docs/).

## Install in brief

1. Download the build for your platform from the [releases](https://github.com/CJBuchel/TMS/releases) page and unpack it.
2. Run `tms_server` from inside the unpacked folder.
3. Open the address it prints (for example `http://192.168.1.20:8080`) in a browser on the same network.
4. Log in as `admin` with the password `admin`, then change that password in **Setup**.

Or with Docker:

```bash
docker run -d -p 8080:8080 --name tms cjbuchel/tms
```

The iOS client is on the [App Store](https://apps.apple.com/au/app/tms_client/id6447258831).

## Supported seasons

`2023` MASTERPIECE, `2024` SUBMERGED, `2025` UNEARTHED, `2026-Founders` and `2026-Future` BIOGLOW, plus an agnostic score-entry mode for anything else.

### Privacy Policy

- [Client Policy](https://github.com/CJBuchel/TMS/blob/legacy/tms_client/privacy_policy/067e7bb7-4ac3-4226-ad84-52c27dad78d0_en.md)
