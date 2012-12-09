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
 * Refuter refutes Asker's suggestion
 * Always abide by the following structure:
 * Card1:	suspect
 * Card2:	weapon
 * Card3:	room
 * ^ Maybe just make the names of the vars suspect, weapon, room?
 */
observe(Asker, Card1, Card2, Card3, Refuter) :-
	storeQuestion(Asker, Card1, Card2, Card3, Refuter),
	eliminateExcess(Card1, Card2, Card3),
	((Refuter == none)
		->	noResponse(Asker, Card1, Card2, Card3)
		;	responseTo(Asker, Card1, Card2, Card3, Refuter)
	).

/*
 * When someone responds to another player question
 */
responseTo(Asker, Card1, Card2, Card3, Refuter) :-
	forall(playersBetween(Asker, Refuter, X),
		(setHand(X, hasnot, Card1), setHand(X, hasnot, Card2), setHand(X, hasnot, Card3))),
	%The Refuter possibly has one of the three cards:
	%On the other hand, if ANY player has the card, we know he does not
	((hand(Refuter, has, Card1) ; hand(Refuter, hasnot, Card1))
		-> write('Refuter already has card') %TODO: Make this a null operator after debug
		; setHand(Refuter, maybe, Card1)
	),
	((hand(Refuter, has, Card2) ; hand(Refuter, hasnot, Card2))
		-> write('Refuter already has card') %TODO: Make this a null operator after debug
		; setHand(Refuter, maybe, Card2)
	),
	((hand(Refuter, has, Card3) ; hand(Refuter, hasnot, Card3))
		-> write('Refuter already has card') %TODO: Make this a null operator after debug
		; setHand(Refuter, maybe, Card3)
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
 * When Refuter responds to the AI with a CardShown
 */
see(Refuter, Card1, Card2, Card3, CardShown) :-
	me(Me),
	forall(playersBetween(Me, Refuter, X), 	
		(setHand(X, hasnot, Card1), setHand(X, hasnot, Card2), setHand(X, hasnot, Card3))),
	forall(player(X), asserta(hand(X, hasnot, CardShown))),
	setHand(Refuter, has, CardShown).

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
	suspect(room, Room).

/*
 * What the AI should ask after the AI enters a room
 * This is an important part of the AI that is essentially the BRAIN!
 */
ai_suspects(Suspect, Weapon, Room) :-
	suspect(suspect, Suspect),
	suspect(weapon, Weapon).

