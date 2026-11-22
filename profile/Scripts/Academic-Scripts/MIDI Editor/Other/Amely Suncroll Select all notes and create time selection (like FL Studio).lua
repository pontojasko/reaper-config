function sel_all_notes_and_cr_time_sel()
  local midi_editor = reaper.MIDIEditor_GetActive()
  if not midi_editor then return end

  local take = reaper.MIDIEditor_GetTake(midi_editor)
  
  if not take or not reaper.TakeIsMIDI(take) then return end

  local item = reaper.GetMediaItemTake_Item(take)
  local item_start = reaper.GetMediaItemInfo_Value(item, "D_POSITION")
  local item_length = reaper.GetMediaItemInfo_Value(item, "D_LENGTH")
  local item_end = item_start + item_length
  local _, notecnt, _, _ = reaper.MIDI_CountEvts(take)

  if notecnt == 0 then return end

  reaper.MIDI_SelectAll(take, true)

  local first_note_pos = nil
  local last_note_end = nil
  local notes_in_first_bar = false
  local notes_in_last_bar = false

  for i = 0, notecnt - 1 do
      local _, _, _, startppqpos, endppqpos, _, _, _ = reaper.MIDI_GetNote(take, i)
      local note_start = reaper.MIDI_GetProjTimeFromPPQPos(take, startppqpos)
      local note_end = reaper.MIDI_GetProjTimeFromPPQPos(take, endppqpos)

      if not first_note_pos or note_start < first_note_pos then
          first_note_pos = note_start
      end

      if not last_note_end or note_end > last_note_end then
          last_note_end = note_end
      end

      local _, note_bar_start = reaper.TimeMap2_timeToBeats(0, note_start)
      local _, item_bar_start = reaper.TimeMap2_timeToBeats(0, item_start)
      if note_bar_start == item_bar_start then
          notes_in_first_bar = true
      end

      local _, note_bar_end = reaper.TimeMap2_timeToBeats(0, note_end)
      local _, item_bar_end = reaper.TimeMap2_timeToBeats(0, item_end)
      if note_bar_end == item_bar_end then
          notes_in_last_bar = true
      end
  end

  local _, measure_start = reaper.TimeMap2_timeToBeats(0, item_start)
  local measure_start_time = reaper.TimeMap2_beatsToTime(0, measure_start)
  local measure_length = reaper.TimeMap2_beatsToTime(0, measure_start + 4) - measure_start_time -- Припускаємо 4 долі в такті

  if (item_end - item_start) <= measure_length then
      reaper.GetSet_LoopTimeRange(true, false, item_start, item_end, false)
      return
  end

  local _, first_note_bar = reaper.TimeMap2_timeToBeats(0, first_note_pos)
  local _, last_note_bar = reaper.TimeMap2_timeToBeats(0, last_note_end)
  local last_measure_start_time = reaper.TimeMap_GetMeasureInfo(0, last_note_bar)

  if math.abs(last_note_end - last_measure_start_time) < 0.0001 then
      last_note_bar = last_note_bar - 1
  end

  local first_bar_start = reaper.TimeMap_GetMeasureInfo(0, first_note_bar)
  local last_bar_end = reaper.TimeMap_GetMeasureInfo(0, last_note_bar + 1)

  reaper.GetSet_LoopTimeRange(true, false, first_bar_start, last_bar_end, false)



  local item_start_is_bar_start = math.abs(item_start - first_bar_start) < 0.0001

  if not item_start_is_bar_start and notes_in_first_bar then
      first_bar_start = item_start
  end

  local item_end_is_bar_end = math.abs(item_end - last_bar_end) < 0.0001

  if item_end_is_bar_end and last_note_end < item_end then
      last_bar_end = last_note_end
  elseif not item_end_is_bar_end and notes_in_last_bar then
      last_bar_end = item_end
  end

  reaper.GetSet_LoopTimeRange(true, false, first_bar_start, last_bar_end, false)
end

reaper.Undo_BeginBlock()
sel_all_notes_and_cr_time_sel()
reaper.Undo_EndBlock("Select all notes and create time selection", -1)
