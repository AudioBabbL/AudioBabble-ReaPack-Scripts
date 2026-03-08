--[[
 * ReaScript Name: stretch-markers_Move closest to edit cursor
 * About: Moves the closest stretch marker in the currently selected item to the edit cursor position
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
  reaper.Undo_EndBlock('Move closest stretch marker to edit cursor', -1)
  return
end

local take = reaper.GetActiveTake(sel_item)
if not take or reaper.TakeIsMIDI(take) then
  reaper.ShowMessageBox('No valid audio take in selected item.', 'Info', 0)
  reaper.Undo_EndBlock('Move closest stretch marker to edit cursor', -1)
  return
end

local item_pos = reaper.GetMediaItemInfo_Value(sel_item, 'D_POSITION')
local take_playrate = reaper.GetMediaItemTakeInfo_Value(take, 'D_PLAYRATE')
local stretch_marker_count = reaper.GetTakeNumStretchMarkers(take)

local closest_idx = nil
local closest_dist = nil
local closest_abs_pos = nil
for k = 0, stretch_marker_count - 1 do
  local retval, pos, srcpos = reaper.GetTakeStretchMarker(take, k)
  if retval > -1 then
    local abs_pos = item_pos + pos / take_playrate
    local dist = math.abs(abs_pos - cursor_pos)
    if not closest_dist or dist < closest_dist then
      closest_dist = dist
      closest_idx = k
      closest_abs_pos = abs_pos
    end
  end
end

if not closest_idx then
  reaper.ShowMessageBox('No stretch markers in selected item.', 'Info', 0)
  reaper.Undo_EndBlock('Move closest stretch marker to edit cursor', -1)
  return
end

-- Move the closest stretch marker to the edit cursor position
local rel_new_pos = (cursor_pos - item_pos) * take_playrate
reaper.SetTakeStretchMarker(take, closest_idx, rel_new_pos)
reaper.UpdateArrange()

reaper.Undo_EndBlock('Move closest stretch marker to edit cursor', -1)
