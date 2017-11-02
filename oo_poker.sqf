/*
	Author: code34 nicolas_boiteux@yahoo.fr
	Copyright (C) 2016-2018 Nicolas BOITEUX

	CLASS OO_POKER
	
	This program is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.
	
	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.
	
	You should have received a copy of the GNU General Public License
	along with this program.  If not, see <http://www.gnu.org/licenses/>. 
	*/

	#include "oop.h"

	CLASS("OO_POKER")
		PRIVATE VARIABLE("array","cards");
		PRIVATE VARIABLE("array","players");
		PRIVATE VARIABLE("array","defausse");

		PUBLIC FUNCTION("array","constructor") { 
			private _cards = [[14, "T"], [14, "C"],[14, "K"],[14, "P"],[13, "T"], [13, "C"],[13, "K"],[13, "P"],[12, "T"], [12, "C"],[12, "K"],[12, "P"],[11, "T"], [11, "C"],[11, "K"],[11, "P"],[10, "T"], [10, "C"],[10, "K"],[10, "P"],[9, "T"], [9, "C"],[9, "K"],[9, "P"],[8, "T"], [8, "C"],[8, "K"],[8, "P"],[7, "T"], [7, "C"],[7, "K"],[7, "P"],[6, "T"], [6, "C"],[6, "K"],[6, "P"],[5, "T"], [5, "C"],[5, "K"],[5, "P"],[4, "T"], [4, "C"],[4, "K"],[4, "P"],[3, "T"], [3, "C"],[3, "K"],[3, "P"],[2, "T"], [2, "C"],[2, "K"],[2, "P"]];
			MEMBER("defausse", []);
			MEMBER("cards", _cards);
			MEMBER("players", _this);
		};

		PUBLIC FUNCTION("","distributeCards") {
			private _hand = [];
			private _card = [];
			private _score = [];
			private _scores = [];

			{
				_hand = [];
				for "_i" from 0 to 4 do {
					_card = MEMBER("cards", nil) deleteAt floor(random (((count MEMBER("cards", nil)) - 1)));
					_hand pushBack _card;
					MEMBER("defausse", nil) pushBack _card;
				};
				_score = [_x] + MEMBER("checkCards", _hand) + _hand;
				_scores pushBack _score;
			} forEach MEMBER("players", nil);
			MEMBER("checkScore", _scores);
			MEMBER("cards", nil) append MEMBER("defausse", nil);
		};

		PUBLIC FUNCTION("array","checkScore") {
			private _max = -1;
			private _hauteur = -1;
			private _winner = "";

			{
				if ((_x select 1) > _max) then {
					_winner = _x select 0;
					_max = _x select 1;
					_hauteur = _x select 2;
				} else{
					if ((_x select 1) isEqualTo _max) then {
						if(_x select 2 > _hauteur) then {
							_winner = _x select 0;
							_max = _x select 1;
							_hauteur = _x select 2;
						} else {
							if((_x select 2) isEqualTo _hauteur) then{
								_winner = "Draw";
								_max = _x select 1;
								_hauteur = _x select 2;
							};
						};
					};
				};
			} forEach _this;
			hintc format ["Winner: %1 Hands: %2", _winner, _this];
		};

		PUBLIC FUNCTION("array","checkQuinteFlushRoyal") {
			private _index = 0;
			private _combinaison = [14, 13,12,11,10];
			private _result = false;
			{
				_index = _combinaison find (_x select 0);
				if(_index > -1) then { _combinaison deleteAt _index;};
			} foreach _this;
			if(count _combinaison isEqualTo 0) then { _result = true };
			_result;
		};

		PUBLIC FUNCTION("array","checkQuinteFlush") {
			private _index = 0;
			private _combinaison = [];
			private _result = false;

			if(MEMBER("checkFlush", _this)) then {
				_result = MEMBER("checkQuinte", _this);
			};
			_result;
		};

		PUBLIC FUNCTION("array","checkCarre") {
			private _result = false;
			private _combinaison = [];
			private _index = 0;

			for "_i" from 0 to 16 do { _combinaison set [_i, 0]; };
			{
				_combinaison set [_x select 0, ((_combinaison select (_x select 0)) + 1)];
			} forEach _this;

			{
				if(_x isEqualTo 4) then { _index = _index + 1;};
			} forEach _combinaison;
			if(_index isEqualTo 1) then { _result = true;};
			_result;
		};

		PUBLIC FUNCTION("array","checkFull") {
			private _result = false;
			private _combinaison = [];
			private _index = 0;

			for "_i" from 0 to 16 do { _combinaison set [_i, 0]; };
			{
				_combinaison set [_x select 0, ((_combinaison select (_x select 0)) + 1)];
			} forEach _this;

			{
				if(_x isEqualTo 3) then { _index = _index + 1;};
				if(_x isEqualTo 2) then { _index = _index + 1;};
			} forEach _combinaison;
			if(_index isEqualTo 2) then { _result = true;};
			_result;
		};

		PUBLIC FUNCTION("array","checkFlush") {
			private _result = false;
			private _combinaison = [];
			{
				_combinaison pushBackUnique (_x select 1);
			} forEach _this;
			if((count _combinaison) isEqualTo 1) then { _result = true;};
			_result;
		};

		PUBLIC FUNCTION("array","checkQuinte") {
			private _index = 0;
			private _combinaison = [];
			private _result = false;
			private _element = [];

			// sort all card
			_combinaison = [];
			{
				_combinaison pushBack (_x select 0);
			} forEach _this;
			_combinaison sort true;

			for "_i" from 0 to 4 do { 
				_element pushBack ((_combinaison select 0) + _i);
			};
			if(_element isEqualTo _combinaison) then { _result = true;};
			_result;		
		};

		PUBLIC FUNCTION("array","checkBrelan") {
			private _index = 0;
			private _result = false;
			private _combinaison = [];

			for "_i" from 0 to 16 do { _combinaison set [_i, 0]; };
			{
				_combinaison set [_x select 0, ((_combinaison select (_x select 0)) + 1)];
			} forEach _this;

			{
				if(_x isEqualTo 3) then { _index = _index + 1;};
				if(_x isEqualTo 2) then { _index = _index + 2;};
			} forEach _combinaison;
			if(_index isEqualTo 1) then { _result = true;};
			_result;
		};

		PUBLIC FUNCTION("array","checkDoublePair") {
			private _result = false;
			private _combinaison = [];
			private _index = 0;

			for "_i" from 0 to 16 do { _combinaison set [_i, 0]; };
			{
				_combinaison set [_x select 0, ((_combinaison select (_x select 0)) + 1)];
			} forEach _this;

			{
				if(_x isEqualTo 2) then { _index = _index + 1;};
			} forEach _combinaison;
			if(_index isEqualTo 2) then { _result = true;};
			_result;
		};		

		PUBLIC FUNCTION("array","checkPair") {
			private _result = false;
			private _combinaison = [];
			private _index = 0;

			for "_i" from 0 to 16 do { _combinaison set [_i, 0]; };
			{
				_combinaison set [_x select 0, ((_combinaison select (_x select 0)) + 1)];
			} forEach _this;

			{
				if(_x isEqualTo 3) then { _index = _index + 2;};
				if(_x isEqualTo 2) then { _index = _index + 1;};
			} forEach _combinaison;
			if(_index isEqualTo 1) then { _result = true;};
			_result;
		};

		PUBLIC FUNCTION("array","checkHauteur") {
			private _combinaison = [];

			// sort all card
			_combinaison = [];
			{
				_combinaison pushBack (_x select 0);
			} forEach _this;
			_combinaison sort false;
			_combinaison select 0;
		};


		PUBLIC FUNCTION("array","checkCards") {
			private _hand = _this;
			private _combinaison = [];
			private _combinaison2 = [];
			private _index = 0;
			private _score = 0;

			private _result1 = MEMBER("checkQuinteFlushRoyal", _hand);
			private _result2 = MEMBER("checkQuinteFlush", _hand);
			private _result3 = MEMBER("checkCarre", _hand); 
			private _result4 = MEMBER("checkFull", _hand); 
			private _result5 = MEMBER("checkFlush", _hand);
			private _result6 = MEMBER("checkQuinte", _hand);
			private _result7 = MEMBER("checkBrelan", _hand);
			private _result8 = MEMBER("checkDoublePair", _hand);
			private _result9 = MEMBER("checkPair", _hand);
			private _result10 = MEMBER("checkHauteur", _hand);

			if(_result1) exitWith { [9, _result10, "Quinte Flush Royal"]; };
			if(_result2) exitWith { [8, _result10, "Quinte Flush"]; };				
			if(_result3) exitWith { [7, _result10, "Carre"]; };
			if(_result4) exitWith { [6, _result10, "Full"]; };
			if(_result5) exitWith { [5, _result10, "Flush"]; };
			if(_result6) exitWith { [4, _result10, "Quinte"]; };
			if(_result7) exitWith { [3, _result10, "Brelan"]; };
			if(_result8) exitWith { [2, _result10, "Double Pair"]; };
			if(_result9) exitWith { [1, _result10, "Pair"];};
			if(true) exitWith { [0, _result10, "Hauteur"];};
		};
	
		PUBLIC FUNCTION("","deconstructor") { 
			DELETE_VARIABLE("cards");
			DELETE_VARIABLE("players");
		};
	ENDCLASS;