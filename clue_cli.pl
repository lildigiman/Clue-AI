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
	write('Got it. I\'m '), write(WHOAMI), nl,
	write('My first Card?'), nl,
	read(X),
	write('My second Card?'), nl,
	read(Y),
	write('My third Card?'), nl,
	read(Z),
	setMyHand(X, Y, Z).

/*
 * One whole round for a player
 */
nextTurn :-
	write('Who\'s Turn?'), nl,
	read(Asker),
	me(Me),
	((Asker == listing)
		->	printout
		;	((Asker == Me)
				->	myTurn
				;	othersTurn(Asker)
			)
	),
	nextTurn.

/*
 * What happens during AIs turn
 *
 * TODO: Add a check to see if AI is confident enough to make an Accusation
 *		 and then act on them.
 */
myTurn :-
	/*
	TODO: PUT ME BACK!!! I tell you what room I'm in!	
	go_to(WantRoom),
	roomNoGuess(RoomNoGuess),
	inRoom(Room),
	((WantRoom == Room, Room \== RoomNoGuess)*/

	(1 is 1 % FIXME: remove this line when done testing
		->	write('What room am I in?'), nl,
			read(Room),
			% Find the best suspect and weapon to ask for based on what room AI is in
			ai_suspects(Suspect, Weapon),
			write('I suspect '), write(Suspect),
			write(' did it with the '), write(Weapon),
			write(' in the '), write(Room), nl,
			write('Who responded? If no one responds, please write \'none.\''), nl,
			read(Refuter), % Insert 'none' if no one responds
			(Refuter == none
				->	write('Oh okay, no one responded'), nl %TODO: Make this an observation still!
				;	write('With what?'), nl, read(CardShown), see(Refuter, Suspect, Weapon, Room, CardShown)
			) %,
			% roomNoGuess(Room) % Can no longer make a suggestion once we've made one
		;	write('I am so sad that I cannot do anything.'), nl
	).

/*
 * What happens during other players turn
 * TODO: insert function to what AI does if he has card
 */
othersTurn(Asker) :-
	write(Asker), write(' suspects who?'), nl,
	read(Card1),
	write('With what Weapon?'), nl,
	read(Card2),
	write('In what Room?'), nl,
	read(Card3),
	write('Who responded?'), nl,
	read(Refuter),
	observe(Asker, Card1, Card2, Card3, Refuter),
	nextTurn.
