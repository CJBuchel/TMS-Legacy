# Guide

## Queuer

Our recommended usage is for each Queuer to have an iPad/Tablet. 

![alt text](image.png)

The role of the queuer is to ensure teams are arriving to robot game matches on time. The queuer page of TMS provides data on upcoming matches. 

## Page Objects:
### **TTL**
Time To Live, Mins:Secs until match play begins. At 0 the referees will be wanting to begin the match.

### **Status**
Displays explict queuing stages

| Message      | Description                          |
| ----------- | ------------------------------------ |
| `Not Queuing`    | This match's teams do not require instruction at this time |
| `Queuing Soon`       | This match's teams, will soon be required to attend the robot game area |
| `Now Queuing`       | This match's teams now needs to go to the robot game area, potentially immediately |
| `On Deck` | This match is currently in play |

### **Match Number**
This gray box contains the match number, with the time the match will be beginning below.

### **Team Boxes**
For every match the teams competing are listed in boxes, one for each team. 
Within that box is the table the team will be playing on, the team number, and team name.

Tapping on the box will change the check-in state of the team:

| Colour      | Description                          |
| ----------- | ------------------------------------ |
| No Colour - `No State`    | This team has not made their way to the game tables, or otherwise has not been contacted |
| Green - `At Tables`       | This team is present at the rendevouz |
| Orange - `No Show / Not Playing`       | This team will not be playing in this match, no show score or other agreement made with Head Referee |

