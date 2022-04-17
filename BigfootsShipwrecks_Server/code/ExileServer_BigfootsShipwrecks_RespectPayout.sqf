/*
ExileServer_BigfootsShipwrecks_RespectPayout
by Crito @Vanaheim Gaming Servers
Discord: https://discord.gg/WEFzqPa
*/

private ["_bsVictim","_bsKiller","_bsKillerUID","_bsKillerRespect","_bsNewRep","_bsKillMSG","_bsBoat","_bsDriver","_bsBoatCrew"];

_bsVictim = _this select 0;
_bsKiller = _this select 1;
_bsKillerUID = getPlayerUID _bsKiller;

	if(isplayer _bsKiller)then
	{
		_bsNewRep = missionNamespace getVariable ["BS_Respect_Pay",0];
		_bsKillerRespect = _bsKiller getVariable ["ExileScore", 0];
		_bsKillMSG = [[format ["Ship Wreck Guard Killed"],_bsNewRep]];
		_bsKillerRespect = _bsKillerRespect + _bsNewRep;
		_bsKiller setVariable ["ExileScore",_bsKillerRespect];
		[_bsKiller, "showFragRequest", [_bsKillMSG]] call ExileServer_system_network_send_to;
		format["setAccountScore:%1:%2", _bsKillerRespect, _bsKillerUID] call ExileServer_system_database_query_fireAndForget;
		ExileClientPlayerScore = _bsKillerRespect;
		(owner _bsKiller) publicVariableClient "ExileClientPlayerScore";
		ExileClientPlayerScore = nil;
	};

	_bsBoat = assignedVehicle _bsVictim;
	
	_bsDriver = driver _bsBoat;
			
	if (_bsVictim isEqualTo _bsDriver) then
	{
		_bsBoat engineOn false;
		
		_bsBoatCrew = crew _bsBoat;
		
		if (count _bsBoatCrew > 0) then
		{
			[_bsBoatCrew,_bsBoat] call ExileServer_BigfootsShipwrecks_AIDriverDeath;
		};
	};

	_bsVictim action ["Eject", vehicle _bsVictim];
	
	