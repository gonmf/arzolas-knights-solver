# arzolas-knights-solver
Simple solver for Arzola's puzzle game KNIGHTS https://store.steampowered.com/app/476240/KNIGHTS/

As an example the solution for board C3 of Puzzle Pack Queen is given.

Edit the knights.rb file where it says `game_string = `.

For `game_string = '4;5;rxxbb..rx..xx..xx..x;b..rryyb.yy......yy.'` a possible output is:

```
Found at try #35070 (size 51, new record)
D4-C2, A4-B2, C3-A4, B3-D4, D5-C3, D4-B3, C2-D4, B4-D5, D4-C2, B3-D4, C2-B4, A5-B3, C4-A5, B2-C4, A4-B2, C3-A4, B4-C2, D5-C3, C2-B4, B4-D5, D4-C2, C2-B4, B3-D4, D4-C2, A5-B3, C4-A5, B2-C4, B3-D4, C4-B2, A5-B3, B2-C4, C4-A5, A4-B2, C3-A4, B2-C4, A4-B2, D5-C3, B4-D5, C3-A4, D5-C3, C2-B4, D4-C2, B4-D5, C2-B4, B3-D4, B4-C2, A5-B3, D5-B4, C4-A5, B2-C4, B4-D5
```

## Puzzle string format

A string like `4;5;rxxbb..rx..xx..xx..x;b..rryyb.yy......yy.` has four components separated by a semicolons:

- width of the board
- height of the board
- list from left to right, top to bottom, of the board (free, blocked or goal color)
- list from left to right, top to bottom, of the board pieces (knights)

The position codes are: free ".", blocked "x", goal positions "r" or "b" for red and blue, and pieces are "r", "b" or "y" for yellow.

## Solution format

The solution is given for a board using chess coordinates, for instance for 4x5:

```
  A  B  C  D
5 .  .  .  . 5
4 .  .  .  . 4
3 .  .  .  . 3
2 .  .  .  . 2
1 .  .  .  . 1
  A  B  C  D
```
