		call compilefinal preprocessFileLineNumbers "oo_poker.sqf";

		sleep 2;

		 poker = ["new", ["code34", "computer", "Jamy"]] call OO_POKER;
		 player addAction ["Distribute cards", {'distributeCards' call poker;}];