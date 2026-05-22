# monke-juice-N-play
# Fixation Touch Task
 
Monkey has to hold on the circle long enough to count as success.

On success, the task gives reward through `juiceBoi.m` and plays a short beep.

The circle appears at one of 9 positions from a 3x3 grid made from the actual subject screen size. It will not appear in the same grid cell on two trials in a row.

## Files

### `fixation_touch_conditions.txt`
Main conditions file for the mouse version. Load this in MonkeyLogic when we want to use the mouse as the touch equivalent.

### `fixation_touch_task.m`
Main timing script for the **mouse version**.
It uses `mouse_`, so the cursor position is treated as the response. 

### `fixation_touch_conditions_temp.txt`
Conditions file for the real touchscreen version. Load this when we want to use an actual touchscreen.

### `fixation_touch_task_temp.m`
Timing script for the real touchscreen version. It uses `touch_`, so MonkeyLogic expects touchscreen input. In MonkeyLogic, enable:


### `juiceBoi.m`

Reward helper. It opens `COM12` at `9600` baud and sends `'1'` for each reward drop (fyi change the port number). The task passes in:

`nDrops` - number of drops

`gap` - seconds between drops

`fixation_touch_conditions_cfg2.mat`

MonkeyLogic config file for this task setup. Keep it with the task files.


## Editable Parameters

`hold_time` - how long the cursor/touch must stay on the circle, in ms

`circle_radius` - size of the yellow circle, in degrees

`fix_window` - accepted response window around the circle, in degrees

`wait_for_touch` - max time to wait for a response, in ms

`beep_freq` - beep frequency, in Hz

`nDrops` - number of reward drops after success

`gap` - seconds between reward drops

## Usage

For mouse testing:

1. Load `fixation_touch_conditions.txt` in MonkeyLogic.
2. Enable `Mouse / Key` in Other device settings.
3. Run the task.
4. Move the cursor onto the yellow circle and hold it there.

For real touchscreen:

1. Load `fixation_touch_conditions_temp.txt` in MonkeyLogic.
2. Enable `Touchscreen` in Other device settings.
3. Run the task.
4. Touch and hold the yellow circle.
