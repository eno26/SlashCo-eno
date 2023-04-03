AddCSLuaFile()
AddCSLuaFile("baby.lua")
AddCSLuaFile("beacon.lua")
AddCSLuaFile("cookie.lua")
AddCSLuaFile("deathward.lua")
AddCSLuaFile("devildie.lua")
AddCSLuaFile("gascan.lua")
AddCSLuaFile("mayo.lua")
AddCSLuaFile("milkjug.lua")
AddCSLuaFile("soda.lua")
AddCSLuaFile("stepdecoy.lua")
AddCSLuaFile("deathward_used.lua")
AddCSLuaFile("battery.lua")
AddCSLuaFile("rock.lua")
AddCSLuaFile("pocketsand.lua")
AddCSLuaFile("brick.lua")
AddCSLuaFile("effect/invisibility.lua")
AddCSLuaFile("effect/fuelspeed.lua")
AddCSLuaFile("effect/slowness.lua")
AddCSLuaFile("effect/speed.lua")
AddCSLuaFile("items_meta.lua")


SlashCoItems = SlashCoItems or {}
SlashCoEffects = SlashCoEffects or {}

include("baby.lua")
include("beacon.lua")
include("cookie.lua")
include("deathward.lua")
include("devildie.lua")
include("gascan.lua")
include("mayo.lua")
include("milkjug.lua")
include("soda.lua")
include("stepdecoy.lua")
include("deathward_used.lua")
include("battery.lua")
include("rock.lua")
include("pocketsand.lua")
include("brick.lua")
include("effect/invisibility.lua")
include("effect/fuelspeed.lua")
include("effect/slowness.lua")
include("effect/speed.lua")
include("items_meta.lua")

local PLAYER = FindMetaTable("Player")

function PLAYER:AddEffect(value, duration)
    if not self:EffectFunction("OnRemoved") then
        self:EffectFunction("OnExpired")
    end
    self:SetNWString("itemEffect", value)
    self:EffectFunction("OnApplied")
    timer.Create("itemEffectExpire_"..self:UserID(), duration, 1, function()
        if not IsValid(self) then
            return
        end
        self:EmitSound("slashco/survivor/effectexpire_breath.mp3")
        self:EffectFunction("OnExpired")
        self:SetNWString("itemEffect", "none")
    end)
end

function PLAYER:EffectFunction(value, ...)
    local effect = self:GetNWString("itemEffect", "none")
    if SlashCoEffects[effect] and SlashCoEffects[effect][value] then
        return SlashCoEffects[effect][value](self, ...)
    end
end

function PLAYER:ClearEffect()
    if not self:EffectFunction("OnRemoved") then
        self:EffectFunction("OnExpired")
    end
    self:EmitSound("slashco/survivor/effectexpire_breath.mp3")
    self:SetNWString("itemEffect", "none")
    timer.Remove("itemEffectExpire_"..self:UserID())
end

--this doesn't include a team check because we assume that it's in a survivor-only context
function PLAYER:ItemValue(value, fallback, isSecondary)
    local effect = self:GetNWString("itemEffect", "none")
    if SlashCoEffects[effect] and SlashCoEffects[effect][value] then
        return SlashCoEffects[effect][value]
    end

    local slot = isSecondary and "item2" or "item"
    local item = self:GetNWString(slot, "none")
    if SlashCoItems[item] and SlashCoItems[item][value] then
        return SlashCoItems[item][value]
    end

    return fallback
end

function PLAYER:ItemValue2(value, fallback, noEffect)
    local item
    if not noEffect then
        item = ply:GetNWString("itemEffect", "none")
        if SlashCoItems[item] and SlashCoItems[item][value] then
            return SlashCoItems[item][value]
        end
    end

    item = ply:GetNWString("item2", "none")
    if item == "none" then
        item = ply:GetNWString("item", "none")
    end
    if SlashCoItems[item] and SlashCoItems[item][value] then
        return SlashCoItems[item][value]
    end

    return fallback
end

function PLAYER:ItemFunction(value, ...)
    return self:ItemFunctionInternal(value, "item", ...)
end

function PLAYER:ItemFunctionOrElse(value, ...)
    local val = self:ItemFunctionInternal(value, "item")
    if val then
        return val
    end
    return ...
end

function PLAYER:SecondaryItemFunction(value, ...)
    return self:ItemFunctionInternal(value, "item2", ...)
end

function PLAYER:SecondaryItemFunctionOrElse(value, ...)
    local val = self:ItemFunctionInternal(value, "item2")
    if val then
        return val
    end
    return ...
end

function PLAYER:ItemFunctionInternal(value, slot, ...)
    local effect = self:GetNWString("itemEffect", "none")
    if SlashCoEffects[effect] and SlashCoEffects[effect][value] then
        return SlashCoEffects[effect][value](self, ...)
    end

    local item = self:GetNWString(slot, "none")
    if SlashCoItems[item] and SlashCoItems[item][value] then
        return SlashCoItems[item][value](self, ...)
    end
end

function PLAYER:ItemFunction2(value, item, ...)
    if SlashCoItems[item] and SlashCoItems[item][value] then
        return SlashCoItems[item][value](self,...)
    end
end

if CLIENT then
    return
end

local spawnableItems = {}
for k, v in pairs(SlashCoItems) do
    if v.ReplacesWorldProps then
        spawnableItems[v.Model] = k
    end
end

hook.Add("InitPostEntity", function()
    for _, v in ipairs(ents.FindByClass("prop_physics")) do
        local item = spawnableItems[v:GetModel()]
        if item then
            local pos = v:GetPos()
            local ang = v:GetAngles()
            v:Remove()
            local droppedItem = SlashCo.CreateItem(SlashCoItems[item].EntClass, pos, ang)
            SlashCo.CurRound.Items[droppedItem] = true
            Entity(droppedItem):SetCollisionGroup(COLLISION_GROUP_NONE)
        end
    end
end)

--[[ all values for functions:
local SlashCoItems = SlashCoItems

SlashCoItems.NameMePlease = {}
SlashCoItems.NameMePlease.IsSecondary = false --optional, to let gascans and batteries not take up an item slot
SlashCoItems.NameMePlease.Model = ""
SlashCoItems.NameMePlease.Name = ""
SlashCoItems.NameMePlease.Icon = ""
SlashCoItems.NameMePlease.Price = 0 --don't include to remove from shop
SlashCoItems.NameMePlease.Description = "" --optional if price isn't included
SlashCoItems.NameMePlease.CamPos = Vector(0,0,0) --optional if price isn't included
SlashCoItems.NameMePlease.MaxAllowed = function() --optional, return the number of allowed items (runs clientside; don't use SlashCo)
    return 1
end
SlashCoItems.NameMePlease.DisplayColor = function(ply) --optional, color to display on the background of the name on player's hud (runs clientside; don't use SlashCo)
    return 0, 0, 128, 255
end
SlashCoItems.NameMePlease.OnUse = function(ply) --optional, when pressing r, return true to disable removing the item
end
SlashCoItems.NameMePlease.OnDrop = function(ply) --optional, when pressing q
end
SlashCoItems.NameMePlease.OnDie = function(ply) --optional, on death (return true to disable ticking down a life)
end
SlashCoItems.NameMePlease.OnPickUp = function(ply) --optional, when received
end
SlashCoItems.NameMePlease.OnBuy = function(plyid) --optional, when buying from lobby store
end
SlashCoItems.NameMePlease.OnSwitchFrom = function(ply) --optional, when item is removed without dropping (NOT called when item is dropped)
end
SlashCoItems.NameMePlease.EquipSound = function() --optional, string return of sound to play when equipping the item
end
SlashCoItems.NameMePlease.ViewModel = { --optional (i guess), use the SWEP construction kit on the workshop to help set this up
    model = "",
    pos = Vector(64, 0, -6),
    angle = Angle(45, -70, -120),
    size = Vector(0.5, 0.5, 0.5),
    color = color_white,
    surpresslightning = false, --this name is stupid but that's what the construction kit outputs so we're keeping it
    material = "",
    skin = 0,
    bodygroup = {}
}
--^IMPORTANT: The item display will ALWAYS place the item on "ValveBiped.Bip01_Spine4", with viewmodel set to "models/weapons/c_arms.mdl"
SlashCoItems.NameMePlease.WorldModel = {} --optional, similar to above but with choice of bone and holdtype
]]