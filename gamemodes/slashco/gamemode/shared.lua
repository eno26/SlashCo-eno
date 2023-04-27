GM.Name = "SlashCo"
GM.Author = "Octo, Manti"
GM.Email = "N/A"
GM.Website = "N/A"
GM.TeamBased = true
GM.States = {
	LOBBY = 1,
	IN_GAME = 2
}
GM.State = GM.State or GM.States.LOBBY

include("player_class/player_survivor.lua")
include("player_class/player_slasher_base.lua")
include("player_class/player_lobby.lua")

AddCSLuaFile( "ui/fonts.lua" )

AddCSLuaFile( "cl_scoreboard.lua" )
AddCSLuaFile( "cl_headbob.lua" )
AddCSLuaFile( "cl_lobbyhud.lua" )
AddCSLuaFile( "cl_survivorhud.lua" )
AddCSLuaFile( "slasher/cl_slasher_ui.lua" )
AddCSLuaFile( "slasher/cl_slasher_picker.lua" )
AddCSLuaFile( "cl_item_picker.lua" )
AddCSLuaFile( "cl_offering_picker.lua" )
AddCSLuaFile( "cl_intro_hud.lua" )
AddCSLuaFile( "cl_roundend_hud.lua" )
AddCSLuaFile( "cl_jumpscare.lua" )
AddCSLuaFile( "cl_offervote_hud.lua" )
AddCSLuaFile( "cl_spectator_hud.lua" )
AddCSLuaFile( "cl_playermodel_picker.lua" )
AddCSLuaFile( "cl_gameinfo.lua" )

CreateConVar( "slashco_player_cycle", "0", FCVAR_REPLICATED ) --local cycle_players =

function GM:Initialize()
	-- Do stuff
end

function GM:CreateTeams()

	if ( not GAMEMODE.TeamBased ) then return end

	TEAM_SURVIVOR = 1
	team.SetUp( TEAM_SURVIVOR, "Survivor", Color( 255, 255, 255 ) )

	TEAM_SLASHER = 2
	team.SetUp( TEAM_SLASHER, "Slasher", Color( 255, 0, 0 ) )

	TEAM_LOBBY = 3
	team.SetUp( TEAM_LOBBY, "Lobby", Color( 230, 255, 230 ) )

	team.SetUp( TEAM_SPECTATOR, "Spectator", Color( 135, 206, 235 ) )

end

--[[function GM:PlayerSelectTeamSpawn(team, ply)
	
end]]

DoorSlamWhitelist = {
	"models/props_c17/door03_left.mdl",
	"models/props_doors/doormain_rural01_small.mdl",
	"models/props_doors/doormainmetal01.mdl",
	"models/props_c17/door01_left.mdl"
}

function CheckDoorWL(ent)
	allow = false
	for i = 1, #DoorSlamWhitelist do
		if ent:GetModel() == DoorSlamWhitelist[i] then
			allow = true
			break
		end
	end
	return allow
end

SCInfo = {}

SCInfo.RoundEnd = {

    {
        On = "The assignment was successful.",
        Off = "The assignment was unsuccessful." ,
        DB = "The assignment was only partially successful."
    },

    {
        FullTeam = "All of the dispatched SlashCo Workers were rescued.",
        NonFullTeam = "Not all of the dispatched SlashCo Workers could be rescued.",
        AlivePlayers = " were reported present on the rescue helicopter.",
        DeadPlayers = " could not make it out alive.",
        LeftBehindPlayers = " had to be left behind.",
        Fail = "The dispatched SlashCo Workers could not be rescued.",
        OnlyOneAlive = " was the only one to survive.",
    },

    {
        Loss =  " are now presumed either dead or missing in action.",
        LossOnlyOne =  " is now presumed either dead or missing in action.",
        LossComplete =  "The Dispatched SlashCo Workers are now presumed either dead or missing in action.",
        DBWin = " had to be rescued before the assignment could be completed."
    }

}

SCInfo.Offering = {

    {
        Name = "Exposure",
        Rarity = 1,
        Description = "Will make Gas Cans easier to find,\nBut\nYou will not find more than you need.",
        GasCanMod = 0
    },
        
    {
        Name = "Satiation",
        Rarity = 1,
        Description = "The Slasher will be a Demon,\nand its items will be scarce,\nBut\nThe items will have greater effect.",
        GasCanMod = 0
    },

    {
        Name = "Drainage",
        Rarity = 2,
        Description = "Gas cans will be plentiful,\nBut\nGenerators will leak fuel over time.",
        GasCanMod = 6
    },

    {
        Name = "Duality",
        Rarity = 3,
        Description = "Only one generator will need to be powered,\nBut\nYou will face two Slashers.",
        GasCanMod = 0
    },

    {
        Name = "Singularity",
        Rarity = 3,
        Description = "Gas Cans will be plentiful,\nBut\nThe Slasher will grow much more powerful.",
        GasCanMod = 6
    }

}

SCInfo.Main = {

    Base = "Welcome to the SlashCo Power Recovery Program.\n\nYour assignment is refuelling and activating two Generators present in an area called the Slasher Zone.\n\nYou will need to pour four cans of fuel and insert a car battery into each, however it might turn out not to be an easy task.\n\nAn evil entity known as a Slasher will be present in the zone with you. The only way you can successfully complete your \ntask is by knowing how to survive.\n\nYou will be dropped off by a helicopter, which will also pick you up after both of the generators have been activated.\n\nIf you ever find yourself left stranded without a team, the helicopter can come rescue you prematurely if you signal \nit with a Distress Beacon, one of which you will always be able to find within the Slasher Zone.\nRescue will come only if at least one generator has been activated.\n\nBefore you set off to the Slasher Zone, you can choose an Item in the lobby in exchange for Points you earn during rounds as Survivor.",
    SlasherBase = "As a Slasher, your goal is to kill all of the Survivors before they manage to escape.\n\nYou can track the progress of the Survivors' assignment with a bar which indicates the Game Progress.\n\nEach Slasher has unique abilities which can help achieve your goal in different ways, furthermore, Slashers are divided\ninto three different Classes, each of which has a different ability kind.\n\nCryptid:\nThe abilities of Cryptids are simple and easy to understand. They consist of relatively straightforward ways of\nhelping you kill Survivors.\n\nDemon:\nA Demon's abilities depend on the Items they have consumed, which will be spawned all around the map, and at times the\nGame Progress of the round, meaning that a Demon's goals is not just killing Survivors, but also finding and consuming\nItems to grow their power.\n\nUmbra:\nThe powers of Slashers of the Umbra class grow as the Game Progress increases, meaning they are weak at first, but the\ncloser the Survivors get to completing their assignment, their abilities strengthen.",

}

SCInfo.Survivor = [[As a Survivor, your objective is to fuel two Generators and escape by Helicopter.

A Generator requires up to 4 Fuel Cans and a Battery to be activated.

Survivors can use a variety of Items to help them.]]