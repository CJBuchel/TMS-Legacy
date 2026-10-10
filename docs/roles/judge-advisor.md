# I am a judge advisor

You look after the teams and everything recorded against them: their details, their judging sessions, and their robot game scores. You are also the person who corrects scoresheets when something was entered wrongly. A judge advisor account can do everything a judge account can.

!!! abstract "Your screens"
    **Teams**, **Team Data**, **Judging Sessions** and **Pods**.

## Teams

The **Teams** page is where you look at one team in detail.

Select a team from the list. The page shows:

- the team's **rank**, and how many of its **matches** and **judging sessions** are complete,
- any **team issues** found by the integrity checks,
- the team's **details**: number, name and affiliation, which you can edit and save with **Update Team**, and
- the team's **scoresheets**, one row per submission, with round, score, table, referee and timestamp.

Use **Add Team** to add a team that was not in the schedule file, and **Delete Team** to remove one.

!!! warning
    Deleting a team also deletes its scoresheets. It does not remove the team from matches or judging sessions it was scheduled in; the integrity checks will flag those until the head referee and you update the schedule.

### Correcting a scoresheet

Referees cannot change a scoresheet after submitting it. You can.

On the team's page, each scoresheet row can be edited or deleted.

- **Edit Score** opens the sheet. You can change the round, table, referee and match number, change the answers, or mark it as a no-show. The score is recalculated from the answers when you save.
- **Delete Score** removes the sheet entirely.
- **Add Score Sheet** creates a sheet for the team by hand, for example from a paper scoresheet.

!!! tip "Resolving conflicting scores"
    The error `E003`, *Team has conflicting scores*, means a team has two scoresheets for the same round. Decide which is correct, then delete the other or change its round.

A sheet you have changed is marked as modified along with your username, so there is a record of who corrected it.

## Team Data

**Team Data** is a table of every team with its rank and, for each round, its score, Gracious Professionalism rating and the referee's private comment.

- **Columns** chooses which columns are shown.
- The filter boxes under the column headers narrow the table.
- **Export** downloads the table as a CSV file, exactly as it is currently filtered and with the columns currently shown.

Use the export for your results and for anything you need to pass to the judges, such as Gracious Professionalism ratings and comments.

## Judging Sessions

The **Judging Sessions** page lists every session with its number, start and end times, and the team in each pod.

- **Add Session** creates a session.
- The pencil on a row opens the **session editor**, where you can change the number and times and add, change or remove the team in each pod.
- The bin on a row deletes the session.

### Tracking judging progress

For each team in a session you can tick off three items as their rubrics come in:

- **Core Values**
- **Innovation**
- **Robot Design**

A pod is shown as done when all three are ticked. The banner at the top of the page shows how many sessions are complete, and the Dashboard shows the same count to the event administrator.

!!! note
    TMS tracks that judging rubrics have been received. It does not record the rubric scores themselves.

## Pods

The **Pods** page lists the judging rooms. You can add, rename or remove a pod. Pod names must match the names used in the sessions.

## Integrity messages for judging

The session list shows an icon on any session with a problem. Common ones:

| Code | Meaning |
| --- | --- |
| `E010` | Team has more than one judging session |
| `E011` | Team is not in any judging sessions |
| `E013` | Team has a match overlapping with its judging session |
| `W009` | Team has a judging session within 10 minutes of a match |

The full list is in [Integrity checks](../guides/integrity.md).

## End of the day

1. Check that no team has an error on the **Teams** page.
2. Open **Team Data**, choose the columns you need and **Export**.
3. Tell the event administrator you are done, so they can take the final backup.
