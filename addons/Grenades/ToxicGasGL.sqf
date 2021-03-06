//	@file Name: ToxicGasGL.sqf
//  @file Author: Mokey
//	@file Description: Toxic Gas addon for A3W
//	@web: http://www.fractured-gaming.com
//	@Special Thanks to Pitoucc, CREAMPIE, and Izzer

_gasMask = [
            "H_CrewHelmetHeli_B",
            "H_CrewHelmetHeli_O",
            "H_CrewHelmetHeli_I",
            "H_HelmetO_ViperSP_ghex_F",
            "H_HelmetO_ViperSP_hex_F"
          ];

_exemptVehicles = [
                    "B_MRAP_01_F",
                    "B_MRAP_01_hmg_F",
                    "B_MRAP_01_gmg_F",
                    "O_MRAP_02_F",
                    "O_MRAP_02_hmg_F",
                    "O_MRAP_02_gmg_F",
                    "I_MRAP_03_F",
                    "I_MRAP_03_hmg_F",
                    "I_MRAP_03_gmg_F",
                    "O_APC_Wheeled_02_rcws_v2_F",
                    "B_APC_Wheeled_01_cannon_F",
                    "I_APC_Wheeled_03_cannon_F",
                    "B_AFV_Wheeled_01_cannon_F",
                    "B_AFV_Wheeled_01_up_cannon_F",
                    "I_LT_01_scout_F",
                    "I_LT_01_cannon_F",
                    "I_LT_01_AT_F",
                    "I_LT_01_AA_F",
                    "B_APC_Tracked_01_CRV_F",
                    "B_APC_Tracked_01_rcws_F",
                    "I_APC_tracked_03_cannon_F",
                    "O_APC_Tracked_02_cannon_F",
                    "B_APC_Tracked_01_AA_F",
                    "O_APC_Tracked_02_AA_F",
                    "B_MBT_01_cannon_F",
                    "B_MBT_01_TUSK_F",
                    "O_MBT_02_cannon_F",
                    "I_MBT_03_cannon_F",
                    "O_T_MBT_04_cannon_F",
                    "O_T_MBT_04_command_F"
                  ];

setNoGasStatusGL = {
    "dynamicBlur" ppEffectEnable true;                  // enables ppeffect
    "dynamicBlur" ppEffectAdjust [0];                   // enables normal vision
    "dynamicBlur" ppEffectCommit 10;                    // time it takes to go back to normal vision
    resetCamShake;                                      // resets the shake
    20 fadeSound 1;                                     // fades the sound back to normal
};

setGasStatusGL = {
    "dynamicBlur" ppEffectEnable true;              	// enables ppeffect
    "dynamicBlur" ppEffectAdjust [6];             	  	// intensity of blur
	"dynamicBlur" ppEffectCommit 12;                 	// time till vision is fully blurred
	enableCamShake true;                             	// enables camera shake
	addCamShake [10, 45, 10];                        	// sets shakevalues
//	player setFatigue 1;                            	// sets the fatigue to 100%
	5 fadeSound 0.1;                                 	// fades the sound to 10% in 5 seconds
};

gasDamageGL = {
	player setDamage (damage player + 0.05);     		//damage per tick
	sleep 3;                                 		    // Timer damage is assigned "seconds"
};

While{true} do{

	call setNoGasStatusGL;

	waituntil{
        _smokeShell = nearestObject [getPosATL player, "G_40mm_SmokeYellow"];
	    _curPlayerInvulnState = player getVariable ["isAdminInvulnerable", false];
	    _smokeShell distance player < 7 				//Change Distance from grenade for effect to trigger (in Meters)
	    &&
	    velocity _smokeShell isEqualTo [ 0, 0, 0 ]
	    &&
	    !_curPlayerInvulnState
	};

	if ((headgear player in _gasMask) || ((typeOf vehicle player) in _exemptVehicles)) then
	{
	    call setNoGasStatusGL;
	}
    else
	{
		call setGasStatusGL;
		call gasDamageGL;
	};
};
