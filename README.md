# Mus

This project is an initial approach to figuring out the probabilities of winning at the spanish card-game Mus. The idea is to feed the code the known cards and, with a few other parameters, get the chances of winning at each of the different rounds of the game.

### Why this project?

Mus is a fairly complex, imperfect information game, very typical in Spain (particularly in the north). It's my favorite card-game and the thought of writing an engine for it has been in the back of my mind for a few years now. Hopefully this is the first step towards that far-fetched goal.

In particular, a friend asked me what the odds were of a certain hand winning and, finding myself unable to give a good-enough answer, I started typing Ruby like a madman.

### About the game

Briefly, it's a four-player game played in pairs. It consists of four rounds: grande (big), chica (small), pares (pairs) and juego (game). Grande is about who has the highest hand; chica is about how has the smallest; pares is about who has the best pairs, and juego is about whose cards add up to the highest number. Each of them has different punctuation methods. The point is to bluff your way through and try to win hands you should't win.

Betting occurs in all rounds; stones are taken from the pot until one of the teams reaches 40 (or 30) and wins.

For a more in-depth explanation please refer to the [wikipedia page](https://en.wikipedia.org/wiki/Mus_(card_game)).

### Running the code

1. Download the code
```
git clone https://github.com/tempate/Mus
```

2. Edit the conf.json file to match the game-setting to evaluate.

3. You're ready to go! Run: 
```
ruby main.rb -c conf.json
```
