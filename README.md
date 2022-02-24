Setup
```
bundle
```

Run tests
```
rspec
```

Run all agents and report stats
```
./runner.sh
```
Example output:
```
Loading files
Detecting agent classes
Agent classes: AlwaysDiscardsFirstCard, AlwaysPlaysFirstCard, Cheats, SafeHintAgent
Runs per agent: 1000
Running games
....
+-----------------------------------+---------+--------+
| Agent                             | Score   | Time   |
+-----------------------------------+---------+--------+
| Cheats (Control)                  | 25.0000 | 2.2804 |
| SafeHintAgent                     | 14.7420 | 1.1177 |
| AlwaysPlaysFirstCard (Control)    |  1.2570 | 0.0699 |
| AlwaysDiscardsFirstCard (Control) |  0.0000 | 0.1480 |
+-----------------------------------+---------+--------+
Finished
```
