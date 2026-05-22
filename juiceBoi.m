function juiceBoi(nDrops, gap)
% Send reward pulses to the Arduino/serial reward controller on COM12.
if nargin < 1 || isempty(nDrops)
    nDrops = 5;
end
if nargin < 2 || isempty(gap)
    gap = 2;
end

nDrops = max(0, round(nDrops));
gap = max(0, gap);

try
    a = serialport("COM12", 9600);
    pause(1);

    for i = 1:nDrops
        write(a, '1', "char");
        if i < nDrops
            pause(gap);
        end
    end

    clear a;
catch reward_error
    if exist('a', 'var')
        clear a;
    end
    rethrow(reward_error);
end
end
