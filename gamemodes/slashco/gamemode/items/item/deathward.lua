local SlashCoItems = SlashCoItems

SlashCoItems.DeathWard = SlashCoItems.DeathWard or {}
SlashCoItems.DeathWard.Model = "models/slashco/items/deathward.mdl"
SlashCoItems.DeathWard.EntClass = "sc_deathward"
SlashCoItems.DeathWard.Name = "Deathward"
SlashCoItems.DeathWard.Icon = "slashco/ui/icons/items/item_2"
SlashCoItems.DeathWard.Price = 50
SlashCoItems.DeathWard.Description = "Survive death once, but become unable to hold any other items when triggered. Occasionally receive minor healing while holding."
SlashCoItems.DeathWard.CamPos = Vector(40,0,15)
SlashCoItems.DeathWard.MaxAllowed = function()
    return 2
end
SlashCoItems.DeathWard.IsSpawnable = true
SlashCoItems.DeathWard.OnDrop = function(ply)
    SlashCoItems.DeathWard.OnSwitchFrom(ply)
    local droppeditem = SlashCo.CreateItem(SlashCoItems.DeathWard.EntClass, ply:LocalToWorld(Vector(0, 0, 60)), ply:LocalToWorldAngles(Angle(0, 0, 0)))
    Entity(droppeditem):GetPhysicsObject():SetVelocity(ply:GetAimVector() * 250)
    SlashCo.CurRound.Items[droppeditem] = true
end
SlashCoItems.DeathWard.OnDie = function(ply)
    ply:EmitSound( "slashco/survivor/deathward.mp3")
    ply:EmitSound( "slashco/survivor/deathward_break"..math.random(1,2)..".mp3")

    --SlashCo.RespawnPlayer(ply)
    SlashCo.ChangeSurvivorItem(ply, "DeathWardUsed")

    return true
end
SlashCoItems.DeathWard.OnSwitchFrom = function(ply)
    timer.Remove("deathWardDamage_"..ply:UserID())
end
SlashCoItems.DeathWard.OnPickUp = function(ply)
    if game.GetMap() == "sc_lobby" then
        return
    end

    timer.Create("deathWardDamage_"..ply:UserID(), 45, 0, function()
        local hp = ply:Health()
        if hp >= 100 then
            return
        end
        ply:SetHealth(hp+1)
    end)
end
SlashCoItems.DeathWard.ViewModel = {
    model = "models/slashco/items/deathward.mdl",
    pos = Vector(64, 0, -6),
    angle = Angle(45, -70, -120),
    size = Vector(0.5, 0.5, 0.5),
    color = color_white,
    surpresslightning = false,
    material = "",
    skin = 0,
    bodygroup = {[0] = 0}
}
SlashCoItems.DeathWard.WorldModelHolstered = {
    model = "models/slashco/items/deathward.mdl",
    bone = "ValveBiped.Bip01_Pelvis",
    pos = Vector(5, 2, 5),
    angle = Angle(110, -80, 0),
    size = Vector(1, 1, 1),
    color = color_white,
    surpresslightning = false,
    material = "",
    skin = 0,
    bodygroup = {[0] = 0}
}
SlashCoItems.DeathWard.WorldModel = {
    holdtype = "slam",
    model = "models/slashco/items/deathward.mdl",
    bone = "ValveBiped.Bip01_R_Hand",
    pos = Vector(4, 1, -2),
    angle = Angle(10, -20, 200),
    size = Vector(1, 1, 1),
    color = color_white,
    surpresslightning = false,
    material = "",
    skin = 0,
    bodygroup = {[0] = 0}
}