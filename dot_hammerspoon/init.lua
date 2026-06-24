-- Ctrl+J -> かな (japanese_kana) for AquaSKK in terminal-like apps.
--
-- Why Hammerspoon and not Karabiner:
--   Karabiner-Elements only grabs physical HID keyboard devices, so it cannot
--   see keyboard input injected by Universal Control. Verified on this machine:
--   local Ctrl+J reached the CGEventTap already remapped (keycode 0x68), while
--   Universal Control Ctrl+J arrived as raw keycode 38 + ctrl, untouched.
--   This remap lives at the CGEventTap layer (where Hammerspoon operates), so
--   both local and Universal Control input arrive identically as keycode 38 +
--   ctrl and are handled the same way.
--
-- This mirrors the (removed) Karabiner rule "Control+J to Kana": same target
-- apps, same j -> japanese_kana mapping. The original Ctrl+J is dropped and a
-- clean kana key down+up pair is posted (an in-place keycode rewrite left
-- AquaSKK stuck in ASCII, so a full synthetic keypress is required).

local KANA = 0x68 -- 104 = japanese_kana keycode
local J = 38      -- keycode for "j"

-- Same applications as the Karabiner rule.
local targetBundleIDs = {
  ["com.apple.Terminal"] = true,
  ["com.mitchellh.ghostty"] = true,
  ["com.tinyspeck.slackmacgap"] = true,
}

local function isTargetApp()
  local app = hs.application.frontmostApplication()
  if not app then return false end
  local bundleID = app:bundleID()
  if not bundleID then return false end
  if targetBundleIDs[bundleID] then return true end
  return bundleID:match("^com%.jetbrains%.") ~= nil -- com.jetbrains.*
end

local function isCtrlJ(event)
  if event:getKeyCode() ~= J then return false end
  local f = event:getFlags()
  -- ctrl held, and no other modifier (mirror Karabiner mandatory:[control]).
  return f.ctrl and not f.cmd and not f.alt and not f.shift
end

local eventTypes = hs.eventtap.event.types
ctrlJToKanaTap = hs.eventtap.new({ eventTypes.keyDown, eventTypes.keyUp }, function(event)
  if not isCtrlJ(event) or not isTargetApp() then
    return false
  end
  if event:getType() == eventTypes.keyDown then
    -- Drop the original Ctrl+J and post a clean kana key press.
    local down = hs.eventtap.event.newKeyEvent({}, KANA, true)
    local up = hs.eventtap.event.newKeyEvent({}, KANA, false)
    return true, { down, up }
  end
  -- Swallow the matching key up so no stray Ctrl+J reaches the app.
  return true
end)
ctrlJToKanaTap:start()
