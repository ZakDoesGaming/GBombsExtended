DRONES_REWRITE.Weapons["Ball"] = {
	Initialize = function(self)
		self:AddHook("DroneDestroyed", "ball_destr", function()
            pos = self:GetPos()
            local canisterPos = pos
            for i=1,50,1 do
                canisterPos.x = pos.x + math.random(1, 10)
                canisterPos.y = pos.y + math.random(1, 10)
                canisterPos.z = pos.z + math.random(1, 10)
                local ent = ents.Create("sent_ball")
                ent:SetPos(pos)
                ent:Spawn()
            end
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