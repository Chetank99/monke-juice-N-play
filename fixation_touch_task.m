% -------------------------------------------------------------------------
%  EDITABLE PARAMETERS 
% -------------------------------------------------------------------------
if ~exist('editable','var')
    editable('hold_time');
    editable('circle_radius');
    editable('fix_window');
    editable('wait_for_touch');
    editable('beep_freq');
    editable('nDrops');
    editable('gap');
end

hold_time      = 500;     % required hold duration (ms) — START LOW, INCREASE
circle_radius  = 2;       % circle visual size (degrees)
fix_window     = 3;       % touch acceptance window (degrees)
wait_for_touch = 5000;    % max wait for touch (ms)
beep_freq      = 1000;    % beep frequency (Hz)
nDrops         = 5;       % number of reward drops after success
gap            = 2;       % seconds between reward drops

% -------------------------------------------------------------------------
%  NON-EDITABLE PARAMETERS
% -------------------------------------------------------------------------
p.beep_dur     = 0.15;    % beep duration (seconds)
p.beep_amp     = 0.5;     % beep amplitude (0-1)
p.iti_correct  = 1500;    % ITI after correct (ms)
p.iti_error    = 3000;    % ITI after error (ms)

% -------------------------------------------------------------------------
%  CHOOSE A RANDOM TARGET POSITION FROM A 3x3 SCREEN GRID
% -------------------------------------------------------------------------
screen_size_deg = Screen.SubjectScreenFullSize / Screen.PixelsPerDegree;
grid_x = linspace(-screen_size_deg(1) / 3, screen_size_deg(1) / 3, 3);
grid_y = linspace(-screen_size_deg(2) / 3, screen_size_deg(2) / 3, 3);
[grid_x_mesh, grid_y_mesh] = meshgrid(grid_x, grid_y);
grid_positions = [grid_x_mesh(:), grid_y_mesh(:)];

available_grid_indices = 1:size(grid_positions, 1);
if isfield(TrialRecord.User, 'last_grid_index')
    last_grid_index = TrialRecord.User.last_grid_index;
    available_grid_indices(available_grid_indices == last_grid_index) = [];
end

grid_index = available_grid_indices(randi(numel(available_grid_indices)));
p.fix_x = grid_positions(grid_index, 1);
p.fix_y = grid_positions(grid_index, 2);

TrialRecord.User.last_grid_index = grid_index;
bhv_variable('target_grid_index', grid_index, 'target_x_deg', p.fix_x, 'target_y_deg', p.fix_y);

reposition_object(1, p.fix_x, p.fix_y);
rescale_object(1, circle_radius / 2);  


sample_rate = 44100;
t = 0:1/sample_rate:p.beep_dur;
beep_wave = p.beep_amp * sin(2 * pi * beep_freq * t);


ERR_CORRECT      = 0;
ERR_NO_RESPONSE  = 1;
ERR_BREAK_FIX    = 3;


touch = SingleTarget(mouse_);  
touch.Target = [p.fix_x p.fix_y];
touch.Threshold = fix_window;

hold = WaitThenHold(touch);
hold.WaitTime = wait_for_touch;
hold.HoldTime = hold_time;

scene1 = create_scene(hold, 1);
run_scene(scene1);

% -------------------------------------------------------------------------
%  juiceBoi deciding
% -------------------------------------------------------------------------
if hold.Success
    idle(0);
    try
        juiceBoi(nDrops, gap);
    catch reward_error
        user_warning(sprintf('juiceBoi failed: %s', reward_error.message));
    end

    % Play beep
    try
        ap = audioplayer(beep_wave, sample_rate);
        playblocking(ap);
    catch
    end

    trialerror(ERR_CORRECT);
    set_iti(p.iti_correct);
else
    if hold.Waiting
        trialerror(ERR_NO_RESPONSE);
    else
        trialerror(ERR_BREAK_FIX);
    end
    set_iti(p.iti_error);
end
