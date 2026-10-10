# Seasons and games

A **season** in TMS is a scoresheet: the missions, questions, points and checks for one robot game. The event administrator chooses the season in **Setup → Season Setup → Select Blueprint**.

## Available seasons

| Blueprint | Game | Notes |
| --- | --- | --- |
| `2026-Founders` | BIOGLOW, Founders edition | Missions M00 to M15 plus precision tokens |
| `2026-Future` | BIOGLOW, Future edition | Five missions plus the Level Up Challenge |
| `2025` | UNEARTHED | |
| `2024` | SUBMERGED | |
| `2023` | MASTERPIECE | |
| `Agnostic` | Any | Score entry only, no scoresheet |

!!! info "Two games in 2026"
    The 2026 season has two editions of the game, played by different programs. They are separate blueprints because their fields, missions and scoresheets are different. Choose the one your event is running. An event runs one blueprint at a time.

## Changing the season

You can change the blueprint at any time. Scoresheets already submitted keep the season they were scored under, so their scores do not change.

Change it before referees start scoring. If the blueprint changes while a referee has a sheet open, their sheet resets to the new season's defaults.

## BIOGLOW Founders (`2026-Founders`)

| Mission | Name |
| --- | --- |
| M00 | Equipment Inspection Bonus |
| M01 | Drone Survey |
| M02 | Exploding Seeds |
| M03 | Flip the Rock |
| M04 | Lucky Leaves |
| M05 | Reaching Roots |
| M06 | Leafcutter Frenzy |
| M07 | Humongous Fungus |
| M08 | Tangled |
| M09 | Research Platform |
| M10 | Fragile Microhabitats |
| M11 | Window to the Past |
| M12 | Forest Elder |
| M13 | Keystone Species |
| M14 | Seeds of Renewal |
| M15 | Biocentric Architecture |
| M16 | Precision Tokens |

Missions marked with a red dot on the scoresheet have no equipment constraint.

Checks the scoresheet makes for you:

- **M01**: the LiDAR map bonus needs the drone to have been flown.
- **M03**: the rock bonus needs the research flag to be down.
- **M04**: the second leaf only scores with the katydid in its starting position, and a katydid outside the leaf habitat scores zero for the mission.
- **M06**: leaf fragments only count when the ant is touching the nest.
- **M07**: connection bonuses need the mycelium completely extended.
- **M14**: seeds in the replantation station cannot exceed the seeds released in M02 and M09, and seeds touching the mat cannot exceed seeds in the station.
- **M15**: the environmental bonus is scored when the feature matching the model's dock is complete.

## BIOGLOW Future (`2026-Future`)

| Mission | Name |
| --- | --- |
| M01 | Mighty Microbiomes |
| M02 | Roots of Renewal |
| M03 | Cave Waterfall |
| M04 | Rainforest Awakening |
| M05 | Central Haven (Cooperative) |
| Level Up | Invasive Attack |

Several questions in this game are counts with a large range, such as the cave waterfall counter from 0 to 50. These use the counter control described in [Scoring and scoresheets](scoring.md#questions).

Checks the scoresheet makes for you:

- **M01**: the invasive queen bonus needs three keystone species in the young forest.
- **Level Up**: invasive species in the containment zone cannot exceed the number added before the match plus the queen.

## Mission images

Each mission on the scoresheet shows a picture of its model so that referees can find the right block quickly. If a mission has no picture, the *FIRST* logo is shown instead.

## Official rules come first

TMS scoresheets follow the published robot game rules and the official scoresheet for each season. If a ruling at your event differs from what the scoresheet allows, the head referee decides, and the judge advisor can adjust a submitted sheet to match.

If you believe a scoresheet in TMS is wrong, please [raise an issue](https://github.com/CJBuchel/TMS/issues) with the mission and the rule reference.

!!! note "For developers"
    Adding a season is described in [Adding a season](../dev/adding-a-season.md).
