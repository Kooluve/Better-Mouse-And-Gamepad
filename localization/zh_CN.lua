return {
    misc = {
        dictionary = {
            -- Headers --
            tabs_mouse_page_1 = '功能',
            tabs_mouse_page_2 = '修改',
            tabs_gamepad = '手柄',
            tabs_help = '帮助',

            -- Mouse Page 1 (Features) --
            right_mouse_button_click = '单击右键：取消选牌',
            right_mouse_button_hold = '长按右键：多选牌',
            middle_mouse_button_click = '单击中键：菜单（同ESC键）',
            middle_mouse_button_hold = '长按中键：快速重启（默认禁用;同R键）',
            middle_mouse_button_up = '滚轮向上：出牌',
            middle_mouse_button_down = '滚轮向下：弃牌',
            x1_click = '侧键X1：按点数理牌',
            x2_click = '侧键X2：按花色理牌',
            
            -- Mouse Page 2 (Modifiers) --
            swap_mouse_wheel_up_with_down = '交换滚轮方向',
            swap_x1_with_x2 = '交换两个侧键',
            swap_mouse_wheel_with_x1_and_x2 = '交换滚轮和侧键',

            -- Gamepad --
            b_click_or_hold = '单击或长按B键 -> 同单击或长按鼠标右键',
            b_click_or_hold_info = {'(参考\'功能\'页的\'单击右键\'/\'长按右键\')'},
            rightstick_click_or_hold = '单击或长按右摇杆 -> 同单击或长按鼠标中键',
            rightstick_click_or_hold_info = {'(参考\'功能\'页的\'单击中键\'/\'长按中键\')'},
            left_shoulder_click = '单击左肩键 -> 同鼠标侧键X1',
            right_shoulder_click = '单击右肩键 -> 同鼠标侧键X2',
            swap_a_with_b = '交换A键和B键',

            -- Help Text --
            help = [[“功能”页可以开关基础功能。
手柄的功能都是绑定到鼠标上的。

原版游戏中，不管用什么手柄，
确认键都在下方（类似Xbox），
有需要的话(如改为任天堂布局)
可以使用“交换A键和B键”选项。

提交报错或建议：
https://github.com/Kooluve/Better-Mouse-And-Gamepad]],

            --to transfor:
            --1. use newlines to make width and size similar to other pages. 
            --2. delete all spaces before lines as shown above, otherwise they will be read and appear in game.
        },
    }
}