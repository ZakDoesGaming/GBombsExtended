AddCSLuaFile()

SWEP.HoldType = "shotgun"
SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.PrintName = "Napalm Shotgun"
SWEP.Author = "Zak Farmer"
SWEP.Category = "GBombs Extended"

SWEP.Slot = 1
SWEP.SlotPos = 2
SWEP.DrawAmmo = true
SWEP.DrawCrosshair = true

SWEP.UseHands = true
SWEP.ViewModelFlip = false
SWEP.ViewModelFOV = 54
SWEP.ViewModel = "models/weapons/v_shotgun.mdl"
SWEP.WorldModel = "models/weapons/v_shotgun.mdl"
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Automatic = false
SWEP.Primary.Ammo = "none"
SWEP.Primary.Delay = 1.0
SWEP.Primary.Sound = "weapons/shotgun/shotgun_fire7.wav"

function SWEP:Initialize()
    util.PrecacheSound(self.Primary.Sound) 
    self:SetWeaponHoldType( self.HoldType )
end

function SWEP:PrimaryAttack()
    self:SetNextPrimaryFire( CurTime() + self.Primary.Delay)
       if ( CLIENT ) then return end
       local ent = ents.Create ( "gb5_chemical_napalm" )
       local pos = self.Owner:GetEyeTrace().HitPos
       if ( !IsValid( ent ) ) then return end
       ent:SetPos(pos)
       ent:Spawn()
       ent:Explode()
       self:ShootEffects()
       self:EmitSound(Sound(self.Primary.Sound)) 
end
       