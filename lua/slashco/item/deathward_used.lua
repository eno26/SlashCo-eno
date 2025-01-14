local ITEM = {}

ITEM.Model = "models/slashco/items/deathward.mdl"
ITEM.Name = "Deathward"
ITEM.Icon = "slashco/ui/icons/items/item_2_99"
ITEM.Description = "You broke it!"
ITEM.CamPos = Vector(40,0,15)
ITEM.IsSpawnable = false
ITEM.DisplayColor = function()
    return 128, 0, 0, 255
end
ITEM.ViewModel = {
    model = "models/slashco/items/deathward.mdl",
    pos = Vector(64, 0, -6),
    angle = Angle(45, -70, -120),
    size = Vector(0.5, 0.5, 0.5),
    color = color_white,
    surpresslightning = false,
    material = "",
    skin = 0,
    bodygroup = {[0] = 1}
}
ITEM.WorldModelHolstered = {
    model = "models/slashco/items/deathward.mdl",
    bone = "ValveBiped.Bip01_R_Hand",
    pos = Vector(3, 0, 0),
    angle = Angle(10, -20, -90),
    size = Vector(1, 1, 1),
    color = color_white,
    surpresslightning = false,
    material = "",
    skin = 0,
    bodygroup = {[0] = 1}
}
ITEM.WorldModel = {
    holdtype = "normal",
    model = "models/slashco/items/deathward.mdl",
    bone = "ValveBiped.Bip01_R_Hand",
    pos = Vector(3, 0, 0),
    angle = Angle(10, -20, -90),
    size = Vector(1, 1, 1),
    color = color_white,
    surpresslightning = false,
    material = "",
    skin = 0,
    bodygroup = {[0] = 1}
}

SlashCo.RegisterItem(ITEM, "DeathWardUsed")