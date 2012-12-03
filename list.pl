% Players(name)
player(green).
player(plum).
player(mustard).
player(peacock).
player(scarlet).
player(white).
player(envelope). %TODO: rewrite in proper nextPlayering for gameboard

nextPlayer(white, green).
nextPlayer(green, plum).
nextPlayer(plum, mustard).
nextPlayer(mustard, peacock).
nextPlayer(peacock, scarlet).
nextPlayer(scarlet, white).
%specially assert envelope doesn't have a card

/*
nextPlayer(Begin, End) :-
	nextPlayer(B, Begin),
	(B = 6 -> E is 1; E is B + 1),
	nextPlayer(E, End).

playerSpan(Begin, End, X) :-
	nextPlayer(B, Begin),
	nextPlayer(E, End),
	X is E - B,
	X \= 1 ->
		playerSpan(, End
*/
me(mustard).

%you have to be a player to have a hand
:- dynamic(hand/3).
hand(Player, Status, Card) :-
	player(Player),
	card(_, Card).

% card(Type, Description)
card(person, green).
card(person, plum).
card(person, mustard).
card(person, peacock).
card(person, scarlet).
card(person, white).

card(weapon, candlestick).
card(weapon, knife).
card(weapon, pipe).
card(weapon, revolver).
card(weapon, rope).
card(weapon, wrench).

card(room, conservatory).
card(room, lounge).
card(room, kitchen).
card(room, library).
card(room, hall).
card(room, study).
card(room, ballcard).
card(room, dining).
card(room, billiard).