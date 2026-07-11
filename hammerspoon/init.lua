local function moveWindowToFocusedSpace(application, applicationName)
	local app = hs.application.find(application, true)

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
	moveWindowToFocusedSpace("Dia")
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

-- Focus modes: 지정한 앱만 보이고 나머지 일반 앱은 전부 숨김
local DIA = "company.thebrowser.dia"
local GHOSTTY = "com.mitchellh.ghostty"
local ZOOM = "us.zoom.xos"

-- Dia 등 일부 Chromium 앱은 hide()를 거부 → System Events로 폴백
local function hide(app)
	if not app:hide() then
		hs.osascript.applescript(
			string.format([[tell application "System Events" to set visible of process "%s" to false]], app:name())
		)
	end
end

local function focusMode(bundleIDs)
	local keep = {}
	for _, id in ipairs(bundleIDs) do
		keep[id] = true
	end

	-- 타겟 앱들 띄우고, 첫 번째를 frontmost로 확정
	for _, id in ipairs(bundleIDs) do
		local app = hs.application.get(id)
		if app then
			app:unhide()
		else
			hs.application.launchOrFocusByBundleID(id)
		end
	end
	local first = hs.application.get(bundleIDs[1])
	if first then
		first:activate()
	end

	-- 나머지 숨기기 (frontmost가 확정됐으니 다시 안 올라옴)
	for _, app in ipairs(hs.application.runningApplications()) do
		-- kind() == 1: Dock에 뜨는 일반 앱만 (메뉴바 상주 앱 등은 제외)
		if app:kind() == 1 and not keep[app:bundleID()] then
			hide(app)
		end
	end
end

-- browser: 브라우저만
hs.hotkey.bind({ "alt" }, "1", function()
	focusMode({ DIA })
end)

-- code: 터미널만
hs.hotkey.bind({ "alt" }, "2", function()
	focusMode({ GHOSTTY })
end)

-- meeting: 줌 + 브라우저
hs.hotkey.bind({ "alt" }, "3", function()
	focusMode({ ZOOM, DIA })
end)
