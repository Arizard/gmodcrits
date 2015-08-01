CRITS = true -- in case we want other addons to be able to check for this addon


if SERVER then

	include( "gmod_crits/server.lua" )

	AddCSLuaFile( "gmod_crits/arizard_derma_v2.lua" )
	AddCSLuaFile( "gmod_crits/client.lua" )

	local gmode = engine.ActiveGamemode()

	include("gmod_crits/gamemodes/"..gmode..".lua")

else

	include( "gmod_crits/arizard_derma_v2.lua" )
	include( "gmod_crits/client.lua" )

end