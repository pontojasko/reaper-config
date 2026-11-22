local sel_track_count = reaper.CountSelectedTracks(0)

if sel_track_count == 0 then return end

for t = 0, sel_track_count - 1 do
    local track = reaper.GetSelectedTrack(0, t)
    local fx_count = reaper.TrackFX_GetCount(track)
    
    local found_any = false
    local turn_clean_on = false

    -- passo 1: descobre o que tem na track e define qual vai ser a proxima acao
    for i = 0, fx_count - 1 do
        local _, fx_name = reaper.TrackFX_GetFXName(track, i)
        fx_name = string.lower(fx_name)
        
        if string.match(fx_name, "clean") then
            turn_clean_on = not reaper.TrackFX_GetEnabled(track, i)
            found_any = true
            break
        elseif string.match(fx_name, "lead") then
            turn_clean_on = reaper.TrackFX_GetEnabled(track, i)
            found_any = true
            break
        end
    end

    -- passo 2: aplica a inversao
    if found_any then
        for i = 0, fx_count - 1 do
            local _, fx_name = reaper.TrackFX_GetFXName(track, i)
            fx_name = string.lower(fx_name)
            
            if string.match(fx_name, "clean") then
                reaper.TrackFX_SetEnabled(track, i, turn_clean_on)
            elseif string.match(fx_name, "lead") then
                reaper.TrackFX_SetEnabled(track, i, not turn_clean_on)
            end
        end
    end
end
