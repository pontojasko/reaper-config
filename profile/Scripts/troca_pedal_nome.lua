local track_clean, track_lead

-- varre todas as pistas procurando pelos nomes
for i = 0, reaper.CountTracks(0) - 1 do
    local track = reaper.GetTrack(0, i)
    local _, name = reaper.GetSetMediaTrackInfo_String(track, "P_NAME", "", false)
    name = string.lower(name)
    
    if string.match(name, "clean") then track_clean = track end
    if string.match(name, "lead") then track_lead = track end
end

-- se encontrar as duas, inverte os mutes garantindo que apenas uma soe
if track_clean and track_lead then
    local clean_mute = reaper.GetMediaTrackInfo_Value(track_clean, "B_MUTE")
    
    if clean_mute == 0.0 then
        -- se clean ta desmutada, muta a clean e solta a lead
        reaper.SetMediaTrackInfo_Value(track_clean, "B_MUTE", 1.0)
        reaper.SetMediaTrackInfo_Value(track_lead, "B_MUTE", 0.0)
    else
        -- senao, faz o inverso
        reaper.SetMediaTrackInfo_Value(track_clean, "B_MUTE", 0.0)
        reaper.SetMediaTrackInfo_Value(track_lead, "B_MUTE", 1.0)
    end
end



