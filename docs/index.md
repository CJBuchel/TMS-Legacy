# Tournament Management System

TMS runs the robot game side of a *FIRST*{ title="For Inspiration and Recognition of Science and Technology" } LEGO League event from one small server on your local network. Referees score on tablets, the head referee runs matches and the timer, the audience watches a live scoreboard, and nothing depends on an internet connection.

!!! note "Legacy branch"
    This documentation describes the legacy TMS codebase, which is receiving maintenance and season updates only. New development happens on the rebuild.

## What TMS does

- **Digital scoring** with season scoresheets that validate answers and calculate the score for the referee.
- **Live schedules** for matches and judging sessions, imported from a schedule file and editable during the day.
- **Match control** with a shared match timer, start and end sounds, and table ready signals.
- **Live rankings** on a public scoreboard that updates as scores arrive.
- **Integrity checks** that flag missing scores, conflicting scores and schedule clashes while the event is running.
- **Automatic backups** with one-click restore.

## I am a...

Pick the page written for the job you are doing today.

<div class="grid cards" markdown>

-   :material-shield-crown: **Event administrator**

    ---

    Install the server, load the schedule, create users and keep the event healthy.

    [:octicons-arrow-right-24: Event administrator guide](roles/event-admin.md)

-   :material-whistle: **Head referee**

    ---

    Load and start matches, run the timer, fix the match schedule and tables.

    [:octicons-arrow-right-24: Head referee guide](roles/head-referee.md)

-   :material-clipboard-check: **Referee**

    ---

    Score a match at your table and submit the scoresheet.

    [:octicons-arrow-right-24: Referee guide](roles/referee.md)

-   :material-account-group: **Queuer**

    ---

    See which teams are due at the tables and check them in.

    [:octicons-arrow-right-24: Queuer guide](roles/queuer.md)

-   :material-microphone: **Emcee**

    ---

    Announce the teams on each table and follow the match as it runs.

    [:octicons-arrow-right-24: Emcee guide](roles/emcee.md)

-   :material-gavel: **Judge advisor**

    ---

    Manage teams, judging sessions and pods, correct scores and export results.

    [:octicons-arrow-right-24: Judge advisor guide](roles/judge-advisor.md)

-   :material-account-tie: **Judge**

    ---

    Find out what a judge account can see during the event.

    [:octicons-arrow-right-24: Judge guide](roles/judge.md)

-   :material-monitor: **Screen and AV operator**

    ---

    Put the scoreboard and match timer on the venue screens.

    [:octicons-arrow-right-24: Screen and AV guide](roles/av-operator.md)

</div>

## New to TMS?

<div class="grid cards" markdown>

-   :material-lightbulb-on: **Understand the system**

    ---

    How the server, the devices and the screens fit together.

    [:octicons-arrow-right-24: How TMS works](getting-started/overview.md)

-   :material-rocket-launch: **Set up an event**

    ---

    From a fresh download to a ready event in about ten minutes.

    [:octicons-arrow-right-24: Quick start](getting-started/quick-start.md)

-   :material-lifebuoy: **Something is wrong**

    ---

    Connection problems, rejected scoresheets and other common issues.

    [:octicons-arrow-right-24: Troubleshooting](support/troubleshooting.md)

</div>
