return {
    misc = {
        dictionary = {
            -- Headers --
            tabs_mouse_page_1 = 'Features',
            tabs_mouse_page_2 = 'Modifiers',
            tabs_gamepad = 'Gamepad',
            tabs_help = 'Help',

            -- Mouse Page 1 (Features) --
            right_mouse_button_click = 'Mouse 2: Deselect all cards',
            right_mouse_button_hold = 'Mouse 2 (Hold): Select multiple cards',
            middle_mouse_button_click = 'Mouse 3: Show menu (maps to ESC)',
            middle_mouse_button_hold = 'Mouse 3 (Hold): Restart (disabled by default; maps to R)',
            middle_mouse_button_up = 'Mouse Wheel Up: Play hand',
            middle_mouse_button_down = 'Mouse Wheel Down: Discard cards',
            x1_click = 'Mouse 4: Sort hand by suit',
            x2_click = 'Mouse 5: Sort hand by value',

            -- Mouse Page 2 (Modifiers) --
            swap_mouse_wheel_up_with_down = 'Invert mouse wheel direction',
            swap_x1_with_x2 = 'Swap Mouse 4 with Mouse 5',
            swap_mouse_wheel_with_x1_and_x2 = 'Swap Mouse 4/5 with Mouse Wheel',

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
subject to the underlying mouse features they bind to.

In the original game, no matter what gamepad you use,
the confirm button is always at the bottom (e.g. Xbox 'A'). 
If you need to swap it (like for a Nintendo controller)
, use 'Swap A & B buttons'.

Report any bugs or issues here:
https://github.com/Kooluve/Better-Mouse-And-Gamepad]],

            --to transfor:
            --1. use newlines to make width and size similar to other pages. 
            --2. delete all spaces before lines as shown above, otherwise they will be read and appear in game.
        },
    }
}
