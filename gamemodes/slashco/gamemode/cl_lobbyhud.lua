include( "ui/fonts.lua" )

net.Receive( "mantislashcoLobbyTimerTime", function( len, ply )
	TimeLeft = net.ReadUInt(6)
end)

net.Receive( "mantislashcoGiveLobbyStatus", function( len, ply )
	StateOfLobby = net.ReadUInt(3)	
end)

net.Receive( "mantislashcoGiveLobbyInfo", function( len, ply )
	LobbyInfoTable = net.ReadTable()
end)

hook.Add("HUDPaint", "LobbyInfoText", function()

	net.Receive( "mantislashcoGiveMasterDatabase", function( len, ply )
		local t = net.ReadTable()
		if t[1].PlayerID ~= LocalPlayer():SteamID64() then return end
		data_load = t
	end)

	if game.GetMap() ~= "sc_lobby" then return end

	if stop_lobbymusic ~= true and (lobbymusic_antispam == nil or lobbymusic_antispam ~= true) then
		lobby_music = CreateSound(LocalPlayer(), "slashco/music/slashco_lobby.wav")
		lobby_music:Play()
		lobbymusic_antispam = true 
	end

	if stop_lobbymusic then lobby_music:Stop() end

	local point_count = 0
	local srvwin_count = 0
	local slswin_count = 0

	if data_load ~= nil and data_load ~= false then

		point_count = data_load[1].Points
		srvwin_count = data_load[1].SurvivorRoundsWon
		slswin_count = data_load[1].SlasherRoundsWon

	end

	local scrW, scrH = ScrW(), ScrH()

	draw.SimpleText( "You have "..point_count.." Points.", "LobbyFont1", ScrW() * 0.025, (ScrH() * 0.05), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
	draw.SimpleText( "You have won "..srvwin_count.." Rounds as SURVIVOR.", "LobbyFont1", ScrW() * 0.025, (ScrH() * 0.08), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
	draw.SimpleText( "You have won "..slswin_count.." Rounds as SLASHER.", "LobbyFont1", ScrW() * 0.025, (ScrH() * 0.11), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )

	if StateOfLobby == nil or StateOfLobby < 1 then 
		draw.SimpleText( " \" , \" to switch between player / spectator", "LobbyFont1", scrW * 0.975, (scrH * 0.93), Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP ) 
	end

	if LocalPlayer():Team() == TEAM_LOBBY then

		draw.SimpleText( "R to choose Playermodel", "LobbyFont1", scrW * 0.975, (scrH * 0.9), Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP ) 

	end

if StateOfLobby ~= nil and StateOfLobby < 1 then --DISPLAY THE HUD BELOW ONLY IN THE LOBBY

	local Tablet = Material("slashco/ui/lobby_backdrop")
	local ReadyCheck = Material("slashco/ui/lobby_ready")
	local UnReadyCheck = Material("slashco/ui/lobby_unready")
	
	clientname = LocalPlayer():GetName()

	local Lobby_Players = {}

	local isClientinLobby = false

	for i = 1, #LobbyInfoTable do

		if not IsValid(player.GetBySteamID64( LobbyInfoTable[i].steamid )) then return end

		if not table.HasValue(Lobby_Players, {ID = LobbyInfoTable[i].steamid}) then 
			table.insert(Lobby_Players, { ID = LobbyInfoTable[i].steamid, Name = player.GetBySteamID64( LobbyInfoTable[i].steamid ):GetName(), Ready = LobbyInfoTable[i].readyState })
		end

		if Lobby_Players[i].Name == clientname then			
			clientReadiness = LobbyInfoTable[i].readyState
			isClientinLobby = true
		end

	end
	
	if isClientinLobby then

		surface.SetDrawColor(255,255,255,255)	

		--surface.SetMaterial(Tablet)
		--surface.DrawTexturedRect(-ScrW()/15, ScrH()/50, ScrW()/2.5, ScrW()/2.5)
	
		draw.SimpleText( "Press F1 to ready as Survivor.", "LobbyFont1", scrW * 0.975, (scrH * 0.5)+300, Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP )
	
		draw.SimpleText( "Press F2 to ready as Slasher.", "LobbyFont1", scrW * 0.975, (scrH * 0.5)+350, Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP )
	
		if TimeLeft ~= nil and TimeLeft > 0 and TimeLeft < 61 then
			draw.SimpleText( "Starting in: "..tostring( TimeLeft ).." seconds. . .", "LobbyFont2", scrW * 0.5, (scrH * 0.65), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
		end

		local mul_y = 1
		if longest_name == nil then longest_name = 0 end
		if plynum == nil or plynum ~= #Lobby_Players then
			longest_name = 0
			plynum = #Lobby_Players 
		end

		draw.SimpleText( plynum.." / 5", "LobbyFont1", scrW * 0.018, (scrH * 0.22), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )

		for i = 1, #Lobby_Players do

			local pos_y = 0.27
			local x_pos = scrW * 0.025
			local iconsize = ScrW()/45

			surface.SetDrawColor( 0, 0, 0 )
			surface.DrawRect(scrW * 0.018, ((scrH) * (pos_y * mul_y)) - 18,(longest_name) + 65, 60 )
			surface.SetDrawColor( 50, 50, 50 )
			surface.DrawOutlinedRect(scrW * 0.018, ((scrH) * (pos_y * mul_y)) - 18, longest_name + 65, 60, 3 )

			if string.len(Lobby_Players[i].Name)*15 > longest_name then 
				longest_name = string.len(Lobby_Players[i].Name)*15 
			end

			draw.SimpleText( Lobby_Players[i].Name, "PlayersFont", scrW * 0.025, (scrH * (pos_y * mul_y)), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
			
			local icon_pos_x = x_pos + longest_name
			local icon_pos_y = (scrH * (pos_y * mul_y)) - 8

			surface.SetDrawColor(255,255,255,255)
			if Lobby_Players[i].Ready > 0 then
				surface.SetMaterial(ReadyCheck)
			else
				surface.SetMaterial(UnReadyCheck)
			end

			surface.DrawTexturedRect(icon_pos_x, icon_pos_y, iconsize, iconsize)

			mul_y = mul_y + 0.25

		end

	
	end
	
	if clientReadiness ~= nil then
		
		if clientReadiness < 1 then	
			draw.SimpleText( "You are not Ready.", "LobbyFont1", scrW * 0.025, scrH * 0.8, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )	
		elseif clientReadiness == 1 then	
			draw.SimpleText( "You are Ready as SURVIVOR.", "LobbyFont1", scrW * 0.025, scrH * 0.8, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )	
		elseif clientReadiness == 2 then	
			draw.SimpleText( "You are Ready as SLASHER.", "LobbyFont1", scrW * 0.025, scrH * 0.8, Color( 255, 50, 50, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
		end
	
	end

end

end)