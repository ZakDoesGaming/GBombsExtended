AddCSLuaFile()

DEFINE_BASECLASS( "gb5_base_rocket_" )

ENT.Spawnable		            	 =  true         
ENT.AdminSpawnable		             =  true 

ENT.PrintName		                 =  "Ball-V2"
ENT.Author			                 =  "Zak Farmer"
ENT.Contact			                 =  ""
ENT.Category                         =  "GBombs Extended: Missiles"

ENT.Model                            =  "models/thedoctor/v2.mdl"
ENT.RocketTrail                      =  "v2_small_trail"
ENT.RocketBurnoutTrail               =  ""
ENT.Effect                           =  "fatman_main"
ENT.EffectAir                        =  "fatman_air"
ENT.EffectWater                      =  "water_huge" 
ENT.ExplosionSound                   =  "gbombs_5/explosions/heavy_bomb/ex1.mp3"        
ENT.StartSound                       =  "gbombs_5/launch/srb_launch.wav"          
ENT.ArmSound                         =  "npc/roller/mine/rmine_blip3.wav"            
ENT.ActivationSound                  =  "buttons/button14.wav"    
ENT.EngineSound                      =  "Motor_Small"

ENT.ShouldUnweld                     =  true          
ENT.ShouldIgnite                     =  true         
ENT.UseRandomSounds                  =  false         
ENT.SmartLaunch                      =  false
ENT.Timed                            =  false 

ENT.ExplosionDamage                  =  1
ENT.ExplosionRadius                  =  50000             
ENT.PhysForce                        =  0             
ENT.SpecialRadius                    =  50000            
ENT.MaxIgnitionTime                  =  2           
ENT.Life                             =  35            
ENT.MaxDelay                         =  0           
ENT.TraceLength                      =  600           
ENT.ImpactSpeed                      =  800         
ENT.Mass                             =  10000             
ENT.EnginePower                      =  200          
ENT.FuelBurnoutTime                  =  20          
ENT.IgnitionDelay                    =  3            
ENT.ArmDelay                         =  2
ENT.RotationalForce                  =  0                      
ENT.ForceOrientation                 =  "NONE"
ENT.Timer                            =  0
ENT.Shocktime                        = 3
ENT.GBOWNER                          =  nil             -- don't you fucking touch this.

function ENT:Initialize()
 if (SERVER) then
     self:SetModel(self.Model)  
     self:SetSubMaterial(0, "models/dog/eyeglass")
	 self:PhysicsInit( SOLID_VPHYSICS )
	 self:SetSolid( SOLID_VPHYSICS )
	 self:SetMoveType(MOVETYPE_VPHYSICS)
	 self:SetUseType( ONOFF_USE ) -- doesen't fucking work
	 local phys = self:GetPhysicsObject()
	 local skincount = self:SkinCount()
	 if (phys:IsValid()) then
		 phys:SetMass(self.Mass)
		 phys:Wake()
     end
	 if (skincount > 0) then
	     self:SetSkin(math.random(0,skincount))
	 end
	 self.Armed    = false
	 self.Exploded = false
	 self.Fired    = false
	 self.Burnt    = false
	 self.Ignition = false
	 self.Arming   = false
	 self.Power    = 0.8
	 if !(WireAddon == nil) then self.Inputs = Wire_CreateInputs(self, { "Arm", "Detonate", "Launch" }) end
	end
end

function ENT:ExploSound(pos)
	 local ent = ents.Create("gb5_shockwave_sound_lowsh")
	 ent:SetPos( pos ) 
	 ent:Spawn()
	 ent:Activate()
	 ent:SetVar("GBOWNER", self.GBOWNER)
	 ent:SetVar("MAX_RANGE",500000)
	 ent:SetVar("SHOCKWAVE_INCREMENT",20000)
	 ent:SetVar("DELAY",0.01)
	 ent:SetVar("SOUND", self.ExplosionSound)
	 ent:SetVar("Shocktime",4)
end

function ENT:Think()
     if(self.Burnt) then return end
     if(!self.Ignition) then return end -- if there wasn't ignition, we won't fly
	 if(self.Exploded) then return end -- if we exploded then what the fuck are we doing here
	 if(!self:IsValid()) then return end -- if we aren't good then something fucked up
	 if self.Power <= 1.5 then
		self.Power = self.Power + 0.01
	 elseif self.Power >=1.5 then
		self.Power = 1.5
	 end
	 local phys = self:GetPhysicsObject()  
	 local thrustpos = self:GetPos()
	 if(self.ForceOrientation == "RIGHT") then
	     phys:AddVelocity(self:GetRight() * self.EnginePower) -- Continuous engine impulse
	 elseif(self.ForceOrientation == "LEFT") then
	     phys:AddVelocity(self:GetRight() * -self.EnginePower) -- Continuous engine impulse
	 elseif(self.ForceOrientation == "UP") then
	     phys:AddVelocity(self:GetUp() * self.EnginePower) -- Continuous engine impulse
	 elseif(self.ForceOrientation == "DOWN") then 
	     phys:AddVelocity(self:GetUp() * -self.EnginePower) -- Continuous engine impulse
	 elseif(self.ForceOrientation == "INV") then
	     phys:AddVelocity(self:GetForward() * -self.EnginePower) -- Continuous engine impulse
	 else
		 local tickrate = 1 / engine.TickInterval()
		 
		 if tickrate >= 65 and tickrate <=67 then
			phys:AddVelocity(self:GetForward() * (12*self.Power)) -- Continuous engine impulse
		 else
			phys:AddVelocity(self:GetForward() * 2*(12*self.Power)) -- Continuous engine impulse
		 end
	 end
	 if (self.Armed) then
        phys:AddAngleVelocity(Vector(self.RotationalForce,0,0)) -- Rotational force
	 end
	 
	 self:NextThink(CurTime() + 0.01)
	 return true
end

function ENT:Launch()
     if(self.Exploded) then return end
	 if(self.Burned) then return end
	 --if(self.Armed) then return end
	 if(self.Fired) then return end
	 local phys = self:GetPhysicsObject()
	 if !phys:IsValid() then return end
	 
	 self.Fired = true
	 if(self.SmartLaunch) then
		 constraint.RemoveAll(self)
	 end
	 timer.Simple(0.05,function()
	     if not self:IsValid() then return end
	     if(phys:IsValid()) then
             phys:Wake()
		     phys:EnableMotion(true)
	     end
	 end)
	 timer.Simple(self.IgnitionDelay,function()
	     if not self:IsValid() then return end  -- Make a short ignition delay!

		 local phys = self:GetPhysicsObject()
		 self.Ignition = true
		 self:Arm()
		 local pos = self:GetPos()
		 sound.Play(self.StartSound, pos, 160, 130,1)
	     self:EmitSound(self.EngineSound)

		 ParticleEffectAttach(self.RocketTrail,PATTACH_ABSORIGIN_FOLLOW,self,1)
		 util.ScreenShake( self:GetPos(), 5555, 3555, 10, 500 )
		 util.ScreenShake( self:GetPos(), 5555, 555, 8, 500 )
		 util.ScreenShake( self:GetPos(), 5555, 555, 5, 500 )
		 if(self.FuelBurnoutTime != 0) then 
	         timer.Simple(self.FuelBurnoutTime,function()
		         if not self:IsValid() then return end 
		         self.Burnt = true
		         self:StopParticles()
		         self:StopSound(self.EngineSound)
	             ParticleEffectAttach(self.RocketBurnoutTrail,PATTACH_ABSORIGIN_FOLLOW,self,1)
             end)	 
		 end
     end)		 
end

function ENT:ExploSound(pos)
	 local ent = ents.Create("gb5_shockwave_sound_lowsh")
	 ent:SetPos( pos ) 
	 ent:Spawn()
	 ent:Activate()
	 ent:SetVar("GBOWNER", self.GBOWNER)
	 ent:SetVar("MAX_RANGE",500000)
	 ent:SetVar("SHOCKWAVE_INCREMENT",20000)
	 ent:SetVar("DELAY",0.01)
	 ent:SetVar("SOUND", self.ExplosionSound)
	 ent:SetVar("Shocktime",4)
end

function ENT:Explode()
     if !self.Exploded then return end
	 local pos = self:LocalToWorld(self:OBBCenter())
	 local owner = self.GBOWNER
   	 local ent = ents.Create("gb5_shockwave_ent")
	 ent:SetPos( pos ) 
	 ent:Spawn()
	 ent:Activate()
	 ent:SetVar("DEFAULT_PHYSFORCE", 50)
	 ent:SetVar("DEFAULT_PHYSFORCE_PLYAIR", 50)
	 ent:SetVar("DEFAULT_PHYSFORCE_PLYGROUND", 50)
	 ent:SetVar("GBOWNER", self.GBOWNER)
	 ent:SetVar("MAX_RANGE", 20)
	 ent:SetVar("SHOCKWAVE_INCREMENT",100)
	 ent:SetVar("DELAY",0.01)
	 ent.trace=self.TraceLength
	 ent.decal=self.Decal
        
     local ent = ents.Create("gb5_emitlight_nuke")
	 ent:SetPos( pos + Vector(0,0,1000) ) 
	 ent:Spawn()
	 ent:Activate()
	 ent.RGB_Variable = {["red"] = 255, ["green"] = 130, ["blue"] = 0}
	 ent.Life = 15
	 
	 local ent = ents.Create("gb5_shockwave_sound_lowsh")
	 ent:SetPos( pos ) 
	 ent:Spawn()
	 ent:Activate()
	 ent:SetVar("GBOWNER", self.GBOWNER)
	 ent:SetVar("MAX_RANGE",20)
	if GetConVar("gb5_sound_speed"):GetInt() == 0 then
		ent:SetVar("SHOCKWAVE_INCREMENT",200)
	elseif GetConVar("gb5_sound_speed"):GetInt()== 1 then
		ent:SetVar("SHOCKWAVE_INCREMENT",300)
	elseif GetConVar("gb5_sound_speed"):GetInt() == 2 then
		ent:SetVar("SHOCKWAVE_INCREMENT",400)
	elseif GetConVar("gb5_sound_speed"):GetInt() == -1 then
		ent:SetVar("SHOCKWAVE_INCREMENT",100)
	elseif GetConVar("gb5_sound_speed"):GetInt() == -2 then
		ent:SetVar("SHOCKWAVE_INCREMENT",50)
	else
		ent:SetVar("SHOCKWAVE_INCREMENT",200)
	end
	 ent:SetVar("DELAY",0.01)
	 ent:SetVar("SOUND", "gbombs_5/explosions/nuclear/tsar_in.mp3")
	 ent:SetVar("Shocktime", 1.2)
	 
	 timer.Simple(1, function()
		 local ent = ents.Create("gb5_shockwave_ent")
		 ent:SetPos( pos ) 
		 ent:Spawn()
		 ent:Activate()
		 ent:SetVar("DEFAULT_PHYSFORCE", 200)
		 ent:SetVar("DEFAULT_PHYSFORCE_PLYAIR", 100)
		 ent:SetVar("DEFAULT_PHYSFORCE_PLYGROUND", 100)
		 ent:SetVar("GBOWNER", owner)
		 ent:SetVar("MAX_RANGE", 1)
		 ent:SetVar("SHOCKWAVE_INCREMENT",100)
		 ent:SetVar("DELAY",0.01)
		 ent.trace=self.TraceLength
		 ent.decal=self.Decal
		 
		 local ent = ents.Create("gb5_shockwave_sound_lowsh")
		 ent:SetPos( pos ) 
		 ent:Spawn()
		 ent:Activate()
		 ent:SetVar("GBOWNER", self.GBOWNER)
		 ent:SetVar("MAX_RANGE",50000)
		if GetConVar("gb5_sound_speed"):GetInt() == 0 then
			ent:SetVar("SHOCKWAVE_INCREMENT",200)
		elseif GetConVar("gb5_sound_speed"):GetInt()== 1 then
			ent:SetVar("SHOCKWAVE_INCREMENT",300)
		elseif GetConVar("gb5_sound_speed"):GetInt() == 2 then
			ent:SetVar("SHOCKWAVE_INCREMENT",400)
		elseif GetConVar("gb5_sound_speed"):GetInt() == -1 then
			ent:SetVar("SHOCKWAVE_INCREMENT",100)
		elseif GetConVar("gb5_sound_speed"):GetInt() == -2 then
			ent:SetVar("SHOCKWAVE_INCREMENT",50)
		else
			ent:SetVar("SHOCKWAVE_INCREMENT",200)
		end
		 ent:SetVar("DELAY",0.01)
		 ent:SetVar("SOUND", "gbombs_5/explosions/heavy_bomb/ex1.mp3")
		 ent:SetVar("Shocktime", 3)
	 end)   
     local ballPos = pos
     for i=1,50,1 do
        ballPos.x = pos.x + math.random(1, 10)
        ballPos.y = pos.y + math.random(1, 10)
        ballPos.z = pos.z + math.random(1, 10)
        local ent = ents.Create("sent_ball")
        ent:SetPos( pos)
        ent:Spawn()
        ent:GetPhysicsObject():ApplyForceCenter( Vector(math.random(1, 50), math.random(1, 50), math.random(1, 50)))
     end
     if self.IsNBC then
	     local nbc = ents.Create(self.NBCEntity)
		 nbc:SetVar("GBOWNER",self.GBOWNER)
		 nbc:SetPos(self:GetPos())
		 nbc:Spawn()
		 nbc:Activate()
	 end
     self:Remove()
end

function ENT:SpawnFunction( ply, tr )
     if ( !tr.Hit ) then return end
	 self.GBOWNER = ply
     local ent = ents.Create( self.ClassName )
	 ent:SetPhysicsAttacker(ply)
     ent:SetPos( tr.HitPos + tr.HitNormal * 46 ) 
	 ent:SetAngles(Angle(-90,0,0))
     ent:Spawn()
     ent:Activate()

     return ent
end