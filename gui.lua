local Unlocker, awful, project = ...



local gui, settings, cmd = awful.UI:New("Eat Shit", {
	title = "Eat Shit",
	show = false,
	colors = {
		title = {245, 235, 55, 1},
		primary = {255, 255, 255, 1},
		accent = {245, 235, 55, 1},
		background = {21, 21, 21, 0.45}
	}
})

local StatusFrame = gui:StatusFrame({
	colors = {
	  background = { 0, 0, 0, 0 },
	  enabled = { 200, 200, 255, 1 },
	},
	maxWidth = 450,
  })


project.settings = settings



StatusFrame:Button({
	spellId = 1126,
	text = {
	  enabled = awful.colors.green .. "Enabled",
	  disabled = awful.colors.red .. "Disabled"
	},
	textSize = 8,
	var = "on",
	onClick = function()
	  awful.enabled = not awful.enabled
	  awful.print(awful.enabled and "|cff5fd729Enabled" or "|cfff44336Disabled")
	end,
	size = 32,
	padding = 0
  })
	settings.on = false
  local function EnableSync()
	if awful.enabled then
	  if not settings.on then
		settings.on = true
	  end
	else
	  if settings.on then
		settings.on = false
	  end
	end
  end
  awful.addUpdateCallback(EnableSync)


  StatusFrame:Button({
	text = {
		enabled = awful.colors.green .. "DMG",
		disabled = awful.colors.red .. "DMG"
	  },
	textSize = 8,
	spellId = 287712,
	var = "DMG",
	onClick = function()
	  awful.print(settings.DMG and "DMG ON |cff5fd729On" or "DMG OFF |cfff44336Off")
	end,
	size = 32,
	padding = 0
  })