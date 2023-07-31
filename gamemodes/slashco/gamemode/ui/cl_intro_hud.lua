if true then
	return
end
--deprecated file, safe to delete


net.Receive( "mantislashcoGameIntro", function( _, _ )
	local introtable = net.ReadTable()

	stop_lobbymusic = true

	intro_map = introtable.map

	if introtable.diff == 0 then
		intro_diff = SlashCoLanguage("Easy")
	elseif introtable.diff == 1 then
		intro_diff = SlashCoLanguage("Novice")
	elseif introtable.diff == 2 then
		intro_diff = SlashCoLanguage("Intermediate")
	elseif introtable.diff == 3 then
		intro_diff = SlashCoLanguage("Hard")
	end

	if introtable.s_class == 0 then
		intro_class = SlashCoLanguage("Unknown")
	elseif introtable.s_class == 1 then
		intro_class = SlashCoLanguage("Cryptid")
	elseif introtable.s_class == 2 then
		intro_class = SlashCoLanguage("Demon")
	elseif introtable.s_class == 3 then
		intro_class = SlashCoLanguage("Umbra")
	end

	if introtable.s_danger == 0 then
		intro_danger = SlashCoLanguage("Unknown")
	elseif introtable.s_danger == 1 then
		intro_danger = SlashCoLanguage("Moderate")
	elseif introtable.s_danger == 2 then
		intro_danger = SlashCoLanguage("Considerable")
	elseif introtable.s_danger == 3 then
		intro_danger = SlashCoLanguage("Devastating")
	end

	intro_name = introtable.s_name
	intro_offer = introtable.offer

	if intromusic_antispam == nil or intromusic_antispam ~= true then
		surface.PlaySound( "slashco/music/slashco_intro.mp3") 
		intromusic_antispam = true 
	end

	show_intro_screen = true

	LobbySlasherInfo = nil

end)

hook.Add("HUDPaint", "RoundIntroHUD", function()

	--local ply = LocalPlayer()

	--Intro screen

	if show_intro_screen ~= true then return end

	--local tick = tick
	if tick == nil then tick = 0 end
	tick = tick + 0.5

	local map = intro_map
	--local difficulty = intro_diff
	local name = SlashCoLanguage(intro_name)
	local class = SlashCoLanguage(intro_class)
	local danger = SlashCoLanguage(intro_danger)
	local offering = intro_offer

	local black = Material("models/slashco/slashers/trollge/body")

	surface.SetDrawColor(0,0,0,tick)
	surface.SetMaterial(black)
	surface.DrawTexturedRect(0, 0, ScrW(), ScrH())

	draw.SimpleText( SlashCoLanguage("cur_assignment"), "IntroFont", ScrW() * 0.5, (ScrH() * 0.15), Color( 255, 255, 255, tick-255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )

	draw.SimpleText( map, "IntroFont", ScrW() * 0.5, (ScrH() * 0.24), Color( 255, 255, 255, tick-(255*2) ), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )

	draw.SimpleText( SlashCoLanguage("Difficulty")..": "..intro_diff, "IntroFont", ScrW() * 0.5, (ScrH() * 0.35), Color( 255, 255, 255, tick-(255*3) ), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )

	draw.SimpleText( SlashCoLanguage("slasher_assess"), "IntroFont", ScrW() * 0.5, (ScrH() * 0.52), Color( 255, 255, 255, tick-(255*4) ), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )

	draw.SimpleText( SlashCoLanguage("Name") .. ": "..name, "IntroFont", ScrW() * 0.5, (ScrH() * 0.65), Color( 255, 255, 255, tick-(255*5) ), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )

	draw.SimpleText( SlashCoLanguage("Class") .. ": "..class, "IntroFont", ScrW() * 0.5, (ScrH() * 0.72), Color( 255, 255, 255, tick-(255*6) ), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )

	draw.SimpleText( SlashCoLanguage("DangerLevel") .. ": "..danger, "IntroFont", ScrW() * 0.5, (ScrH() * 0.78), Color( 255, 255, 255, tick-(255*7) ), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )

	if offering ~= "Regular" then
		draw.SimpleText( GetOfferingName(offering), "IntroFont", ScrW() * 0.5, (ScrH() * 0.89), Color( 255, 255, 255, tick-(255*8) ), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
	end
end)