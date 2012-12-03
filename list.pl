/*
 * list.pl
 *
 */


/*
 * IMPORTANT NOTE: Player and Suspect are two seperate entities. Player
 * 		represents the players of the game while suspects are the cards
 *
 * Players(name)
 */
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
%specially assert envelope does not have a card

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
/*hand(Player, Status, Card) :-
	player(Player),
	card(_, Card).
	FIXME: I removed this to fix observe function... Make sure this does not
		effect anything else!
*/
% card(Type, Description)
card(suspect, green).
card(suspect, plum).
card(suspect, mustard).
card(suspect, peacock).
card(suspect, scarlet).
card(suspect, white).

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

/*
 * Questions
 * question(Asker, Card1, Card2, Card3, Responder).
 */
:- dynamic(question/5).
