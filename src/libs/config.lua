--- config.lua
--
-- This file declares both the config menu GUI and how it mutates internal mod state.

--- Generates a UI element for binding a feature
--
-- @param fn_id the string representation of the function (e.g 'multiselect', 'deselect', etc.)
-- @return the UI element to be rendered
local function bind_row(fn_id)
    local text_str = localize(fn_id) .. ': ';
    local outline_colour = nil;
    local button = STATE.bind_map.binding_to_button[fn_id];
    if button then
        text_str = text_str .. button.button;
        if button.hold then
            text_str = text_str .. ' ' .. localize('hold');
        else
            text_str = text_str .. ' ' .. localize('click');
        end
        outline_colour = G.C.GREEN;
    else
        text_str = text_str .. localize('none');
        outline_colour = G.C.RED;
    end
    return {
        n = G.UIT.R,
        config = {
            align = 'cl',
            button = "bind_button",
            h = 0.5,
            w = 8,
            colour = G.C.BLACK,
            padding = 0.25,
            outline = 0.5,
            outline_colour = outline_colour,
            id = fn_id,
        },
        nodes = {
            {
                n = G.UIT.T,
                config = {
                    colour = G.C.UI.TEXT_LIGHT,
                    text = text_str,
                    scale = 0.4,
                },
            },
        },
    };
end

--- Generates a UI element for saving the current keybind schema
--
-- @return the UI element to be rendered
local function save_button()
    return {
        n = G.UIT.R,
        config = {
            align = 'cm',
            h = 0.25,
            w = 8,
            colour = G.C.BLACK,
        },
        nodes = {
            {
                n = G.UIT.C,
                config = {
                    align = 'cm',
                    button = "save_config",
                    h = 0.25,
                    w = 3,
                    colour = G.C.RED,
                    padding = 0.125,
                    outline = 0.5,
                    outline_colour = G.C.UI.TEXT_LIGHT,
                },
                nodes = {
                    {
                        n = G.UIT.T,
                        config = {
                            colour = G.C.UI.TEXT_LIGHT,
                            text = localize('save'),
                            scale = 0.4,
                        },
                    },
                },
            }, 
        },
    };
end

--- Saves the current `STATE.bind_map` to persistent storage
--
-- @param e the save button UI element
function G.FUNCS.save_config(e)
    MOD.config.bind_map = STATE.bind_map;
end

--- Handles the button press for the `bind_row` UI element
--
-- @param e the `bind_row` UI element
function G.FUNCS.bind_button(e)
    if
        STATE.listening and
        STATE.listening == e.config.id
    then
        STATE.listening = nil;
        STATE.cfg_gui_parent = nil;
    elseif STATE.listening then
        local old = e.parent.UIBox:get_UIE_by_ID(STATE.listening);
        old.children[1].config.text = localize(old.config.id) .. ": " .. localize('none');
        old.config.outline_colour = G.C.RED;
        old.UIBox:recalculate();

        STATE.listening = e.config.id;
    else
        STATE.listening = e.config.id;
        STATE.cfg_gui_parent = e.parent;
    end
    regen_bindbar(e);
end

--- Stops listening for bindable input; resets `bind_row` currently listening if applicable
function stop_listening()
    if STATE.listening == nil then
        return
    end
    local e = STATE.cfg_gui_parent.UIBox:get_UIE_by_ID(STATE.listening);
    STATE.listening = nil;
    STATE.cfg_gui_parent = nil;
    regen_bindbar(e);
end

--- Regenerates the contents of the `bind_row` and updates the UI.
function regen_bindbar(e)
    local button = STATE.bind_map.binding_to_button[e.config.id];
    local text = nil;
    local colour = nil;
    if STATE.listening == e.config.id then
        text = localize(e.config.id) .. ": " .. localize('listening');
        colour = G.C.BLUE;
    elseif button then
        text = localize(e.config.id) .. ": " .. button.button;
        if button.hold then
            text = text .. " " .. localize('hold');
        else
            text = text .. " " .. localize('click');
        end
        colour = G.C.GREEN;
    else
        text = localize(e.config.id) .. ": " .. localize('none');
        colour = G.C.RED;
    end
    e.children[1].config.text = text;
    e.config.outline_colour = colour;
    e.UIBox:recalculate();
end

--- The keybind menu header text UI element
local function keybind_header()
    return {
        n = G.UIT.R,
        config = {
            align = 'tm',
            r = 0.2,
            minh = 0.5,
            minw = 10,
            colour = G.C.GREY,
            padding = 0.25,
            hover = true,
            shadow = true,
        },
        nodes = {
            {
                n = G.UIT.T,
                config = {
                    align = 'cm',
                    colour = G.C.UI.TEXT_LIGHT,
                    text = localize('keybinds'),
                    scale = 0.5,
                },
            },
        },
    };
end

--- The keybind menu description text UI element
local function bind_description()
    return {
        n = G.UIT.R,
        config = {
            align = 'cm',
            padding = 0.25,
        },
        nodes = {
            {
                n = G.UIT.T,
                config = {
                    text = localize('bind_text'),
                    scale = 0.25,
                    colour = G.C.UI.TEXT_LIGHT,
                },
            },
        },
    };
end

--- Sets the mod config menu
function SMODS.current_mod.config_tab()
    return {
        n = G.UIT.ROOT,
        config = {
            r = 0.1,
            minh = 8,
            minw = 10,
            align = 'tm',
            padding = 0.1,
            colour = G.C.BLACK,
        },
        nodes = {
            keybind_header(),
            bind_description(),
            bind_row("multiselect"),
            bind_row("deselect"),
            bind_row("sort_suit"),
            bind_row("sort_val"),
            bind_row("play"),
            bind_row("discard"),
            bind_row("restart"),
            save_button(),
        },
    };
end
