-- An example module of how to use FlyInfoCards in your project. FlyInfoCards is purely functional so dont call FlyInfoCards directly from your GuiButton | GuiLabel registry scripts

local ReplicatedStorage = game:GetService('ReplicatedStorage')
local players = game:GetService('Players')

local ItemList = require(ReplicatedStorage:WaitForChild('Items'):WaitForChild('Lib'):WaitForChild('ItemList'))
local FlyInfoCards = require(ReplicatedStorage:WaitForChild('FlyInfoCards'))

local module = {}

function module.addItemInfoCard(info_frame: Frame, item_name: string)
	local item_info = ItemList[item_name]
	info_frame.MouseEnter:Connect(function()
		local item_name_label = script.Assets.RegularLabel:Clone()
		item_name_label.TextColor3 = item_info.name_label_color
		item_name_label.Text = item_info.name
		
		local description_label = script.Assets.RegularLabel:Clone()
		description_label.Text = item_info.description
		
		local card_config = {
			{
				asset = item_name_label,
				size = "medium",

				priority = 2,
				group = "main"
			}, 
			{
				asset = description_label,
				size = "large",

				priority = 1,
				group = "main"
			}, 
		}
		local group_config = {
			main = 2,
		}

		if not item_info.tradable then
			local label = script.Assets.UntradableLabel:Clone()
			
			group_config.tradable = 1
			
			table.insert(
				card_config,
				{
					asset = label,
					size = "small",
					
					priority = 1,
					group = "tradable"
				}
			)
		end

		FlyInfoCards.displayInfoCard(info_frame,
			group_config,
			card_config
		)
	end)
end

return module
