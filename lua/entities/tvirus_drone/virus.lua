DRONES_REWRITE.Weapons["Virus"] = {
	Initialize = function(self)
		self:AddHook("DroneDestroyed", "virus_destr", function()
            local ent = ents.Create("gb5_chemical_tvirus")
            ent:SetPos( self:GetPos() ) 
            ent:Spawn()
            ent:Activate()
            ent:Explode()
			self:Remove()
		end)

		return DRONES_REWRITE.Weapons["Template"].InitializeNoDraw(self)
	end,

	Think = function(self, gun)
		DRONES_REWRITE.Weapons["Template"].Think(self, gun)
	end,
	
	Attack = function(self, gun)
		self:Destroy()
	end
}