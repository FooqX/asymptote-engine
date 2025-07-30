--!strict

--[=[
	@class FaceControl

	Controls the face decals of an Agent, allowing to change
	face expressions, lip sync, etc.
]=]
local FaceControl = {}
FaceControl.__index = FaceControl

export type FaceControl = typeof(setmetatable({} :: {
	head: BasePart,
	currentExpressionName: string,
	currentExpressionDecals: { 
		EYES: { Decal },
		MOUTHS: { Decal },
		BROWS: { Decal },
		ADDITIONALS: { Decal }
	}
}, FaceControl))

type FaceAlias = "Neutral"
	| "Shocked"
	| "Angry"
	| "Unconscious"
	| "None"

type FaceExpression = {
	name: string,
	decalIds: { 
		EYES: { number },
		MOUTHS: { number },
		BROWS: { number },
		ADDITIONALS: { number }
	}
}

function FaceControl.new(character: Model): FaceControl
	local head = character:FindFirstChild("Head") :: BasePart
	return setmetatable({
		head = head,
		currentExpressionName = FaceControl.setupHead(head),
		currentExpressionDecals = {
			EYES = {},
			MOUTHS = {},
			BROWS =  {},
			ADDITIONALS = {}
		}
	}, FaceControl)
end

--[=[
	Overrides the current expression's mouth.
]=]
function FaceControl.setMouth(self: FaceControl, mouth: { number }): ()
	
end

--[=[
	Sets the current expression's mouth if previously overridden by
	calling `setMouth()`
]=]
function FaceControl.setDefaultExpressionMouth(self: FaceControl): ()
	
end

--[=[
	Overrides the current expression's eyes.
]=]
function FaceControl.setEyes(self: FaceControl, eyes: { number }): ()
	
end


--[=[
	Sets the current expression's eyes if previously overridden by
	calling `setEyes()`
]=]
function FaceControl.setDefaultExpressionEyes(self: FaceControl): ()
	
end

function FaceControl.setExpression(self: FaceControl, faceAlias: FaceAlias): ()
	if self.currentFaceAlias == faceAlias then return end
	self.currentFaceAlias = faceAlias
end

function FaceControl.createDecal(self: FaceControl, assetId: number): Decal
	local newDecal = Instance.new("Decal")
	newDecal.TextureContent = Content.fromAssetId(assetId)
	newDecal.Face = Enum.NormalId.Front
	newDecal.Parent = self.head:FindFirstChild("Face Decals") -- use the HDIfy plugin so it can have HD faces

	return newDecal
end

function FaceControl.setupHead(head: BasePart): FaceAlias
	local faceDecals = head:FindFirstChild("Face Decals") :: Folder
	for _, decal in ipairs(faceDecals:GetChildren()) do
		if decal:IsA("Decal") then
			decal:Destroy()
		end
	end

	return "None"
end

return FaceControl