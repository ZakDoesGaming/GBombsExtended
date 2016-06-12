AddCSLuaFile()

SWEP.HoldType = "shotgun"
SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.PrintName = "T Virus Launcher"
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
SWEP.Primary.Sound = "weapons/shotgun/shotgun_fire6.wav"
SWEP.Secondary.Sound = "weapons/shotgun/shotgun_fire7.wav"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1

SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Delay = 1.0

function SWEP:Initialize()
    util.PrecacheSound(self.Primary.Sound) 
    util.PrecacheSound(self.Secondary.Sound)
    self:SetWeaponHoldType( self.HoldType )
end

function SWEP:PrimaryAttack()
    self:SetNextPrimaryFire( CurTime() + self.Primary.Delay)
       if ( CLIENT ) then return end
       local ent = ents.Create ( "gb5_chemical_tvirus" )
       if ( !IsValid( ent ) ) then return end
       
       ent:SetPos( self.Owner:EyePos() + (self.Owner:GetAimVector() * 16) )
       ent:SetAngles ( self.Owner:EyeAngles() )
       ent:Spawn()
       self:ShootEffects()
       self:EmitSound(Sound(self.Primary.Sound)) 
       
       local phys = ent:GetPhysicsObject()
       if ( !IsValid( phys ) ) then ent:Remove() return end
       
       local velocity = self.Owner:GetAimVector()
       velocity = velocity * 50000
       phys:ApplyForceCenter( velocity )
end

function SWEP:SecondaryAttack()
    self:SetNextPrimaryFire( CurTime() + self.Primary.Delay)
       if ( CLIENT ) then return end
       local ent = ents.Create ( "gb5_chemical_tvirus_cure" )
       if ( !IsValid( ent ) ) then return end
       ent:SetPos( self.Owner:EyePos() + (self.Owner:GetAimVector() * 16) )
       ent:SetAngles ( self.Owner:EyeAngles() )
       ent:Spawn()
       self:ShootEffects()
       self:EmitSound(Sound(self.Secondary.Sound)) 
       
       local phys = ent:GetPhysicsObject()
       if ( !IsValid( phys ) ) then ent:Remove() return end
       
       local velocity = self.Owner:GetAimVector()
       velocity = velocity * 50000
       phys:ApplyForceCenter( velocity )
end
       