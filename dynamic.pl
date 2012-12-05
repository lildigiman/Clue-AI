/*
 * dynamic.pl - every dynamic predicate
 */

/*
 * Questions
 * question(Asker, Card1, Card2, Card3, Responder).
 */
:- dynamic(question/5).

/*
 * Which player the AI is
 */
:-dynamic(me/1).
me(mustard). % Mustard is the default AI player

/*
 * Player Hand is stored here
 */
:- dynamic(hand/3).

/*
 * The room the AI is in
 */
:- dynamic(inRoom/1).
inRoom(none). % No room by default

/*
 * Room that the AI cannot guess in again until they move to another room
 */
:- dynamic(roomNoGuess/1).
roomNoGuess(none). % Can make a guess in any room to start
