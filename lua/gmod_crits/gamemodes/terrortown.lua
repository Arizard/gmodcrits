hook.Add("EntityTakeDamage", "GmodCritsTakeDamage", function( ent, dmginfo )

	local att = dmginfo:GetAttacker()

	if att:IsPlayer() and ent:IsPlayer() then
		
		if att:GetTraitor() ~= ent:GetTraitor() then -- "good" damage
			att:ModCritChance( dmginfo:GetDamage() * 0.0002 )
		else -- "bad" damage
			att:ModCritChance( dmginfo:GetDamage() * -0.0004 )
		end
	end

end)