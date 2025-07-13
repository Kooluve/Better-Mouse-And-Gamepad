return {
    misc = {
        dictionary = {
            -- Headers --
            tabs_features = 'Features',
            tabs_modifiers = 'Modifiers',
            tabs_gamepad = 'Gamepad',
            tabs_help = 'Help',

            -- Mouse Page 1 (Features) --
            m2_click = 'Mouse 2: Deselect all cards',
            m2_hold = 'Mouse 2 (Hold): Select multiple cards',
            m3_click = 'Mouse 3: Show menu (maps to ESC)',
            m3_hold = 'Mouse 3 (Hold): Restart (disabled by default; maps to R)',
            m_wheel_up = 'Mouse Wheel Up: Play hand',
            m_wheel_down = 'Mouse Wheel Down: Discard cards',
            m4_click = 'Mouse 4: Sort hand by suit',
            m5_click = 'Mouse 5: Sort hand by value',

            -- Mouse Page 2 (Modifiers) --
            swap_m_wheel_up_with_down = 'Invert mouse wheel direction',
            swap_m4_with_m5 = 'Swap Mouse 4 with Mouse 5',
            swap_m_wheel_with_m4_and_m5 = 'Swap Mouse 4/5 with Mouse Wheel',

            -- Gamepad --
            b_click_or_hold = 'B -> Mouse 2',
            b_click_or_hold_info = {'(See \'Mouse 2\'/\'Mouse 2 (Hold)\' in \'Features\')'},
            rightstick_click_or_hold = 'Right Joystick -> Mouse 3',
            rightstick_click_or_hold_info = {'(See \'Mouse 3\'/\'Mouse 3 (Hold)\' in \'Features\')'},
            left_shoulder_click = 'Left Shoulder -> Mouse 4',
            right_shoulder_click = 'Right Shoulder -> Mouse 5',
            swap_a_with_b = 'Swap A with B',

            -- Help Text --
            help = [[The 'Features' page allows for enabling and disabling
the basic mod functionality. All Gamepad bindings are
subject to the underlying m features they bind to.

In the original game, no matter what gamepad you use,
the confirm button is always at the bottom (e.g. Xbox 'A').
If you need to swap it (like for a Nintendo controller),
use 'Swap A & B buttons'.

Report any bugs or issues here:
https://github.com/Kooluve/Better-Mouse-And-Gamepad]],

            --to transfor:
            --1. use newlines to make width and size similar to other pages. 
            --2. delete all spaces before lines as shown above, otherwise they will be read and appear in game.
        },
    }
}
