--[[
 * ReaScript Name: regions_Insert custom colour and name
 * About: Inserts a custom region with a specified name and color
 * Author: AudioBabble
 * Repository: GitHub > AudioBabbL > REAPER-ReaPack
 * Repository URI: https://github.com/AudioBabbL/AudioBabble-ReaPack-Scripts/
 * Licence: GPL v3
 * REAPER: 7.0
 * Version: 1.0
--]]

--[[
 * Changelog:
 * v1.0 (2026-02-07)
  + Initial Release
--]]

-- ** SET NAME AND COLOUR AT LINES 39 AND 40 ** --

-- Define Colours
blue = reaper.ColorToNative(0,0,255)|0x1000000
red = reaper.ColorToNative(255,0,0)|0x1000000
green = reaper.ColorToNative(0,255,0)|0x1000000
cyan = reaper.ColorToNative(0,255,255)|0x1000000
magenta = reaper.ColorToNative(255,0,255)|0x1000000
maroon = reaper.ColorToNative(128,0,64)|0x1000000
yellow = reaper.ColorToNative(255,255,0)|0x1000000
orange = reaper.ColorToNative(255,125,0)|0x1000000
purple = reaper.ColorToNative(125,0,225)|0x1000000
lightblue = reaper.ColorToNative(13,165,175)|0x1000000
lightgreen = reaper.ColorToNative(125,255,155)|0x1000000
pink = reaper.ColorToNative(225,95,155)|0x1000000
brown = reaper.ColorToNative(125,95,25)|0x1000000
gray = reaper.ColorToNative(125,125,125)|0x1000000
white =  reaper.ColorToNative(255,255,255)|0x1000000
Black =  reaper.ColorToNative(0,0,0)|0x1000000

-- Set custom name and colour here:
name = "custom name"   --<<<<<<--Marker Name
color = blue           --<<<<<<--Marker Colour

start_pos, end_pos = reaper.GetSet_LoopTimeRange(false, false, 0, 0, false)

_, _, num_regions = reaper.CountProjectMarkers( 0 )

function insert_custom()
  if end_pos > 0 then
     reaper.AddProjectMarker2( 0, 1, start_pos, end_pos, name, num_regions+1, color)
  end
end

reaper.Undo_BeginBlock() 
  insert_custom()
reaper.Undo_EndBlock("Insert_Marker_Custom_Name_Color", 0)