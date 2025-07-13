return {
    misc = {
        dictionary = {
            -- ヘッダー --
            tabs_features = '機能',
            tabs_modifiers = '変更',
            tabs_gamepad = 'ゲームパッド',
            tabs_help = 'ヘルプ',

            -- マウスページ1（機能） --
            deselect = '右クリック：カード選択解除',
            multiselect = '右長押し：カード複数選択',
            quick_menu = '中クリック：メニュー（ESCキー同等）',
            quick_restart = '中長押し：クイックリスタート（デフォルト無効；Rキー同等）',
            quick_play = 'ホイール上：カードを出す',
            quick_discard = 'ホイール下：カードを捨てる',
            quick_sort_suit = 'サイドボタンX1：数字で並べ替え',
            quick_sort_value = 'サイドボタンX2：スートで並べ替え',
            
            -- マウスページ2（変更） --
            swap_m_wheel_up_with_down = 'ホイール方向を反転',
            swap_m4_with_m5 = 'サイドボタンを入れ替え',
            swap_m_wheel_with_m4_and_m5 = 'ホイールとサイドボタンを入れ替え',

            -- ゲームパッド --
            b_click_or_hold = 'Bボタンクリック/長押し -> マウス右クリック/長押し同等',
            b_click_or_hold_info = {'(参考\'機能\'ページの\'右クリック\'/\'長押し右クリック\')'},
            rightstick_click_or_hold = '右スティッククリック/長押し -> マウス中クリック/長押し同等',
            rightstick_click_or_hold_info = {'(参考\'機能\'ページの\'中クリック\'/\'長押し中クリック\')'},
            left_shoulder_click = '左ショルダーボタン -> マウスサイドボタンX1同等',
            right_shoulder_click = '右ショルダーボタン -> マウスサイドボタンX2同等',
            swap_a_with_b = 'AボタンとBボタンを入れ替え',

            -- ヘルプテキスト --
            help = [[「機能」ページで基本機能のON/OFFを切り替えられます。
ゲームパッドの機能は全てマウスに紐づいています。

オリジナルゲームでは、使用するゲームパッドに関わらず
決定ボタンは下部に配置されています（Xbox風）。
任天堂レイアウト等に変更したい場合は
「AボタンとBボタンを入れ替え」オプションをご利用ください。

不具合報告やご要望はこちら：
https://github.com/Kooluve/Better-Mouse-And-Gamepad]],

            -- 翻訳時の注意:
            -- 1. 他のページと幅・サイズを合わせるため改行を使用
            -- 2. 行頭のスペースは削除（ゲーム内に表示されてしまうため）
        },
    }
}
