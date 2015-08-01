
net.Receive("crit_sendcrit", function()
	local isAttacker = net.ReadBit()

	if isAttacker then
		surface.PlaySound("physics/metal/metal_sheet_impact_hard2.wav")
		--chat.AddText("You dealt a critical hit!")
	else
		--chat.AddText("You were critically hit!")
	end
end)

local crits_settings = {
	{"header","No settings here, asshole"},

	--{"number", "crit",0,12,"HUD Theme"},

	--{"boolean", "crit_sounds", "Critical hit sounds"}
}

local gmodcrits_turq = Color(150,0,0)

concommand.Add("crits_menu", function()

	local frame = vgui.Create("gmodcrits_arizard_v2_window")
	frame:SetSize(480,240)
	frame:Center()
	frame:MakePopup()
	frame:SetTitle("Clientside Crits Settings")

	frame:SetPrimaryColor( gmodcrits_turq )

	local controls = vgui.Create("DPanel", frame)
	controls:SetSize( frame:GetWide()-8, frame:GetTall()-44 )
	controls:SetPos( 4, 32 )

	function controls:Paint(w,h)
		surface.SetDrawColor( Color(255,255,255) )
		surface.DrawRect(0,0,w,h)
	end

	local scr = vgui.Create("DScrollPanel", controls)
	scr:SetSize( controls:GetWide()-16, controls:GetTall()-16 )
	scr:SetPos(8,8)

	local vbar = scr:GetVBar()
	vbar:SetWide(4)

	function vbar:Paint(w,h)
		surface.SetDrawColor(0,0,0,100) 
		surface.DrawRect(0,0,w,h)
	end
	function vbar.btnUp:Paint() end
	function vbar.btnDown:Paint() end
	function vbar.btnGrip:Paint(w, h)
		surface.SetDrawColor(0,0,0,200)
		surface.DrawRect(0,0,w,h)
	end

	local dlist = vgui.Create("DIconLayout", scr)
	dlist:SetSize( scr:GetSize() )
	dlist:SetPos(0,0)
	dlist:SetSpaceX(0)
	dlist:SetSpaceY(8)

	local lbl = vgui.Create("DLabel")
	lbl:SetFont("gmodcrits_arizard_v2_derma_Medium")
	lbl:SetTextColor(gmodcrits_turq)
	lbl:SetText("Local Crits Settings")
	lbl:SizeToContents()
	lbl:SetWide( dlist:GetWide() )
	dlist:Add(lbl)

	for k, v in pairs( crits_settings ) do

		local ty = v[1] -- convar type

		if ty == "header" then
			local pnl = vgui.Create("DPanel") -- spacer
			pnl:SetWide( dlist:GetWide() )
			pnl:SetTall( 24 )
			function pnl:Paint() end
			dlist:Add( pnl )

			local lbl = vgui.Create("DLabel")
			lbl:SetFont("gmodcrits_arizard_v2_derma_Small")
			lbl:SetTextColor(gmodcrits_turq)
			lbl:SetText(v[2])
			lbl:SizeToContents()
			lbl:SetWide( dlist:GetWide() )
			dlist:Add(lbl)
		elseif ty == "boolean" then
			local pnl = vgui.Create("DPanel") -- spacer
			pnl:SetWide( dlist:GetWide() )
			pnl:SetTall( 4 )
			function pnl:Paint() end
			dlist:Add( pnl )

			local lbl = vgui.Create("DLabel") -- label
			lbl:SetFont("gmodcrits_arizard_v2_derma_Tiny")
			lbl:SetTextColor( HexColor("#333") )
			lbl:SetText(v[3])
			lbl:SizeToContents()
			lbl:SetWide( dlist:GetWide() )
			dlist:Add(lbl)

			local check = vgui.Create("DCheckBoxLabel")
			check:SetValue( GetConVar(v[2]):GetInt() )
			check:SetText("Enabled")
			check:SetTextColor( HexColor("#333") )
			check:SizeToContents()
			check:SetConVar(v[2])
			dlist:Add( check )

		elseif ty == "number" then
			local pnl = vgui.Create("DPanel") -- spacer
			pnl:SetWide( dlist:GetWide() )
			pnl:SetTall( 4 )
			function pnl:Paint() end
			dlist:Add( pnl )

			local lbl = vgui.Create("DLabel") -- label
			lbl:SetFont("gmodcrits_arizard_v2_derma_Tiny")
			lbl:SetTextColor( HexColor("#333") )
			lbl:SetText(v[5])
			lbl:SizeToContents()
			lbl:SetWide( dlist:GetWide() )
			dlist:Add(lbl)

			-- slider
			local sl = vgui.Create("Slider")
			sl:SetMin( v[3] )
			sl:SetMax( v[4] )
			sl:SetWide(dlist:GetWide())
			sl:SetTall(12)
			sl:SetValue( GetConVar( v[2] ):GetFloat() )

			sl.convarname = v[2]

			function sl:OnValueChanged()
				RunConsoleCommand(self.convarname, self:GetValue())
			end

			dlist:Add(sl)	
		end

	end

end)