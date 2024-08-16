-- module works for mobile and pc

local RunService = game:GetService('RunService')
if not (RunService:IsClient() or RunService:IsStudio()) then return end -- messes with intellisense. Comment out if you want to edit the source

local Players = game:GetService('Players')

local player = Players.LocalPlayer
local mouse = player:GetMouse()

local Assets = script.Assets
local Config = require(script.Config)
local Types = require(script.Types)

local FlyInfoCards = {}

local base_x = 1800
local base_y = 806

local sizes = {
	small = 20,
	medium = 40,
	large = 50,
}

function FlyInfoCards.displayInfoCard(hover_asset: Types.HoverAsset, group_config: Types.GroupsConfig, card_config: Types.CardConfig)
	if not player.PlayerGui:FindFirstChild("HoverGui") then
		local hover = Instance.new("ScreenGui",
			player.PlayerGui
		)
	end

	local min_factor = 0.65 - (#card_config * .025)  -- The minimum factor we want to achieve
	
	local factor_x = player.PlayerGui.HoverGui.AbsoluteSize.X/base_x
	local factor_y = player.PlayerGui.HoverGui.AbsoluteSize.Y/base_y

	local card_height = 0

	local info_card = Assets.InfoCard:Clone()
	card_height += info_card.AbsoluteSize.Y
	
	info_card.Parent = player.PlayerGui.HoverGui
	info_card.Position = UDim2.fromOffset(
		mouse.X+20*factor_x, 
		mouse.Y+10*factor_y
	)
	
	local splitter_config: {number} = {}
	for group_name, priority in group_config do
		table.insert(
			splitter_config,
			priority
		)
	end
	table.sort(
		splitter_config,
		function(a, b)
			return a > b
		end
	)
	table.remove(
		splitter_config,
		#splitter_config
	)
	
	if #splitter_config > 0 then
		for _, priority in splitter_config do
			local splitter = Assets.Splitter:Clone()
			splitter.LayoutOrder = -priority*10
			
			card_height += splitter.AbsoluteSize.Y
			
			splitter.Parent = info_card
		end
	end
	
	for _, entry in card_config do
		entry.asset.LayoutOrder = (-10 * group_config[entry.group]) - entry.priority
		print(entry, entry.asset.LayoutOrder)
		
		entry.asset.Size = UDim2.new(
			.9, 0,
			0, math.max(sizes[entry.size] * min_factor, sizes[entry.size] * factor_y)
		)
		
		card_height += entry.asset.AbsoluteSize.Y
		
		entry.asset.Parent = info_card
	end
	
	
	local compensation_factor_y = 1
	local compensation_factor_x = 1

	mouse.Move:Connect(function()
		local bottom_posi = mouse.Y + card_height + 10
		if bottom_posi > player.PlayerGui.HoverGui.AbsoluteSize.Y then
			info_card.AnchorPoint = Vector2.new(
				info_card.AnchorPoint.X,
				1
			)
			compensation_factor_y = -1
		else
			info_card.AnchorPoint = Vector2.new(
				info_card.AnchorPoint.X,
				0
			)
			compensation_factor_y = 1
		end

		info_card.Position = UDim2.fromOffset(
			mouse.X+20*factor_x, 
			mouse.Y+10*compensation_factor_y*factor_y
		)
	end)
	
	hover_asset.MouseLeave:Once(function()
		info_card:Destroy()
	end)
end

return FlyInfoCards
