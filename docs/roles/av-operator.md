# I am a screen and AV operator

You put TMS on the venue's screens and speakers. There are two public screens, and neither needs a login.

!!! abstract "Your screens"
    **Scoreboard** and **Timer**, both on the home screen under *Public Screens*.

## Setting up a display

1. Connect the display computer to the venue network.
2. Open the TMS address in a browser. See [Connecting a device](../getting-started/connecting.md).
3. From the home screen choose **Scoreboard** or **Timer**.
4. Put the browser in full screen. In most browsers that is ++f11++.

!!! tip
    Turn off sleep, screen savers and automatic updates on display computers for the day.

## The Scoreboard

The scoreboard lists teams in rank order with their best score and their score in each round. It updates by itself as scoresheets come in.

Two tick boxes at the top add schedule panels:

| Option | Adds |
| --- | --- |
| **Match Schedule** | The upcoming matches, with the team on each table |
| **Judging Schedule** | The upcoming judging sessions, with the team in each pod |

A common arrangement is one scoreboard with the match schedule in the competition area, and one with the judging schedule near the pits.

When there are more teams than fit on the screen the list scrolls by itself.

How ranks are worked out is explained in [Rankings and the scoreboard](../guides/rankings.md).

## The Timer

The timer shows the match clock in large digits. It follows the head referee: it counts down when a match is started, and resets when the match ends.

The corner of the screen shows the match that is loaded, or the next match on the schedule and its start time.

### Sound

The Timer screen plays the match sounds:

- a sound at the **start** of the match,
- a sound when the **end-game** period begins,
- a sound at the **end** of the match,
- a short beep for each second of a **countdown** start, and
- a **stop** sound if the head referee aborts the match.

Connect **one** computer showing the Timer to the venue sound system.

The head referee's **Match Controller**, the emcee's **Match Announcer** and the administrator's **Dashboard** play the same sounds. If any of those devices can be heard in the room as well, the audience hears each sound more than once, slightly out of step. Mute every device except the one connected to the speakers.

!!! warning "Browsers block sound until you interact with the page"
    After opening the Timer, click or tap somewhere on the page once. Otherwise the browser may stay silent for the first match. For a computer that plays sound all day, also allow sound permanently for the site; see [Match timer](../guides/timer.md#where-the-timer-appears). Test the sound with the head referee before the event starts.

### Assigning a timer to tables

On a wide screen the timer has an **Assign Timer to Table/s** button in the top right corner.

Select the tables this screen faces and confirm. The timer then shows the teams playing on those tables for the loaded match, underneath the clock. Use it when each pair of tables has its own screen.

The choice is remembered on that computer.

## Checklist

- [ ] Each display is on the venue network and showing the right screen in full screen.
- [ ] One timer computer is connected to the sound system, and other sound-playing devices are muted.
- [ ] You have clicked on the timer page and heard a test start through the speakers.
- [ ] Timers that face specific tables have those tables assigned.
- [ ] Sleep and screen savers are off.

## Common situations

??? question "The scoreboard is empty"
    No schedule has been imported, or the display is not connected. Look for connection markers in the top bar.

??? question "The timer does not move when the match starts"
    The display has lost its live connection. Reload the page. If the top bar shows connection markers, see [Troubleshooting](../support/troubleshooting.md).

??? question "There is no sound"
    Click on the timer page, check the computer's volume and output device, and check the browser tab is not muted.

??? question "Every sound plays twice"
    Another device with a sound-playing screen (Timer, Match Controller, Match Announcer or Dashboard) is audible. Mute it.
