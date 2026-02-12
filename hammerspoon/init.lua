local function moveWindowToFocusedSpace(application, applicationName)
	local app = hs.application.get(application)

	if app == nil then
		hs.application.launchOrFocus(applicationName or application)
	elseif app:isFrontmost() then
		app:hide()
	else
		local mainWindow = app:mainWindow()
		if mainWindow ~= nil then
			-- Re-get the window reference to ensure it's current
			mainWindow = app:mainWindow()
			if mainWindow then
				-- Get current space before any operations
				local currentSpace = hs.spaces.focusedSpace()
				-- Move window to the space we were on
				hs.spaces.moveWindowToSpace(mainWindow, currentSpace)
				-- Focus the window after moving
				mainWindow:focus()
			end
		else
			hs.application.launchOrFocus(applicationName or application)
		end
	end
end

hs.hotkey.bind({ "cmd", "ctrl" }, "b", function()
	moveWindowToFocusedSpace("Arc")
end)

hs.hotkey.bind({ "cmd", "ctrl" }, "t", function()
	moveWindowToFocusedSpace("Ghostty")
end)

hs.hotkey.bind({ "cmd", "ctrl" }, "n", function()
	moveWindowToFocusedSpace("Obsidian")
end)

hs.hotkey.bind({ "cmd", "ctrl" }, "c", function()
	moveWindowToFocusedSpace("Notion Calendar")
end)

hs.hotkey.bind({ "cmd", "ctrl" }, "a", function()
	moveWindowToFocusedSpace("Things", "Things3")
end)

hs.hotkey.bind({ "cmd", "ctrl" }, "j", function()
	moveWindowToFocusedSpace("Claude")
end)

-- for work
hs.hotkey.bind({ "cmd", "ctrl" }, "i", function()
	moveWindowToFocusedSpace("Linear")
end)
hs.hotkey.bind({ "cmd", "ctrl" }, "s", function()
	moveWindowToFocusedSpace("Slack")
end)

local function centerWindowWithSize(width, height)
	local win = hs.window.focusedWindow()
	if not win then
		return
	end

	local screen = win:screen()
	local screenFrame = screen:frame()

	-- 화면보다 크면 90% size로 조정
	local adjustedWidth
	local adjustedHeight

	if width > screenFrame.w then
		adjustedWidth = screenFrame.w * 0.9
	else
		adjustedWidth = width
	end

	if height > screenFrame.h then
		adjustedHeight = screenFrame.h * 0.9
	else
		adjustedHeight = height
	end

	-- 창을 배치할 좌표 계산
	local x = screenFrame.x + (screenFrame.w - adjustedWidth) / 2
	local y = screenFrame.y + (screenFrame.h - adjustedHeight) / 2

	-- 창 크기 및 위치 설정
	win:setFrame({ x = x, y = y, w = adjustedWidth, h = adjustedHeight }, 0)
end

hs.hotkey.bind({ "alt", "ctrl" }, "c", function()
	centerWindowWithSize(1800, 1200)
end)
