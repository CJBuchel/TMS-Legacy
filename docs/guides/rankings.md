# Rankings and the scoreboard

TMS recalculates every team's rank each time a scoresheet is added, changed or removed. Nobody needs to press anything.

## How teams are ranked

Teams are ranked on their **best score**, the same way the official FLL robot game ranking works.

1. Each team's scores are sorted from highest to lowest.
2. Teams are compared on their highest score.
3. If those are equal, they are compared on their second-highest score, then their third, and so on.
4. Teams that are equal on every score they both have share a rank.

!!! example
    | Team | Round 1 | Round 2 | Round 3 | Best | Rank |
    | --- | ---: | ---: | ---: | ---: | :---: |
    | A | 250 | 310 | 280 | 310 | 1 |
    | B | 310 | 200 | 260 | 310 | 2 |
    | C | 300 | 305 | 190 | 305 | 3 |

    A and B both have a best score of 310. A's second-best is 280 and B's is 260, so A ranks higher.

A team with no scoresheets has no rank yet.

## What counts

Every scoresheet a team has counts towards its ranking, including a no-show, which counts as zero.

!!! warning "Round 0"
    A scoresheet recorded against round 0 was submitted without a real round, usually because no match was loaded when the referee submitted. It still counts towards ranking. TMS raises warning `W003` so the judge advisor can move the sheet to the right round or remove it.

## The scoreboard

The public **Scoreboard** shows, for every team:

- its **rank**,
- its **name**,
- its **best** score, and
- its score in each **round**.

A round with no score yet shows `?`. A round with more than one scoresheet shows **Conflict** until the judge advisor resolves it; see [Conflicting scores](scoring.md#conflicting-scores).

The number of round columns grows as rounds are played.

Optional panels, switched on with the tick boxes at the top, show the upcoming **match schedule** and **judging schedule**. See the [screen and AV operator guide](../roles/av-operator.md#the-scoreboard).

## Hiding scores late in the day

Some events stop showing live scores before the final round so that results are a surprise at the ceremony. TMS has no switch for this. The simplest way is to take the scoreboard off the public screens, or show the Timer instead, for the final round.

## Getting the final results

The judge advisor exports the final table from **Team Data**, which includes rank and every round's score, Gracious Professionalism rating and comment. See the [judge advisor guide](../roles/judge-advisor.md#team-data).
