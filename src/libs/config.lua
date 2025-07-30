--- config.lua
--
-- This file declares both the config menu GUI and how it mutates internal mod state.

SMODS.current_mod.config = {
    -- settings go here
};

local tab_root_layout = {
    r = 0.1,
    minh = 8,
    minw = 10,
    align = 'tm',
    padding = 0.1,
    colour = G.C.BLACK,
};

local function header_text_layout(text)
    return {
        align = 'cm',
        colour = G.C.UI.TEXT_LIGHT,
        text = text,
        scale = 0.5,
    };
end

local function bind_row(fn_id)
    local text_str = localize(fn_id) .. ': ';
    local outline_colour = nil;
    local button = STATE.bind_map:get_button(fn_id);
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

function stop_listening()
    if STATE.listening == nil then
        return
    end
    local e = STATE.cfg_gui_parent.UIBox:get_UIE_by_ID(STATE.listening);
    STATE.listening = nil;
    STATE.cfg_gui_parent = nil;
    regen_bindbar(e);
end

function regen_bindbar(e)
    local button = STATE.bind_map:get_button(e.config.id);
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
                config = header_text_layout(
                    localize('keybinds')
                ),
            },
        },
    };
end

local function conf_menu()
    return {
        keybind_header(),
        {
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
        },
        bind_row("multiselect"),
        bind_row("deselect"),
        bind_row("sort_suit"),
        bind_row("sort_val"),
        bind_row("play"),
        bind_row("discard"),
        bind_row("restart"),
    };
end

function SMODS.current_mod.config_tab()
    return {
        n = G.UIT.ROOT,
        config = tab_root_layout,
        nodes = conf_menu(),
    };
end
