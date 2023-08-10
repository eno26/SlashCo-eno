ENT.Type = "point"

SlashCo = SlashCo or {}

function ENT:Initialize()
	--override me!
end

function ENT:KeyValue(key, value)
	if string.sub(key, 1, 2) == "On" then
		self:StoreOutput(key, value)
		return
	end
	local key1 = string.lower(key)
	if key1 == "generators_needed" then
		SetGlobal2Int("SlashCoGeneratorsNeeded", tonumber(value))
		return
	end
	if key1 == "generators_spawned" then
		SetGlobal2Int("SlashCoGeneratorsToSpawn", tonumber(value))
		return
	end
	if key1 == "gascans_needed" then
		SetGlobal2Int("SlashCoGasCansPerGenerator", tonumber(value))
		return
	end
	if key1 == "gascans_spawned" then
		SetGlobal2Int("SlashCoGasCansToSpawn", tonumber(value))
		return
	end
end

function ENT:AcceptInput(name, activator, _, value)
	if string.sub(name, 1, 2) == "On" then
		self:TriggerOutput(name, activator)
		return true
	end

	--do not let the entity change anything if the round already started
	if SlashCo and SlashCo.RoundStarted then
		return true
	end

	local name1 = string.lower(name)
	if name1 == "set_generators_needed" then
		SetGlobal2Int("SlashCoGeneratorsNeeded", tonumber(value))
		return true
	end
	if name1 == "set_generators_spawned" then
		SetGlobal2Int("SlashCoGeneratorsToSpawn", tonumber(value))
		return true
	end
	if name1 == "set_gascans_needed" then
		SetGlobal2Int("SlashCoGasCansPerGenerator", tonumber(value))
		return true
	end
	if name1 == "set_gascans_spawned" then
		SetGlobal2Int("SlashCoGasCansToSpawn", tonumber(value))
		return true
	end
end