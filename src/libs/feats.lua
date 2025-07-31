--- Update function for multiselect
-- Only runs when `STATE.multiselecting` is not nil.
function multiselect_hold()
    if STATE.multiselecting == true then
        STATE.multiselecting = false;
        STATE.prev_prev_target = G.CONTROLLER.hovering.prev_target;
        G.CONTROLLER.hovering.prev_target = G.CONTROLLER.hovering.target;
        G.CONTROLLER.hovering.target:click();
    elseif G.CONTROLLER.hovering.prev_target ~= G.CONTROLLER.hovering.target then
        if
            STATE.prev_prev_target == G.CONTROLLER.hovering.target and
            G.CONTROLLER.hovering.prev_target:is(Card)
        then
            G.CONTROLLER.hovering.prev_target:click();
        end
        G.CONTROLLER.hovering.target:click();
        STATE.prev_prev_target = G.CONTROLLER.hovering.prev_target;
    end
end

--- Deselects all cards currently selected
-- Deselects all cards in the current hand
function deselect_all()
    if
        G.CONTROLLER.locked or
        G.SETTINGS.paused or
        (G.play and #G.play.cards > 0) or
        (G.GAME.STOP_USE and G.GAME.STOP_USE > 0) or
        not (G.hand and G.hand.highlighted[1])
    then
        return;
    end
    G.hand:unhighlight_all();
end

--- Sorts hand by suit
-- Sorts all cards in the hand by suit
function sort_by_suit()
    if
        G.CONTROLLER.locked or
        G.SETTINGS.paused or                    -- ...if the game is paused, or...
        G.STATE ~= G.STATES.SELECTING_HAND      -- ...if not currently selecting a hand, return early.
    then
        return;
    end
    G.FUNCS.sort_hand_suit();
end

--- Sorts hand by value
-- Sorts all cards in the hand by value
function sort_by_value()
    if
        G.CONTROLLER.locked or
        G.SETTINGS.paused or                    -- ...if the game is paused, or...
        G.STATE ~= G.STATES.SELECTING_HAND      -- ...if not currently selecting a hand, return early.
    then
        return;
    end
    G.FUNCS.sort_hand_value();
end

--- Plays a selected hand
-- Plays the highlighted cards
function play_hand()
    local remaining = G.GAME.current_round.hands_left;
    print('hands left: ' .. remaining);
    if
        G.CONTROLLER.locks.frame or
        (
            G.CONTROLLER.target and                 -- ...if currently dragging a card...
            G.CONTROLLER.target.states.drag.is
        ) or
        G.SETTINGS.paused or                        -- ...if the game is paused, or...
        G.STATE ~= G.STATES.SELECTING_HAND or       -- ...if not currently selecting a hand, return early.
        G.hand.highlighted[1] == nil or
        remaining == nil or
        remaining == 0
    then
        return;
    end
    G.FUNCS.play_cards_from_highlighted();      -- else play the selected hand
end

--- Discards a selected hand
-- Discards the highlighted cards
function discard_hand()
    local remaining = G.GAME.current_round.discards_left;
    print('discards left: ' .. remaining);
    if
        G.CONTROLLER.locks.frame or
        (
            G.CONTROLLER.target and                 -- ...if currently dragging a card...
            G.CONTROLLER.target.states.drag.is
        ) or
        G.SETTINGS.paused or                        -- ...if the game is paused, or...
        G.STATE ~= G.STATES.SELECTING_HAND or       -- ...if not currently selecting a hand, return early.
        G.hand.highlighted[1] == nil or
        remaining == nil or
        remaining == 0
    then
        return;
    end
    G.FUNCS.discard_cards_from_highlighted();   -- else discard the selected hand
end

--- Restarts the current game, recalculating seed if applicable
-- Ported pretty much verbatim from the base game's `Controller:key_hold_update` method
function restart_game()
    if
        G.CONTROLLER.locked or
        G.CONTROLLER.frame_buttonpress
    then
        return;
    end
    if
        not G.GAME.won and
        not G.GAME.seeded and
        not G.GAME.challenge
    then
        G.PROFILES[G.SETTINGS.profile].high_scores.current_streak.amt = 0;
    end
    G:save_settings();
    G.SETTINGS.current_setup = 'New Run';
    G.GAME.viewed_back = nil;
    G.run_setup_seed = G.GAME.seeded;
    G.challenge_tab = G.GAME and G.GAME.challenge and G.GAME.challenge_tab or nil;
    G.forced_seed, G.setup_seed = nil, nil;
    if G.GAME.seeded then
        G.forced_seed = G.GAME.pseudorandom.seed;
    end
    G.forced_stake = G.GAME.stake
    if G.STAGE == G.STAGES.RUN then
        G.FUNCS.start_setup_run();
    end
    G.forced_stake = nil;
    G.challenge_tab = nil;
    G.forced_seed = nil;
end
