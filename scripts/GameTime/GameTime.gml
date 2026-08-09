/// GameTime.gml

function GameTime(
    _starting_day = 1,
    _starting_hour = 6,
    _starting_minute = 0
)
constructor
{
    // ------------------------------------------------------------
    // TIME SETTINGS
    // ------------------------------------------------------------

    // One real second advances this many game minutes.
    // 1 = a complete day takes 24 real minutes.
    minutes_per_real_second = 3;
	time_multiplier = 1;

    paused = false;

    // Maximum night darkness.
    // Keep this below 1 so the world is still visible.
    maximum_darkness = 0.85;

    // Time when lighting transitions happen.
    dawn_start = 4;
    sunrise_end = 6;

    sunset_start = 17.5; // 5:30 PM
    night_start = 20.5;  // 8:30 PM

    // ------------------------------------------------------------
    // ABSOLUTE TIME
    // ------------------------------------------------------------

    var _safe_day = max(1, floor(_starting_day));
    var _safe_hour = clamp(floor(_starting_hour), 0, 23);
    var _safe_minute = clamp(floor(_starting_minute), 0, 59);

    total_minutes =
        (_safe_day - 1) * 1440 +
        _safe_hour * 60 +
        _safe_minute;

    // Fractional minutes are stored separately so the displayed
    // time remains clean and predictable.
    minute_fraction = 0;


    // ============================================================
    // UPDATE CLOCK
    // ============================================================

    static update = function(_real_seconds)
    {
        if (paused)
        {
            return;
        }

        if (_real_seconds <= 0)
        {
            return;
        }

var _minutes_to_add =
    _real_seconds *
    minutes_per_real_second *
    time_multiplier;

        minute_fraction += _minutes_to_add;

        if (minute_fraction >= 1)
        {
            var _whole_minutes =
                floor(minute_fraction);

            total_minutes += _whole_minutes;
            minute_fraction -= _whole_minutes;
        }
    };
	
	static set_time_multiplier = function(_multiplier)
{
    time_multiplier =
        max(0, _multiplier);

    return true;
};

static reset_time_multiplier = function()
{
    time_multiplier = 1;
};


    // ============================================================
    // DIRECTLY ADVANCE TIME
    // Useful for sleeping, crafting, travelling, etc.
    // ============================================================

    static add_minutes = function(_amount)
    {
        if (_amount <= 0)
        {
            return false;
        }

        total_minutes += floor(_amount);
        return true;
    };


    static add_hours = function(_amount)
    {
        return add_minutes(_amount * 60);
    };


    static add_days = function(_amount)
    {
        return add_minutes(_amount * 1440);
    };


    // ============================================================
    // CURRENT DATE AND TIME
    // ============================================================

    static get_day = function()
    {
        return floor(total_minutes / 1440) + 1;
    };


    static get_minute_of_day = function()
    {
        return total_minutes mod 1440;
    };


    static get_hour = function()
    {
        return floor(get_minute_of_day() / 60);
    };


    static get_minute = function()
    {
        return get_minute_of_day() mod 60;
    };


    static get_hour_decimal = function()
    {
        return get_hour() + get_minute() / 60;
    };


    static get_timestamp = function()
    {
        return total_minutes;
    };


    // ============================================================
    // FUTURE TIMESTAMP
    // Creates a completion time for crops, crafting, etc.
    // ============================================================

    static create_timestamp = function(_minutes_from_now)
    {
        return total_minutes + max(0, _minutes_from_now);
    };


    static timestamp_reached = function(_timestamp)
    {
        return total_minutes >= _timestamp;
    };


    static minutes_until = function(_timestamp)
    {
        return max(
            0,
            _timestamp - total_minutes
        );
    };


    // ============================================================
    // LIGHTING
    // ============================================================

    static get_darkness = function()
    {
        var _hour = get_hour_decimal();

        // Deep night
        if (_hour < dawn_start)
        {
            return maximum_darkness;
        }

        // Dawn: gradually become brighter.
        if (_hour < sunrise_end)
        {
            var _dawn_progress =
                (_hour - dawn_start) /
                (sunrise_end - dawn_start);

            return lerp(
                maximum_darkness,
                0,
                _dawn_progress
            );
        }

        // Daytime
        if (_hour < sunset_start)
        {
            return 0;
        }

        // Dusk: gradually become darker.
        if (_hour < night_start)
        {
            var _dusk_progress =
                (_hour - sunset_start) /
                (night_start - sunset_start);

            return lerp(
                0,
                maximum_darkness,
                _dusk_progress
            );
        }

        // Night
        return maximum_darkness;
    };


    // ============================================================
    // DISPLAY STRING
    // Example: Day 3 - 07:05 PM
    // ============================================================

    static get_time_string = function()
    {
        var _hour = get_hour();
        var _minute = get_minute();

        var _suffix =
            (_hour >= 12) ? "PM" : "AM";

        var _display_hour = _hour mod 12;

        if (_display_hour == 0)
        {
            _display_hour = 12;
        }

        var _minute_text = string(_minute);

        if (_minute < 10)
        {
            _minute_text =
                "0" + _minute_text;
        }

        return
            "Day " +
            string(get_day()) +
            "  " +
            string(_display_hour) +
            ":" +
            _minute_text +
            " " +
            _suffix;
    };
}