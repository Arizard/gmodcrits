hook.Add("EntityTakeDamage", "GmodCritsTakeDamage", function( ent, dmginfo )

	local att = dmginfo:GetAttacker()

	if att:IsPlayer() and ent:IsPlayer() then
		-- if we do 500 damage, we add 0.10 to the crit chance
		-- that's 50 per 0.01
		-- that's 5 per 0.001
		-- that's 1 per 0.0002
		att:ModCritChance( dmginfo:GetDamage() * 0.0002 )
	end

end)