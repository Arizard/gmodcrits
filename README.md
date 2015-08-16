#Fair & Balanced Critical Hits for Garry's Mod
This addon adds semi-random critical hits into garrysmod. 
Works for many gamemodes, already configured for sandbox and TTT.
If you've played TF2, you'll understand what this means.

#How does it work?
Each player has a unique critical hit chance. By default, this lies between 5% (minimum) and 15% (maximum). 
If a player deals some damage, their critical hit chance increases proportionally to how much damage they have dealt. 
In gamemodes such as TTT, if a player damages a teammate, their critical hit chance decreases.
This is how the critical hits can be random, but not *too* random. The system rewards players who do more damage.

#Configuration
Use these serverside convars:
<pre>

  crits_min_chance <0.0 -> 1.0>
  
  crits_max_chance <0.0 -> 1.0> ; Must be higher than crits_min_chance
  
  crits_enabled <0/1> ; Enables crits when set to 1. Is enabled by default.
  
  crits_multiplier <1.0 -> 5.0> ; The damage multiplier when a critical hit is dealt.
  
</pre>

To add a configuration for a custom gamemode, create a <code>gamemodename.lua</code> file in the <code>gmodcrits/lua/gmod_crits/gamemodes</code> directory.
Inside, you need to add your necessary hooks to modify the crit chance. 
The filename MUST match the gamemode name, e.g. <code>murder.lua</code> or <code>terrortown.lua</code>. 
Take a look at <code>terrortown.lua</code> here:
<pre>
  hook.Add("EntityTakeDamage", "GmodCritsTakeDamage", function( ent, dmginfo )
  
  	local att = dmginfo:GetAttacker()
  
  	if att:IsPlayer() and ent:IsPlayer() then
  		
  		if att:GetTraitor() ~= ent:GetTraitor() then -- "good" damage
  			att:ModCritChance( dmginfo:GetDamage() * 0.0002 )
  			-- ply:ModCritChance( amt ) adds amt onto the crit chance. 
  			-- It also makes sure that it's still within the min and max crit chances.
  		else -- "bad" damage
  			att:ModCritChance( dmginfo:GetDamage() * -0.0004 )
  		end
  		
  	end
  
  end)
</pre>

There is also an entity blacklist which is configurable through the use of two global functions: <code>CritGetBlackList( )</code> and <code>CritSetBlackList( TABLE blacklist )</code>. An example is shown below:
<pre>
  local blacklist = { "ttt_c4" } -- stop TTT C4 from being OP and critting everyone on the map
  CritSetBlackList( blacklist )
</pre>

# ![Thanks for reading, join my steam group by clicking this link!](http://steamcommunity.com/groups/vhs7)
