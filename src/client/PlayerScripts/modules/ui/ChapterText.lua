--!strict

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local localPlayer = Players.LocalPlayer
local playerGui = localPlayer.PlayerGui

local ui = playerGui:WaitForChild("ChapterTextUi")
local uiRoot = ui.root
local chapterNumberText = uiRoot.frame_chapterNum.text
local chapterNumberBackdrop = uiRoot.frame_chapterNum.text_backdrop
local chapterNumberGradient: UIGradient = chapterNumberText.UIGradient
local chapterTitleText = uiRoot.frame_chapterTitle.text
local chapterTitleBackdrop = uiRoot.frame_chapterTitle.text_backdrop
local chapterTitleGradient: UIGradient = chapterTitleText.UIGradient

local arrayChaptersText = {chapterNumberText, chapterTitleText, chapterNumberBackdrop, chapterTitleBackdrop}
local arrayGradients = {chapterNumberGradient, chapterTitleGradient}
local arrayBackdrops = {chapterNumberBackdrop, chapterTitleBackdrop}

local GRADIENT_ROT_VAL_START = -62
local GRADIENT_ROT_VAL_END = 115

local TWEEN_INFO_GRADIENT_SHOW = TweenInfo.new(2.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
local TWEEN_INFO_GRADIENT_HIDE = TweenInfo.new(10, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local TWEEN_INFO_TEXT_HIDE = TweenInfo.new(5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

local animateShowGradientTweens: {Tween} = {}
local animateHideGradientTweens: {Tween} = {}
local animateHideBackdropTweens: {Tween} = {}

for i, gradient in ipairs(arrayGradients) do
	animateShowGradientTweens[i] = TweenService:Create(gradient, TWEEN_INFO_GRADIENT_SHOW, {Rotation = 0})
	animateHideGradientTweens[i] = TweenService:Create(gradient, TWEEN_INFO_GRADIENT_HIDE, {Rotation = 180})
end

for i, backdrop in ipairs(arrayBackdrops) do
	animateHideBackdropTweens[i] = TweenService:Create(backdrop, TWEEN_INFO_TEXT_HIDE, {TextTransparency = 1})
end

local currentNumber = 0
local currentTitle = ""

local ChapterText = {}

function ChapterText.beginShowChapter(number: number, title: string, durationStart: number): ()
	if number == currentNumber and currentTitle == title then
		return
	end

	currentNumber = number
	currentTitle = title

	for _, tween in ipairs(animateShowGradientTweens) do
		tween:Cancel()
	end
	for _, tween in ipairs(animateHideGradientTweens) do
		tween:Cancel()
	end
	for _, tween in ipairs(animateHideBackdropTweens) do
		tween:Cancel()
	end

	for _, text in ipairs(arrayChaptersText) do
		if text.Parent.Name:find("Num") then
			text.Text = "CHAPTER "..tostring(number)
		else
			text.Text = title
		end
	end

	ChapterText.animateShowText()
	task.wait(durationStart)
	ChapterText.animateHideText()
end

function ChapterText.animateShowText(): ()
	for i, gradient in ipairs(arrayGradients) do
		gradient.Rotation = GRADIENT_ROT_VAL_START
		arrayBackdrops[i].TextTransparency = 0
		animateShowGradientTweens[i]:Play()
	end
end

function ChapterText.animateHideText(): ()
	for i, gradient in ipairs(arrayGradients) do
		gradient.Rotation = GRADIENT_ROT_VAL_END
		animateHideGradientTweens[i]:Play()
	end
	for i, backdrop in ipairs(arrayBackdrops) do
		animateHideBackdropTweens[i]:Play()
	end
end

return ChapterText