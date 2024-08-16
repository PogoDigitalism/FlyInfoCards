local Types = {}

export type HoverAsset = GuiButton | GuiLabel | Frame
export type InfoAsset = GuiLabel | Frame
export type InfoAssetSize = "small" | "medium" | "large"

export type GroupsConfig = {
	[string]: number
}
export type CardConfig = {
	{
		asset: InfoAsset,
		size: InfoAssetSize,
		priority: number,
		group: string,
	}
}

return Types
