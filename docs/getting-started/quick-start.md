# Quick start

This page takes you from a fresh download to an event that is ready for referees. Allow about ten minutes.

## Before you begin

You need:

- a computer to run the server, connected to the venue network,
- the schedule file for your event, exported from the FLL scheduler as a CSV file (see [Schedules](../guides/schedule.md)), and
- a device with a web browser.

## 1. Start the server

1. Download the build for your platform from the [releases page](https://github.com/CJBuchel/TMS/releases) and unpack it somewhere you can find again.
2. Run `tms_server` from inside the unpacked folder.

The server prints the address it is hosting on, for example `http://192.168.1.20:8080`. Keep the window open for the whole event.

!!! tip
    Run the server from its own folder. It keeps its database, backups and logs next to the program. See [Installing the server](../admin/installation.md) for Docker and the other options.

## 2. Open the client

On any device on the same network, open a browser and go to the address the server printed. You are taken to `/ui`, the TMS client.

The top bar shows a connection status while the client finds the server. When it disappears, you are connected. If it does not, see [Connecting a device](connecting.md).

## 3. Log in as the administrator

Select the login button in the top right corner and sign in with:

| Username | Password |
| --- | --- |
| `admin` | `admin` |

!!! warning "Change the admin password"
    Anyone on the network can use the default password. Change it in the next step.

## 4. Set up the event

From the home screen open **Setup**. Each row has its own send button; nothing is saved until you press it.

1. **Set admin password**: choose a new password and send it.
2. **Set event name**: optional.
3. **Upload schedule**: choose your CSV file, then send it. This creates the teams, tables, matches, judging pods and judging sessions.
4. **Select Blueprint**: choose the season your event is running, for example `2026-Founders`, and send it. See [Seasons and games](../guides/seasons.md).

The remaining options (timer lengths and backup settings) have sensible defaults. They are described in [Event setup](../admin/event-setup.md).

## 5. Create accounts for your volunteers

1. Open the side menu with the arrow on the left edge of the screen and choose **Users**.
2. Select **Add default users** to create one account for each common role.

| Username | Password | Role |
| --- | --- | --- |
| `head_referee` | `head_referee` | Head referee |
| `referee` | `referee` | Referee |
| `judge_advisor` | `judge_advisor` | Judge advisor |
| `judge` | `judge` | Judge |

Change the passwords or add your own accounts as needed. See [Users and passwords](../admin/users.md).

## 6. Check the event

Open **Dashboard** from the home screen. You should see:

- the number of matches, judging sessions and expected scores, and
- an **Integrity Messages** panel. If it lists anything, the schedule has a problem worth fixing before teams arrive. See [Integrity checks](../guides/integrity.md).

## You are ready

- [x] Server running
- [x] Admin password changed
- [x] Schedule imported
- [x] Season selected
- [x] Volunteer accounts created

Hand each volunteer the page for their role from [Roles at a glance](../roles/index.md), and read the [Event day walkthrough](event-day.md) for how the day fits together.
