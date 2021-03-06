/*
 * Author: BaerMitUmlaut, modified by Kex
 * Waypoint function for the fast rope waypoint.
 *
 * Arguments:
 * 0: Group <GROUP>
 * 1: Waypoint position <ARRAY>
 *
 * Return Value:
 * true
 *
 * Example:
 * [_group, [6560, 12390, 0]] call ace_fastroping_fnc_deployAIWayoint
 *
 * Public: No
 */

params [["_group", grpNull, [grpNull]], ["_position", [0, 0, 0], [[]], 3]];

private _vehicle = vehicle leader _group;

// Kex: check if ACE or advanced rappeling is available
private _ace_loaded = isClass (configfile >> "CfgPatches" >> "ace_main");
private _ar_loaded = isClass (configfile >> "CfgPatches" >> "AR_AdvancedRappelling");
if (!_ace_loaded and !_ar_loaded) exitWith
{
	["ACE3 or AR is not loaded!"] call Achilles_fnc_showZeusErrorMessage;
	_vehicle setVariable["Achilles_var_noFastrope", true];
	true;
};

//////////////////////////////////////
// executed on second script call
if (!isNil {_group getVariable ["Achilles_var_fastrope",nil]}) exitWith
{
	_group setVariable ["Achilles_var_fastrope",nil];

	// - Deployment ---------------------------------------------------------------
	if (!_ar_loaded) then
	{
		private _helo_pos = +_position;
		_helo_pos set [2,20];
		_vehicle setVariable ["ACE_Rappelling",true];

		// modified code from Advanced Rappeling by Duda.
		[_vehicle, _helo_pos] spawn {
			params ["_vehicle","_position"];

			while { !isNil {_vehicle getVariable ["ACE_Rappelling",nil]} and alive _vehicle and alive (driver _vehicle)} do
			{

				private _velocityMagatude = 5;
				private _distanceToPosition = ((position _vehicle) distance _position);
				if( _distanceToPosition <= 15 ) then {
					_velocityMagatude = (_distanceToPosition / 10) * _velocityMagatude;
				};

				private _currentVelocity = velocity _vehicle;
				_currentVelocity = _currentVelocity vectorAdd (( (position _vehicle) vectorFromTo _position ) vectorMultiply _velocityMagatude);
				_currentVelocity = (vectorNormalized _currentVelocity) vectorMultiply ( (vectorMagnitude _currentVelocity) min _velocityMagatude );
				_vehicle setVelocity _currentVelocity;

				sleep 0.05;
			};
		};
		waitUntil {sleep 1; speed _vehicle < 0.05 and ((position _vehicle) select 2 < 25)};
		[_vehicle] call ace_fastroping_fnc_deployAI;
		waitUntil {sleep 1; !((_vehicle getVariable ["ace_fastroping_deployedRopes", []]) isEqualTo [])};
		waitUntil {sleep 1; ((_vehicle getVariable ["ace_fastroping_deployedRopes", []]) isEqualTo [])};
		_vehicle setVariable ["ACE_Rappelling",nil];
	} else
	{
		private _positionASL = _position;
		if (!(surfaceIsWater _position)) then
		{
			_positionASL = ATLToASL _position;
		};
		[_vehicle,25,_positionASL] call AR_Rappel_All_Cargo;
	};
	true
};
//
//////////////////////////////////////

// Kex: check if vehicle is capable of FRIES and if true equip it with FIRES
private _rope_available = true;
if (!_ar_loaded) then
{
	[_vehicle]  call ace_fastroping_fnc_equipFRIES;
	if (!([_vehicle]  call ace_fastroping_fnc_canPrepareFRIES)) then { _rope_available = false;	};
};
if (!_rope_available) exitWith {true};

// Kex: prevent pilot from being stupid
_group allowFleeing 0;
private _pilot = driver _vehicle;
_pilot setSkill 1;

_group setVariable ["Achilles_var_fastrope",true];

private _wp_index = currentwaypoint _group;

[_group,_wp_index,_position] spawn
{
	params ["_group","_wp_index","_wp_pos"];
	_group addWaypoint [_wp_pos, 100, _wp_index];
};
