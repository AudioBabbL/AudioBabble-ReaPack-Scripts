--[[
 * ReaScript Name: stretch-markers_Move under edit cursor Right by grid and move edit cursor
 * About: -- If there is a stretch marker under the edit cursor in the currently selected item, moves the cursor right by one grid division using action 40646, and moves the stretch marker to that position.
 * Author: AudioBabble
 * Donation: https://paypal.me/audiobabble
 * Repository: GitHub > AudioBabbL > AudioBabble-ReaPack-Scripts
 * Repository URI: https://github.com/AudioBabbL/AudioBabble-ReaPack-Scripts/
 * Licence: GPL v3
 * Forum Thread: Script Request Sticky
 * Forum Thread URI: https://forum.cockos.com/showpost.php?p=2914829&postcount=3220
 * REAPER: 7.0
 * Version: 1.0
--]]

--[[
 * Changelog:
 * v1.0 (2026-01-10)
  + Initial Release
--]]

reaper.Undo_BeginBlock()

local cursor_pos = reaper.GetCursorPosition()
local sel_item = reaper.GetSelectedMediaItem(0, 0)
if not sel_item then
  reaper.ShowMessageBox('No selected item.', 'Info', 0)
  reaper.Undo_EndBlock('Move stretch marker under edit cursor right by grid and move edit cursor', -1)
  return
end

local take = reaper.GetActiveTake(sel_item)
if not take or reaper.TakeIsMIDI(take) then
  reaper.ShowMessageBox('No valid audio take in selected item.', 'Info', 0)
  reaper.Undo_EndBlock('Move stretch marker under edit cursor right by grid and move edit cursor', -1)
  return
end

local item_pos = reaper.GetMediaItemInfo_Value(sel_item, 'D_POSITION')
local item_len = reaper.GetMediaItemInfo_Value(sel_item, 'D_LENGTH')
local take_playrate = reaper.GetMediaItemTakeInfo_Value(take, 'D_PLAYRATE')
local stretch_marker_count = reaper.GetTakeNumStretchMarkers(take)

local marker_idx = nil
local marker_abs_pos = nil
for k = 0, stretch_marker_count - 1 do
  retval, pos, srcpos = reaper.GetTakeStretchMarker(take, k)
  if retval > -1 then
    local abs_pos = item_pos + pos / take_playrate
    if math.abs(abs_pos - cursor_pos) < 0.01 then
      marker_idx = k
      marker_abs_pos = abs_pos
      break
    end
  end
end

if not marker_idx then
  reaper.ShowMessageBox('No stretch marker under edit cursor in selected item.', 'Info', 0)
  reaper.Undo_EndBlock('Move stretch marker under edit cursor right by grid and move edit cursor', -1)
  return
end

-- Move edit cursor right by one grid division (action 40647)
reaper.Main_OnCommand(40647, 0)
local new_cursor_pos = reaper.GetCursorPosition()

-- Move the stretch marker to the new cursor position
local rel_new_pos = (new_cursor_pos - item_pos) * take_playrate
reaper.SetTakeStretchMarker(take, marker_idx, rel_new_pos)
reaper.SetEditCurPos(new_cursor_pos, true, false)
reaper.UpdateArrange()
reaper.Undo_EndBlock('Move stretch marker under edit cursor right by grid and move edit cursor', -1)