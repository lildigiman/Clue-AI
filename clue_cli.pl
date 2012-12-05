/*
 * clue_cli.pl - The basic cli interface
 *
 */

/*
 * Start a Game
 * TODO: Do we need to reconsult everything?
 */
run :-
	consult('clue.pl'),
	consult('list.pl'),
	consult('internal.pl'),
	consult('dynamic.pl'),
	init,
	nextTurn.
	
/*
 * Initialize the game by getting the AI's player name
 */
init :-
	write('What player am I?'), nl,
	read(WHOAMI),
	retract(me(mustard)),
	asserta(me(WHOAMI)),
	write('Got it. I\'m '), write(WHOAMI), nl.

/*
 * One whole round for a player
 */
nextTurn :-
	write('Who\'s Turn?'), nl,
	read(Asker),
	me(Me),
	((Asker == Me)
		->	myTurn
		; othersTurn(Asker)
	),
	nextTurn.

/*
 * What happens during AIs turn
 */
myTurn :-
	inRoom(Room),
	(Room \== none
		->	(% Find the best suspect and weapon to ask for based on what room AI is in
			ai_suspects(Suspect, Weapon, Room),
			write('I suspect '), write(Suspect),
			write(' did it with the '), write(Weapon),
			write(' in the '), write(Room), nl,
			write('Who responded? If no one responds, please write \'none.\''), nl,
			read(Responder), % Insert 'none' if no one responds
			(Responder == none
				->	write('Oh okay, no one responded')
				;	write('With what?'), read(CardShown), see(Responder, Card1, Card2, Card3, CardShown)
			))
		;	write('I am so sad that I cannot do anything.')
	).

/*
 * What happens during other players turn
 */
othersTurn(Asker) :-
	write(Asker), write(' suspects who?'), nl,
	read(Card1),
	write('With what Weapon?'), nl,
	read(Card2),
	write('In what Room?'), nl,
	read(Card3),
	write('Who responded?'), nl,
	read(Responder),
	(Responder == none
		->	write('No one responded.')
		;	observe(Asker, Card1, Card2, Card3, Responder)
	),
	nextTurn.
