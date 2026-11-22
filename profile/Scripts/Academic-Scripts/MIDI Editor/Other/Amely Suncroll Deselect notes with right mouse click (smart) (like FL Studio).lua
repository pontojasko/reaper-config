-- Description: Deselect notes with right mouse click (smart) (like FL Studio)
-- Author: Amely Suncroll

-- Official forum page: https://forum.cockos.com/showthread.php?t=291012

-- About this script: Just one click to deselect, hold to not



-- Donation: 

--          PAYPAL: https://www.paypal.com/paypalme/suncroll
-- VISA/MASTERCARD: https://www.paypal.com/ncp/payment/S8C8GEXK68TNC



-- Personal support:

--    EMAIL: amelysuncroll@gmail.com
-- TELEGRAM: https://t.me/amely_suncroll_support



-- THIS SCRIPT IS INCLUDED TO "EXCLUSIVE FL STUDIO SCRIPTS FOR REAPER DAW" PACK



if not reaper.APIExists('JS_ReaScriptAPI_Version') then
    reaper.ShowMessageBox("Requies js_ReaScriptAPI.", ":(", 0)
end

local was_right_button_pressed = false
local right_button_click_time = 0
local right_button_held_threshold = 0.2
local command_id = ({reaper.get_action_context()})[4]
local is_running = true

function check_right_click()
    local is_right_button_pressed = reaper.JS_Mouse_GetState(2) == 2
    local window, segment, details = reaper.BR_GetMouseCursorContext()
    
    if is_right_button_pressed and not was_right_button_pressed then
        right_button_click_time = reaper.time_precise()
    end
    
    if not is_right_button_pressed and was_right_button_pressed then
        local click_duration = reaper.time_precise() - right_button_click_time
        if click_duration < right_button_held_threshold then
            local midi_editor = reaper.MIDIEditor_GetActive()
            if midi_editor and segment == "notes" then
                reaper.MIDIEditor_LastFocused_OnCommand(40214, false)
            end
        end
    end
    
    was_right_button_pressed = is_right_button_pressed
end

function main()
    if not is_running then
        stop_script()
        return
    end
    check_right_click()
    reaper.defer(main)
end

function start_script()
    is_running = true
    reaper.SetToggleCommandState(0, command_id, 1)
    reaper.RefreshToolbar2(0, command_id)
    main()
end

function stop_script()
    reaper.SetToggleCommandState(0, command_id, 0)
    reaper.RefreshToolbar2(0, command_id)
    is_running = false
end

start_script()
reaper.atexit(stop_script)

