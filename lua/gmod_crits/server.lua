-- some convars
local defaultFlags = FCVAR_SERVER_CAN_EXECUTE + FCVAR_REPLICATED + FCVAR_NOTIFY
CreateConVar("crits_min_chance", "0.05", defaultFlags, "Minimum crit chance")
CreateConVar("crits_max_chance", "0.15", defaultFlags, "Maximum crit chance")
CreateConVar("crits_enabled", "1", defaultFlags, "1 = enable, 0 = disable")
CreateConVar("crits_multiplier", "3", defaultFlags, "Damage multiplier for a critical hit" )

local PLAYER = FindMetaTable("Player")

function PLAYER:SetCritChance( amt )
	--amt = math.Clamp( amt, GetConVarNumber( "crits_min_chance" ), GetConVarNumber( "crits_max_chance" ) )
	self.CritChance = amt
end
function PLAYER:ModCritChance( amt )
	local amt = math.Clamp( self:GetCritChance() + amt, GetConVarNumber( "crits_min_chance" ), GetConVarNumber( "crits_max_chance" ) )
	self:SetCritChance( amt )
end
function PLAYER:GetCritChance( )
	--if true then return 1 end
	self.CritChance = self.CritChance or GetConVarNumber("crits_min_chance")
	--self:SetCritChance( math.Clamp( self.CritChance, GetConVarNumber( "crits_min_chance" ), GetConVarNumber( "crits_max_chance" ) ) )
	return self.CritChance
end

local function CritShouldCrit( ply )

	--ply:ChatPrint( tostring( ply:GetCritChance() ) )

	local r = math.random( 10000 )
	if r < ( 10000 * ply:GetCritChance() ) then
		return true
	else
		return false
	end
end

util.AddNetworkString("crit_sendcrit")

local function CritDoCrit( attacker, victim, effectpos )
	net.Start("crit_sendcrit")
	net.WriteBit( false ) -- true for attacker, false for victim
	net.Send( victim )

	net.Start("crit_sendcrit")
	net.WriteBit( true ) -- true for attacker, false for victim
	net.Send( attacker )

	-- emit the crit sound on the victim
	victim:EmitSound("physics/metal/metal_sheet_impact_hard2.wav", 256, 100 + math.random(-10,10), 1)

	-- effect
	local ed = EffectData()
	ed:SetOrigin( effectpos )
	ed:SetAngles( -attacker:EyeAngles() )
	ed:SetNormal( (-attacker:EyeAngles()):Forward() )
	util.Effect( "ManhackSparks", ed )

	attacker:SetCritChance( GetConVarNumber("crits_min_chance") )

end

local function CritEntityTakeDamage( ent, dmginfo )

	if dmginfo:GetAttacker():IsPlayer() then
		if ent:IsPlayer() then

			local shouldCrit = CritShouldCrit( dmginfo:GetAttacker() )
			if shouldCrit then
				dmginfo:ScaleDamage( GetConVarNumber( "crits_multiplier" ) ) 
				
				CritDoCrit( dmginfo:GetAttacker(), ent, dmginfo:GetDamagePosition() )
			end

			-- tttfix
			if dmginfo:GetDamage() == 0 then
				dmginfo:GetAttacker():SetCritChance(1)
				return	
			end

			--dmginfo:GetAttacker():ChatPrint( tostring(dmginfo:GetDamage()) .." damage dealt." )

		end
	end

end
hook.Add("EntityTakeDamage", "CritEntityTakeDamage", CritEntityTakeDamage)

