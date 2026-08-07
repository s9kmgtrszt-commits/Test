-- Поместите этот скрипт внутрь Part (например, плиты-ловушки) в Roblox Studio
local pad = script.Parent
local flingPower = 100 -- Сила отбрасывания вверх и в сторону
local cooldown = 1 -- Задержка в секундах, чтобы не спамить импульсом
local activePlayers = {}

local function onTouch(otherPart)
	local character = otherPart.Parent
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	local rootPart = character:FindFirstChild("HumanoidRootPart")
	
	-- Проверяем, что это живой игрок и он еще не находится в режиме перезарядки
	if humanoid and rootPart and not activePlayers[character] then
		activePlayers[character] = true
		
		-- Создаем современный физический контроллер силы Attachment и LinearVelocity
		local attachment = Instance.new("Attachment")
		attachment.Parent = rootPart
		
		local linearVelocity = Instance.new("LinearVelocity")
		linearVelocity.MaxForce = math.huge -- Позволяет преодолеть вес персонажа
		
		-- Задаем направление вектора (немного вверх и назад от блока)
		local direction = (rootPart.Position - pad.Position).Unit
		linearVelocity.VectorVelocity = (direction + Vector3.new(0, 1, 0)).Unit * flingPower
		
		linearVelocity.Attachment0 = attachment
		linearVelocity.Parent = rootPart
		
		-- Временное переключение гуманоида в состояние физического тела, чтобы его подбросило
		humanoid:ChangeState(Enum.HumanoidStateType.Physics)
		
		-- Очищаем физические силы через 0.3 секунды, чтобы игрок снова восстановил управление
		task.delay(0.3, function()
			linearVelocity:Destroy()
			attachment:Destroy()
			humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
		end)
		
		-- Сброс перезарядки для этого игрока
		task.wait(cooldown)
		activePlayers[character] = nil
	end
end

pad.Touched:Connect(onTouch)
