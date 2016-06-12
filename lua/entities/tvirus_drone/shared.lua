ENT.Base = "dronesrewrite_base"
ENT.Type = "anim"
ENT.PrintName = "T-Virus Drone"
ENT.Spawnable = true
ENT.AdminSpawnable = true
ENT.Category = "GBombs Extended: Drones"

ENT.UNIT = "BMB"

ENT.Weight = 500

ENT.Model = "models/dronesrewrite/bomb/bomb.mdl"

ENT.HealthAmount = 145
ENT.DefaultHealth = 145

ENT.HUD_hudName = "Drones 1"
ENT.OverlayName = "Red"

ENT.FirstPersonCam_pos = Vector(23, 0, 7)
ENT.ThirdPersonCam_distance = 80
ENT.RenderCam = false

ENT.DoExplosionEffect = false
ENT.ExplosionForce = 0
ENT.ExplosionAngForce = 0

ENT.NoiseCoefficient = 0

ENT.HUD_shouldDrawWeps = false

ENT.Speed = 7500
ENT.UpSpeed = 38000
ENT.RotateSpeed = 5
ENT.AngOffset = 1.6
ENT.PitchOffset = 0.2
ENT.Alignment = 3

ENT.Fuel = 150
ENT.MaxFuel = 150
ENT.FuelReduction = 0.4

ENT.KeysFuncs = DRONES_REWRITE.DefaultKeys()

ENT.AllowYawRestrictions = true
ENT.YawMin = -50
ENT.YawMax = 50

ENT.UseFlashlight = false

ENT.AI_CustomEnemyChecker = function(drone, v)
	return drone:GetPos():Distance(v:GetPos()) < 150 and DRONES_REWRITE.AI.ShouldAttack(drone, v)
end

ENT.Sounds = {
	PropellerSound = {
		Name = "vehicles/tank_turret_loop1.wav",
		Pitch = 60,
		Level = 70
	},

	ExplosionSound = {
		Name = "gbombs_5/explosions/chemical/gasleak_long.mp3",
		Pitch = 100,
		Level = 90
	}
}

ENT.NoPropellers = true
ENT.Propellers = {
	Model = "models/props_junk/PopCan01a.mdl",
	Info = { Vector(0, 0, 0) }
}

ENT.Modules = DRONES_REWRITE.GetBaseModules()

ENT.Weapons = {
	["Virus"] = { Name = "Virus" }
}