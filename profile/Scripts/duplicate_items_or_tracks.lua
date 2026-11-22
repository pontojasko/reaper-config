local item_count = reaper.CountSelectedMediaItems(0)
local track_count = reaper.CountSelectedTracks(0)

reaper.Undo_BeginBlock()

if item_count > 0 then
  reaper.Main_OnCommand(41295, 0) -- Item edit: Duplicate items
elseif track_count > 0 then
  reaper.Main_OnCommand(40062, 0) -- Track: Duplicate selected tracks
end

reaper.Undo_EndBlock("Duplicate selected items or tracks", -1)