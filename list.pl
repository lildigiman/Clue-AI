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

/*
 * The next player after the current
 * nextPlayer(current, next).
 */
nextPlayer(white, green).
nextPlayer(green, plum).
nextPlayer(plum, mustard).
nextPlayer(mustard, peacock).
nextPlayer(peacock, scarlet).
nextPlayer(scarlet, white).
% specially assert envelope does not have a card

/*
 * All Cards in the Game Of Clue
 * card(Type, Description)
 */
% suspects
card(suspect, green).
card(suspect, plum).
card(suspect, mustard).
card(suspect, peacock).
card(suspect, scarlet).
card(suspect, white).
% weapons
card(weapon, candlestick).
card(weapon, knife).
card(weapon, pipe).
card(weapon, revolver).
card(weapon, rope).
card(weapon, wrench).
% rooms
card(room, conservatory).
card(room, lounge).
card(room, kitchen).
card(room, library).
card(room, hall).
card(room, study).
card(room, ballcard).
card(room, dining).
card(room, billiard).
