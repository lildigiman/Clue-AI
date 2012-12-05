/*
 * clue.pl
 *
 */

/*
 * STATUSES of hands:
 * has
 * hasnot
 * maybe
 *
 * IMPORTANT NOTE: Player and Suspect are two seperate entities. Player
 * 		represents the players of the game while suspects are the cards
 */

/*
 * Responder responds to Asker with a card
 * Always abide by the following structure:
 * Card1:	suspect
 * Card2:	weapon
 * Card3:	room
 * ^ Maybe just make the names of the vars suspect, weapon, room?
 */
observe(Asker, Card1, Card2, Card3, Responder) :-
	storeQuestion(Asker, Card1, Card2, Card3, Responder),
	((Responder == none)
		-> noResponse(Asker, Card1, Card2, Card3)
		; responseTo(Asker, Card1, Card2, Card3, Responder)
	).

/*
 * When someone responds to another player question
 */
responseTo(Asker, Card1, Card2, Card3, Responder) :-
	forall(playersBetween(Asker, Responder, X), 	
		(setHand(X, hasnot, Card1), setHand(X, hasnot, Card2), setHand(X, hasnot, Card3))),
	%The Responder possibly has one of the three cards:
	%On the other hand, if ANY player has the card, we know he does not
	((hand(Responder, has, Card1) ; hand(Responder, hasnot, Card1))
		-> write('Responder has card') %TODO: Make this a null operator after debug
		; setHand(Responder, maybe, Card1)
	),
	((hand(Responder, has, Card2) ; hand(Responder, hasnot, Card2))
		-> write('Responder has card') %TODO: Make this a null operator after debug
		; setHand(Responder, maybe, Card2)
	),
	((hand(Responder, has, Card3) ; hand(Responder, hasnot, Card3))
		-> write('Responder has card') %TODO: Make this a null operator after debug
		; setHand(Responder, maybe, Card3)
	).

/*
 * When no one responds
 */
noResponse(Asker, Card1, Card2, Card3) :-
	%Everyone but the Asker may have the card
	forall((player(X), X \== Asker),
		(setHand(X, hasnot, Card1), setHand(X, hasnot, Card2), setHand(X, hasnot, Card3))).
	
/*
 * Deprecated Function. Delete me at some point?
 */
infer(Player, Card) :-
	asserta(Player, maybe, Card).

/*
 * When Responder responds to the AI with a CardShown
 */
see(Responder, Card1, Card2, Card3, CardShown) :-
	me(Me),
	forall(playersBetween(Me, Responder, X), 	
		(setHand(X, hasnot, Card1), setHand(X, hasnot, Card2), setHand(X, hasnot, Card3))),
	forall(player(X), asserta(hand(X, hasnot, CardShown))),
	setHand(Responder, has, CardShown).

/*
 * See if Player is between the Begin player and End Player
 */
isBetween(Player, Begin, End) :-
	numPlayersBetween(Begin, End, Y),
	numPlayersBetween(Begin, Player, Z),
	Z < Y,
	Begin \== Player.

/*
 * List of all Players between Begin player and End player
 */
playersBetween(Begin, End, Player) :-
	player(Player),
	Player \== envelope, %Ignore the envelope because it does not take a turn
	isBetween(Player, Begin, End).

/*
 * Returns the number of players between Begin player and End player
 */
numPlayersBetween(Begin, End, NumBetween) :-
		numPlayersBetween(Begin, End, NumBetween, 0).

/*
 * The optimal room the AI would like to go to
 */
go_to(Room) :-
	suspect(Room, room).

/*
 * What the AI should ask after the AI enters a room
 */
ai_suspects(Suspect, Weapon, Room) :-
	suspect(Suspect, suspect),
	suspect(Weapon, weapon).

/*
 * This is an attempt to grab a player or card (or both?) to ask questions
 */
suspect(Suspect, Type) :-
	card(Type, Item),
	card(suspect, Suspect),
	\+ hand(Suspect, has, Item),
	\+ hand(Suspect, hasnot, Item).
