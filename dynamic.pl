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
