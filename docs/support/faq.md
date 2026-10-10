# FAQ

## General

??? question "Does TMS need the internet?"
    No. Everything runs on the local network. Internet is only needed to download TMS, or for optional [remote access](../admin/remote-access.md).

??? question "What devices can be used?"
    Anything with a modern web browser, plus the iOS app. Tablets are ideal for referees; phones work for queuers; laptops suit the head referee, judge advisor and admin. Some management screens need a larger screen and will say so on a phone.

??? question "How many devices can connect?"
    There is no fixed limit. A typical event with a tablet per table, a few laptops and several display screens is well within what a modest laptop can serve.

??? question "Which seasons are supported?"
    See [Seasons and games](../guides/seasons.md). Any other game can be run in **Agnostic** mode with manual score entry.

??? question "Does TMS handle judging scores?"
    No. TMS schedules judging sessions and tracks whether each team's rubrics have been received, but the rubric scores are recorded outside TMS.

??? question "Can I try it before an event?"
    Yes. Run the server on your own computer, open `http://localhost:8080`, log in as `admin` and import a schedule. When you are finished, **Purge** in Setup clears it, or just delete the folder.

## Setup

??? question "Where do I get a schedule file?"
    From the FLL scheduler used by *FIRST* Australia. See [Schedules](../guides/schedule.md).

??? question "Can I run an event without a schedule file?"
    Yes. Add teams, tables, matches, pods and sessions by hand on their pages. It is slower, but everything the import creates can be created manually.

??? question "Can I change the schedule during the event?"
    Yes, at any time. Changes appear on every device immediately. See [Editing after import](../guides/schedule.md#editing-after-import).

??? question "Can two events run at once?"
    Yes, with two servers. Use two folders and two ports, for example `--port 8080` and `--port 8081`. Each server is one event.

??? question "Can I move an event to another computer?"
    Yes, with a backup. See [Moving an event to another computer](../admin/backups.md#moving-an-event-to-another-computer).

## On the day

??? question "A tablet's battery died mid-scoresheet. Is anything lost?"
    Only the answers on that screen that had not been submitted. Charge or swap the tablet, log in, select the table and score again.

??? question "The server computer restarted. Is the event lost?"
    No. Everything is saved as it happens. Start the server again from the same folder and devices reconnect by themselves.

??? question "Can a referee change a score after submitting?"
    No. The judge advisor can. This is deliberate, so that every correction goes through one person.

??? question "Can two referees score the same table?"
    Only one scoresheet should be submitted per team per round. If two are submitted, TMS flags a conflict and the judge advisor resolves it.

??? question "How are ties broken?"
    By second-best score, then third-best, and so on. See [Rankings and the scoreboard](../guides/rankings.md).

??? question "Can the scoreboard be hidden for the final round?"
    There is no setting for it. Take the scoreboard off the public screens, or show the Timer instead.

??? question "Why do I hear the match sounds more than once?"
    Several screens play them: the Timer, the Match Controller, the Match Announcer and the Dashboard. Connect one to the speakers and mute the rest. See [Match timer](../guides/timer.md#where-the-timer-appears).

## Data and privacy

??? question "Where is the data stored?"
    Only on the server computer, in the server folder. Nothing is sent anywhere else unless you turn on remote access.

??? question "What personal data does TMS hold?"
    Team names and affiliations, the names referees type in, usernames and passwords for the event, and referees' private comments. Treat backups accordingly.

??? question "How do I delete an event's data?"
    Delete the server folder, including its `backups` folder, and any backups you downloaded.

## Project

??? question "Is this version still developed?"
    This is the legacy codebase. It receives season updates and maintenance. New features are going into the rebuild; see the [repository](https://github.com/CJBuchel/TMS).

??? question "How do I report a bug or a scoring error?"
    [Open an issue](https://github.com/CJBuchel/TMS/issues). For a scoring error include the season, the mission and the rule reference. For anything else, see [what to send with a bug report](logs.md#what-to-send-with-a-bug-report).
