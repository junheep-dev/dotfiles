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

	-- Shrink to 90% if larger than the screen
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

	-- Compute the centered position
	local x = screenFrame.x + (screenFrame.w - adjustedWidth) / 2
	local y = screenFrame.y + (screenFrame.h - adjustedHeight) / 2

	-- Apply size and position
	win:setFrame({ x = x, y = y, w = adjustedWidth, h = adjustedHeight }, 0)
end

hs.hotkey.bind({ "alt", "ctrl" }, "c", function()
	centerWindowWithSize(1800, 1200)
end)

-- Focus modes: show only the given apps, hide all other regular apps
local DIA = "company.thebrowser.dia"
local GHOSTTY = "com.mitchellh.ghostty"
local ZOOM = "us.zoom.xos"

-- Show an app instantly: unhide, then raise its main window via AX. The AX raise
-- reveals Chromium apps (e.g. Dia) that ignore unhide(), so we never shell out to
-- osascript (which costs 100–300ms per call and made switching feel sluggish).
local function show(app)
	app:unhide()
	local ax = hs.axuielement.applicationElement(app)
	local win = ax and ax:attributeValue("AXMainWindow")
	if win then
		win:performAction("AXRaise")
	end
end

local function hideViaSystemEvents(app)
	hs.osascript.applescript(
		string.format([[tell application "System Events" to set visible of process "%s" to false]], app:name())
	)
end

-- Apps that ignore both hide() and the AX hidden attribute (Chromium-based, e.g. Dia).
-- Hide these via System Events straight away so there's no retry delay.
local STUBBORN_HIDE = { [DIA] = true }

-- Hide an app instantly. Normal apps use app:hide() (in-process, no osascript); stubborn
-- apps go straight to System Events. As a safety net, any app that's still visible shortly
-- after gets one deferred System Events hide — off the visible transition path.
local function hide(app)
	if STUBBORN_HIDE[app:bundleID()] then
		hideViaSystemEvents(app)
	elseif not app:hide() then
		hs.timer.doAfter(0.15, function()
			if not app:isHidden() then
				hideViaSystemEvents(app)
			end
		end)
	end
end

-- Lay out the focused window based on the display's aspect ratio (with GAP padding):
--   Ultrawide (21:9+) → 80% width, centered
--   Otherwise (built-in, 16:9 external) → maximize
local GAP = 4
local ULTRAWIDE_RATIO = 2.0

local function layoutWindow(win)
	if not win then
		return
	end
	local screen = win:screen()
	if not screen then
		return
	end
	local f = screen:frame()

	if f.w / f.h > ULTRAWIDE_RATIO then
		local w = f.w * 0.8
		win:setFrame({ x = f.x + (f.w - w) / 2, y = f.y + GAP, w = w, h = f.h - 2 * GAP }, 0)
	else
		win:setFrame({ x = f.x + GAP, y = f.y + GAP, w = f.w - 2 * GAP, h = f.h - 2 * GAP }, 0)
	end
end

-- Apply the standard layout to the focused window (any app, anywhere).
-- Overrides Rectangle's default Maximize on the same chord.
hs.hotkey.bind({ "alt", "ctrl" }, "return", function()
	layoutWindow(hs.window.focusedWindow())
end)

-- Meeting layout: Dia on the left / Zoom meeting window on the right
-- (ultrawide = 80% total, centered; otherwise = full width), keeping GAP
local function layoutMeeting()
	local diaApp = hs.application.get(DIA)
	local zoomApp = hs.application.get(ZOOM)
	if not diaApp or not zoomApp then
		return
	end

	local diaWin = diaApp:mainWindow()
	-- Zoom has separate home ("Zoom Workplace") / meeting ("Zoom Meeting") windows
	-- → prefer the meeting window, fall back to the main one
	local zoomWin
	for _, w in ipairs(zoomApp:allWindows()) do
		if (w:title() or ""):find("Meeting") then
			zoomWin = w
			break
		end
	end
	zoomWin = zoomWin or zoomApp:mainWindow()
	if not diaWin or not zoomWin then
		return
	end

	local screen = hs.screen.mainScreen()
	local f = screen:frame()

	local regionW, left
	if f.w / f.h > ULTRAWIDE_RATIO then
		regionW = f.w * 0.8
		left = f.x + (f.w - regionW) / 2
	else
		regionW = f.w - 2 * GAP
		left = f.x + GAP
	end

	local eachW = (regionW - GAP) / 2
	local top = f.y + GAP
	local h = f.h - 2 * GAP

	diaWin:setFrame({ x = left, y = top, w = eachW, h = h }, 0)
	zoomWin:setFrame({ x = left + eachW + GAP, y = top, w = eachW, h = h }, 0)
end

local function focusMode(bundleIDs, layout)
	local keep = {}
	for _, id in ipairs(bundleIDs) do
		keep[id] = true
	end

	-- Show the target apps and make the first one frontmost
	for _, id in ipairs(bundleIDs) do
		local app = hs.application.get(id)
		if app then
			show(app)
		else
			hs.application.launchOrFocusByBundleID(id)
		end
	end
	local first = hs.application.get(bundleIDs[1])
	if first then
		first:activate()
	end

	-- Hide the rest (frontmost is fixed, so they won't resurface)
	for _, app in ipairs(hs.application.runningApplications()) do
		-- kind() == 1: only regular Dock apps (excludes menu-bar-only apps, etc.)
		if app:kind() == 1 and not keep[app:bundleID()] then
			hide(app)
		end
	end

	-- Lay out the first app's window per display (slight delay since activate is async)
	if layout and first then
		hs.timer.doAfter(0.12, function()
			layoutWindow(first:mainWindow())
		end)
	end
end

-- browser: browser only (with window layout)
hs.hotkey.bind({ "alt" }, "1", function()
	focusMode({ DIA }, true)
end)

-- code: terminal only (with window layout)
hs.hotkey.bind({ "alt" }, "2", function()
	focusMode({ GHOSTTY }, true)
end)

-- meeting: Dia left / Zoom meeting window right, side by side
hs.hotkey.bind({ "alt" }, "3", function()
	focusMode({ ZOOM, DIA })
	hs.timer.doAfter(0.15, layoutMeeting)
end)
