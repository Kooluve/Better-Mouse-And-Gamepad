return {
    -- Default Features --
    ----------------------
    m2_click = true,
    m2_hold = true,
    m3_click = true,
    m3_hold = false,
    m_wheel_up = true,
    m_wheel_down = true,
    m4_click = true,
    m5_click = true,
    
    -- Default Modifiers --
    -----------------------
    swap_m_wheel_up_with_down = false,
    swap_m4_with_m5 = false,
    swap_m_wheel_with_m4_m5 = false,

    -- Default Gamepad Config --
    ----------------------------
    b_click_or_hold = true,
    rightstick_click_or_hold = true,
    left_shoulder_click = true,
    right_shoulder_click = true,
    swap_a_with_b = false,

    -- Mouse Map --
    ---------------
    -- If you need to change the mouse mapping, swap any of the two numbers on the left.
    -- These numbers represent the mouse button number which is pressed.
    -- i.e. `[1]` represents Mouse 1, usually the Left Mouse Button.
    mouse_map = {
        [1] = 'm1',
        [2] = 'm2',
        [3] = 'm3',
        [4] = 'm4',
        [5] = 'm5',
    },

    -- Gamepad Map --
    -----------------
    -- If you need to change the gamepad mapping, swap any of the two words on the left.
    -- These words represent the gamepad button which is pressed.
    -- i.e. `['a']` represents the A button.
    -- Triggers cannot be remapped yet, likely due to having analog values and not boolean values.
    gamepad_map = {
        ['a'] = 'a',
        ['b'] = 'b',
        ['x'] = 'x',
        ['y'] = 'y',
        ['leftshoulder'] = 'leftshoulder',
        ['rightshoulder'] = 'rightshoulder',
        ['back'] = 'back',
        ['start'] = 'start',
        ['dpleft'] = 'dpleft',
        ['dpright'] = 'dpright',
        ['dpup'] = 'dpup',
        ['dpdown'] = 'dpdown',
        ['leftstick'] = 'leftstick',
        ['rightstick'] = 'rightstick',
    },
}
