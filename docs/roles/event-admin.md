# I am an event administrator

You install and run the TMS server, prepare the event, create accounts and keep things healthy during the day. The admin account can open every screen and do everything any other role can.

!!! abstract "Your screens"
    **Setup**, **Dashboard**, **Users** and **Backups**, plus every screen used by the other roles.

## Before the event

Follow the [quick start](../getting-started/quick-start.md). In short:

1. [Install and start the server](../admin/installation.md).
2. Log in as `admin` and change the admin password.
3. [Import the schedule](../guides/schedule.md).
4. [Choose the season](../guides/seasons.md).
5. [Create accounts](../admin/users.md) for your volunteers.
6. Check the Dashboard for integrity messages.

It is worth doing all of this the day before, on the network you will use at the venue. See [Network planning](../admin/networking.md).

## Setup

**Setup** is where the event is configured. Each row has its own send button, and every setting can be changed while the event is running.

| Section | Setting | Notes |
| --- | --- | --- |
| System Setup | Event name | Shown to identify the event |
| System Setup | Admin password | Change this from the default |
| System Setup | Backup interval | Minutes between automatic backups, 10 by default |
| System Setup | Backups to retain | How many automatic backups are kept, 5 by default |
| Schedule Setup | Upload schedule | The CSV file from the scheduler |
| Season Setup | Select Blueprint | The season scoresheet, or **Agnostic** for score-only entry |
| Game Scoring Setup | Timer length | Match length in seconds, 150 by default |
| Game Scoring Setup | Endgame length | Seconds before the end at which the end-game sound plays, 30 by default |
| Purge | PURGE | Deletes all event data, after a confirmation |

Full details are in [Event setup](../admin/event-setup.md).

!!! danger "Purge"
    **Purge** empties the whole database, including user accounts and settings, and returns the server to a fresh install. It is intended for clearing a test event before the real one. Create a backup first.

## Dashboard

The **Dashboard** is your live overview of the event.

- **Progress rings** show completed matches, completed judging sessions and scoresheets received, each against the total expected.
- **Judging** and **Games** rows show how far the event is running ahead of or behind the schedule.
- **Current Match** shows the loaded match and the timer.
- **Integrity Messages** lists problems the server has found in the event data.
- **Scores** lists scoresheets as they arrive, by match, round, team and table.

### Reading integrity messages

Messages are either errors, which are mistakes that affect results, or warnings, which are worth a look. Each has a code such as `E003` or `W005`. The most common ones on the day are:

| Code | Meaning | Usual fix |
| --- | --- | --- |
| `E003` | A team has conflicting scores | Two scoresheets exist for the same team and round. The judge advisor deletes or corrects one. |
| `W005` | Match is complete but score not submitted | A referee has not submitted yet. Follow up at the table. |
| `W006` | Match is not complete but score submitted | A score was submitted for a match that never ran on the timer. Mark the match complete or check the round. |

The full list is in [Integrity checks](../guides/integrity.md).

## Users

Open **Users** from the side menu to add accounts, change passwords and set roles. **Add default users** creates one shared account per common role. See [Users and passwords](../admin/users.md).

## Backups

The server backs itself up automatically. From **Backups** you can also create a backup on demand, download one, or restore one.

!!! warning
    Restoring a backup replaces the current state of the event with the backup. Anything entered since that backup was taken is lost.

See [Backups and restore](../admin/backups.md).

## During the event

- [ ] Keep the server computer awake and plugged in.
- [ ] Glance at the Dashboard between rounds.
- [ ] Take a manual backup before any large change, such as re-importing a schedule.
- [ ] Know where the [troubleshooting page](../support/troubleshooting.md) is.

## After the event

1. Ask the judge advisor to export the results from **Team Data**.
2. Create a final backup and download it.
3. Stop the server and keep the server folder.
