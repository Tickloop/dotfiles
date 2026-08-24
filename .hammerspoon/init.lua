-- MARK: Window cycler
-- Karabiner remaps cmd+enter -> F18; we bind F18 here so cmd+enter stays
-- available to apps and Karabiner remains the single owner of the mapping.

-- Sorting by a stable id (rather than z-order) makes each press advance to a
-- predictable "next" window instead of bouncing between the two most-recent.
local function cycleWindows()
    local wins = {}
    for _, w in ipairs(hs.window.allWindows()) do
        if w:isStandard() and w:isVisible() then
            table.insert(wins, w)
        end
    end
    if #wins == 0 then return end
    table.sort(wins, function(a, b) return a:id() < b:id() end)

    local idx = 0
    local focused = hs.window.focusedWindow()
    if focused then
        for i, w in ipairs(wins) do
            if w:id() == focused:id() then idx = i break end
        end
    end
    wins[idx % #wins + 1]:focus()
end

hs.hotkey.bind({}, "f18", cycleWindows)

-- MARK: Display focus cycler
-- Karabiner's Caps Lock layer emits F13 immediately before pass-through keys.
-- Treat F13 as a short-lived prefix, so Caps Lock + 0 focuses the frontmost
-- visible app window on exactly the next display from left to right.
local function focusNextDisplay()
    local focused = hs.window.focusedWindow()
    local currentScreen = focused and focused:screen() or hs.screen.mainScreen()

    local screens = hs.screen.allScreens()
    if #screens < 2 then return end

    table.sort(screens, function(a, b)
        local aFrame, bFrame = a:frame(), b:frame()
        if aFrame.x == bFrame.x then return aFrame.y < bFrame.y end
        return aFrame.x < bFrame.x
    end)

    local currentIndex = 1
    for i, screen in ipairs(screens) do
        if screen:id() == currentScreen:id() then
            currentIndex = i
            break
        end
    end

    -- Always target exactly the next display. Do not skip a display based on
    -- its windows, since that makes the display cycle unpredictable.
    local targetIndex = (currentIndex % #screens) + 1
    local targetScreen = screens[targetIndex]
    local windows = hs.window.orderedWindows()
    local targetWindow

    -- Prefer the frontmost normal app window on the target display.
    for _, window in ipairs(windows) do
        if window:isStandard()
            and window:isVisible()
            and window:screen():id() == targetScreen:id()
        then
            targetWindow = window
            break
        end
    end

    -- Fall back to any visible app window, but never advance to another
    -- display. This keeps the display order exact.
    if not targetWindow then
        for _, window in ipairs(windows) do
            if window:isVisible()
                and window:screen():id() == targetScreen:id()
                and window:application()
            then
                targetWindow = window
                break
            end
        end
    end

    if not targetWindow then
        hs.alert.show("No visible app on " .. (targetScreen:name() or "next display"))
        return
    end

    -- macOS switches Spaces on the display containing the pointer. Move the
    -- pointer into the chosen window so subsequent Ctrl-Left/Ctrl-Right
    -- shortcuts operate on this display too.
    hs.mouse.absolutePosition(targetWindow:frame().center)

    -- Make this exact window the app's main window before activating the app.
    -- This matters when the same app, such as Ghostty, has windows on more
    -- than one display.
    targetWindow:becomeMain()
    local app = targetWindow:application()
    if app then app:activate(false) end
    targetWindow:raise():focus()
end

-- Observe the F13 sequence without binding or consuming F13 itself. This lets
-- Ghostty and Neovim continue receiving F13 followed by their shortcut key.
local f13KeyCode = hs.keycodes.map.f13
local zeroKeyCode = hs.keycodes.map["0"]
local f13PrefixExpiresAt = 0
local suppressZeroKeyUp = false

-- Keep this reference global so Lua does not garbage-collect the event tap.
f13SequenceTap = hs.eventtap.new({
    hs.eventtap.event.types.keyDown,
    hs.eventtap.event.types.keyUp,
}, function(event)
    local eventType = event:getType()
    local keyCode = event:getKeyCode()

    if eventType == hs.eventtap.event.types.keyDown then
        if keyCode == f13KeyCode then
            f13PrefixExpiresAt = hs.timer.secondsSinceEpoch() + 0.4
            return false
        end

        if keyCode == zeroKeyCode
            and hs.timer.secondsSinceEpoch() <= f13PrefixExpiresAt
        then
            f13PrefixExpiresAt = 0
            suppressZeroKeyUp = true
            focusNextDisplay()
            return true
        end

        f13PrefixExpiresAt = 0
        return false
    end

    if keyCode == zeroKeyCode and suppressZeroKeyUp then
        suppressZeroKeyUp = false
        return true
    end

    return false
end)

f13SequenceTap:start()

hs.alert.show("Hammerspoon config loaded")
