-- Description: Select all items and then create time selection (like FL Studio)
-- Author: Amely Suncroll

-- Official forum page: https://forum.cockos.com/showthread.php?t=291012

-- About this script: Set it up on "Ctrl+A" shortcut.



-- Donation: 

--          PAYPAL: https://www.paypal.com/paypalme/suncroll
-- VISA/MASTERCARD: https://www.paypal.com/ncp/payment/S8C8GEXK68TNC



-- Personal support:

--    EMAIL: amelysuncroll@gmail.com
-- TELEGRAM: https://t.me/amely_suncroll_support



-- THIS SCRIPT IS INCLUDED TO "EXCLUSIVE FL STUDIO SCRIPTS FOR REAPER DAW" PACK



function sel_all_items_and_create_time_sel()
    reaper.Main_OnCommand(40182, 1)
    reaper.Main_OnCommand(reaper.NamedCommandLookup("_SWS_SAFETIMESEL"), 0)
end

function sel_all_au_items_in_time_sel()
    local time_sel_start, time_sel_end = reaper.GetSet_LoopTimeRange(false, false, 0, 0, false)
    if time_sel_start == time_sel_end then return end

    local track_count = reaper.CountTracks(0)
    for i = 0, track_count - 1 do
        local track = reaper.GetTrack(0, i)
        local envelope_count = reaper.CountTrackEnvelopes(track)

        for j = 0, envelope_count - 1 do
            local envelope = reaper.GetTrackEnvelope(track, j)
            local automation_item_count = reaper.CountAutomationItems(envelope)

            for k = 0, automation_item_count - 1 do
                local ai_start = reaper.GetSetAutomationItemInfo(envelope, k, "D_POSITION", 0, false)
                local ai_length = reaper.GetSetAutomationItemInfo(envelope, k, "D_LENGTH", 0, false)
                local ai_end = ai_start + ai_length

                if (ai_start < time_sel_end) and (ai_end > time_sel_start) then
                    reaper.GetSetAutomationItemInfo(envelope, k, "D_UISEL", 1, true)
                end
            end
        end
    end
end

function main()
    sel_all_items_and_create_time_sel()
    sel_all_au_items_in_time_sel()
end

main()
reaper.UpdateArrange()



