---------------------------------------------------------------------
--  TOGGLE BUILDER
--  Author: Marvin
--  Version: 1.1
--
--  DESCRIPTION:
--  Toggle Builder automatically generates a fully functional 2-state
--  toggle button for GrandMA2 Layout View.
--
--  It creates:
--    • A sequence with 2 cues (ON / OFF)
--    • ON cue copies the ON image → STATE image slot
--    • OFF cue copies the OFF image → STATE image slot
--    • Assigns the sequence to your chosen Executor
--    • Creates a macro that runs: Go Executor <page>.<exec>
--    • Assigns the STATE image as the macro icon automatically <- WIP!
--
--  VALIDATION:
--    • Checks if images exist
--    • Checks if macro slot is free
--    • Checks if executor is free
--    • Finds a free sequence automatically
--
--  USAGE:
--    1. Import your 3 images into the Image Pool:
--         • ON image     (example: pool #1)
--         • OFF image    (example: pool #2)
--         • STATE image  (example: pool #3)
--
--    2. Run plugin "Toggle Builder".
--    3. Enter requested values.
--
--    4. Place macro into Layout View:
--         • Visualization: Simple
--         • No need to select image — already assigned!
--
--  DONE — Your interactive toggle button works instantly.
---------------------------------------------------------------------

local function msg(text)
    gma.echo("[ToggleBuilder] " .. text)
end

---------------------------------------------------------------------
-- Helper: table length
---------------------------------------------------------------------
local function tablelength(tbl)
    local count = 0
    for _ in pairs(tbl) do count = count + 1 end
    return count
end

---------------------------------------------------------------------
-- Helper: check existing pool items
---------------------------------------------------------------------
local function exists(handle)
    return gma.show.getobj.handle(handle) ~= nil
end

---------------------------------------------------------------------
-- Macro creation (MA2-correct + safe)
---------------------------------------------------------------------
local function createMacro(macroNum, label, macroLines)
    gma.cmd('Store /o /nc Macro 1.' .. macroNum)
    gma.cmd('Label Macro 1.' .. macroNum .. ' "' .. label .. '"')

    for i = 1, tablelength(macroLines) do
        gma.cmd('Store /o /nc Macro 1.' .. macroNum .. '.' .. i)
        gma.cmd('Assign Macro 1.' .. macroNum .. '.' .. i .. ' /cmd="' .. macroLines[i] .. '"')
    end
end

---------------------------------------------------------------------
-- MAIN PLUGIN
---------------------------------------------------------------------
local function main()

    msg("Starting Toggle Builder v1.1")

    -----------------------------------------------------------------
    -- USER INPUT
    -----------------------------------------------------------------
    local name      = gma.textinput("Toggle Name", "ToggleButton")
    local page      = gma.textinput("Executor Page", "1")
    local exec      = gma.textinput("Executor Number", "101")
    local img_on    = gma.textinput("ON Image (pool #)", "1")
    local img_off   = gma.textinput("OFF Image (pool #)", "2")
    local img_state = gma.textinput("STATE Image (pool #)", "3")
    local macroNum  = gma.textinput("Macro Number", "200")

    if not name or not page or not exec or not img_on or not img_off or not img_state or not macroNum then
        msg("Cancelled by user.")
        return
    end

    -----------------------------------------------------------------
    -- VALIDATION
    -----------------------------------------------------------------

    if not exists("Image " .. img_on) then
        msg("ERROR: ON image " .. img_on .. " does not exist.")
        return
    end
    if not exists("Image " .. img_off) then
        msg("ERROR: OFF image " .. img_off .. " does not exist.")
        return
    end
    if not exists("Image " .. img_state) then
        msg("ERROR: STATE image " .. img_state .. " does not exist.")
        return
    end

    if exists("Macro 1." .. macroNum) then
        msg("ERROR: Macro 1." .. macroNum .. " already exists. Choose another.")
        return
    end

    if exists("Executor " .. page .. "." .. exec) then
        msg("ERROR: Executor " .. page .. "." .. exec .. " already in use.")
        return
    end

    -----------------------------------------------------------------
    -- FIND FREE SEQUENCE NUMBER
    -----------------------------------------------------------------
    local seq = 1
    while exists("Sequence " .. seq) do
        seq = seq + 1
    end

    msg("Using Sequence " .. seq)

    -----------------------------------------------------------------
    -- CREATE SEQUENCE & CUES
    -----------------------------------------------------------------
    gma.cmd("Store /o /nc Sequence " .. seq)
    gma.cmd('Label Sequence ' .. seq .. ' "ToggleBuilder – ' .. name .. '"')

    -- Cue 1 (ON)
    gma.cmd("Store /o /nc Sequence " .. seq .. " Cue 1")
    gma.cmd('Assign Sequence ' .. seq .. ' Cue 1 /cmd="Copy /o Image ' .. img_on .. ' At ' .. img_state .. '"')
    gma.cmd('Label Sequence ' .. seq .. ' Cue 1 "ON"')

    -- Cue 2 (OFF)
    gma.cmd("Store /o /nc Sequence " .. seq .. " Cue 2")
    gma.cmd('Assign Sequence ' .. seq .. ' Cue 2 /cmd="Copy /o Image ' .. img_off .. ' At ' .. img_state .. '"')
    gma.cmd('Label Sequence ' .. seq .. ' Cue 2 "OFF"')

    -----------------------------------------------------------------
    -- ASSIGN TO EXECUTOR
    -----------------------------------------------------------------
    gma.cmd("Assign Sequence " .. seq .. " At Executor " .. page .. "." .. exec)

    -----------------------------------------------------------------
    -- CREATE MACRO
    -----------------------------------------------------------------
    createMacro(
        tonumber(macroNum),
        "TB " .. name,
        {
            "Go Executor " .. page .. "." .. exec
        }
    )

    -----------------------------------------------------------------
    -- NEW: ASSIGN STATE IMAGE AS MACRO ICON
    -----------------------------------------------------------------
    gma.cmd('Assign /o /nc Image ' .. img_state .. ' At Macro 1.' .. macroNum)

    msg("Assigned STATE image " .. img_state .. " as macro icon.")

    -----------------------------------------------------------------
    -- DONE
    -----------------------------------------------------------------
    msg("Toggle Builder completed successfully!")
    msg("Executor: " .. page .. "." .. exec .. " | Macro: 1." .. macroNum)
end

return main
