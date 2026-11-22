local has_clean_active = false
local found_fx = false

-- loop 1: varre todas as tracks do projeto para descobrir o estado atual do 'clean'
for t = 0, reaper.CountTracks(0) - 1 do
    local track = reaper.GetTrack(0, t)
    local fx_count = reaper.TrackFX_GetCount(track)
    
    for i = 0, fx_count - 1 do
        local _, fx_name = reaper.TrackFX_GetFXName(track, i)
        fx_name = string.lower(fx_name)
        
        if string.match(fx_name, "clean") then
            if reaper.TrackFX_GetEnabled(track, i) then
                has_clean_active = true
            end
            found_fx = true
        end
    end
end

-- loop 2: se encontrou os plugins, varre as tracks de novo invertendo o estado deles
if found_fx then
    for t = 0, reaper.CountTracks(0) - 1 do
        local track = reaper.GetTrack(0, t)
        local fx_count = reaper.TrackFX_GetCount(track)
        
        for i = 0, fx_count - 1 do
            local _, fx_name = reaper.TrackFX_GetFXName(track, i)
            fx_name = string.lower(fx_name)
            
            if string.match(fx_name, "clean") then
                reaper.TrackFX_SetEnabled(track, i, not has_clean_active)
            elseif string.match(fx_name, "lead") then
                reaper.TrackFX_SetEnabled(track, i, has_clean_active)
            end
        end
    end
end
