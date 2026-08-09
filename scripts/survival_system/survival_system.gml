function SurvivalSystem() constructor
{
    max_vitality  = 100;
    max_hunger    = 100;
    max_hydration = 100;
    max_toxicity  = 100;
    max_stamina   = 100;

    vitality  = max_vitality;
    hunger    = max_hunger;
    hydration = max_hydration;
    toxicity  = 0;
    stamina   = max_stamina;


    hunger_drain_rate    = 0.05;
    hydration_drain_rate = 0.08;

    starvation_damage_rate = 2;
    dehydration_damage_rate = 3;

    toxicity_recovery_rate = 0.02;
    toxicity_damage_start = 60;
    toxicity_damage_rate = 2;


    // Ambient Toxicity
    toxicity_exposure_enabled = true;

    toxicity_exposure_interval_minutes =
        2 * 60;

    toxicity_exposure_amount = 5;

    toxicity_exposure_elapsed_minutes = 0;
    toxicity_last_game_timestamp = -1;

    // Prevent an extremely large load/time skip from instantly killing
    // the player. Six ticks equal twelve hours of exposure.
    toxicity_max_catchup_ticks = 6;


    stamina_drain_rate = 25;
    stamina_regen_rate = 18;
    stamina_regen_delay = 0.75;

    stamina_recovery_required = 20;

    stamina_regen_timer = 0;
    exhausted = false;
    is_dead = false;


    damage = function(_amount)
    {
        if (_amount <= 0 || is_dead)
        {
            return false;
        }

        vitality -= _amount;

        vitality =
            clamp(
                vitality,
                0,
                max_vitality
            );

        if (vitality <= 0)
        {
            vitality = 0;
            is_dead = true;
        }

        return true;
    };


    heal = function(_amount)
    {
        if (_amount <= 0 || is_dead)
        {
            return false;
        }

        vitality += _amount;

        vitality =
            clamp(
                vitality,
                0,
                max_vitality
            );

        return true;
    };


    add_hunger = function(_amount)
    {
        hunger += _amount;

        hunger =
            clamp(
                hunger,
                0,
                max_hunger
            );
    };


    add_hydration = function(_amount)
    {
        hydration += _amount;

        hydration =
            clamp(
                hydration,
                0,
                max_hydration
            );
    };


    add_toxicity = function(_amount)
    {
        toxicity += _amount;

        toxicity =
            clamp(
                toxicity,
                0,
                max_toxicity
            );
    };


    update_periodic_toxicity = function()
    {
        if (
            !variable_global_exists(
                "game_time"
            )
        )
        {
            return 0;
        }

        var _current_timestamp =
            global.game_time.get_timestamp();


        // Initialize without immediately applying exposure.
        if (
            toxicity_last_game_timestamp < 0 ||
            _current_timestamp <
            toxicity_last_game_timestamp
        )
        {
            toxicity_last_game_timestamp =
                _current_timestamp;

            return 0;
        }


        var _elapsed_minutes =
            _current_timestamp -
            toxicity_last_game_timestamp;

        toxicity_last_game_timestamp =
            _current_timestamp;


        if (!toxicity_exposure_enabled)
        {
            return 0;
        }

        if (_elapsed_minutes <= 0)
        {
            return 0;
        }


        toxicity_exposure_elapsed_minutes +=
            _elapsed_minutes;

        var _available_ticks =
            floor(
                toxicity_exposure_elapsed_minutes /
                toxicity_exposure_interval_minutes
            );

        if (_available_ticks <= 0)
        {
            return 0;
        }


        var _applied_ticks =
            min(
                _available_ticks,
                toxicity_max_catchup_ticks
            );

        // Keep only the unfinished part of the current interval.
        toxicity_exposure_elapsed_minutes =
            toxicity_exposure_elapsed_minutes mod
            toxicity_exposure_interval_minutes;

        add_toxicity(
            toxicity_exposure_amount *
            _applied_ticks
        );

        return _applied_ticks;
    };


    set_toxicity_exposure = function(_enabled)
    {
        toxicity_exposure_enabled =
            _enabled;

        if (
            variable_global_exists(
                "game_time"
            )
        )
        {
            toxicity_last_game_timestamp =
                global.game_time.get_timestamp();
        }
    };


    can_sprint = function()
    {
        return
            !is_dead &&
            !exhausted &&
            stamina > 0;
    };


    update = function(
        _delta_seconds,
        _is_moving,
        _is_sprinting
    )
    {
        if (is_dead)
        {
            return;
        }


        // Ambient Toxicity based on in-game time.
        update_periodic_toxicity();


        hunger -=
            hunger_drain_rate *
            _delta_seconds;

        hydration -=
            hydration_drain_rate *
            _delta_seconds;

        hunger =
            clamp(
                hunger,
                0,
                max_hunger
            );

        hydration =
            clamp(
                hydration,
                0,
                max_hydration
            );


        if (hunger <= 0)
        {
            damage(
                starvation_damage_rate *
                _delta_seconds
            );
        }

        if (hydration <= 0)
        {
            damage(
                dehydration_damage_rate *
                _delta_seconds
            );
        }


        if (toxicity > 0)
        {
            toxicity -=
                toxicity_recovery_rate *
                _delta_seconds;

            toxicity =
                clamp(
                    toxicity,
                    0,
                    max_toxicity
                );
        }


        if (toxicity >= toxicity_damage_start)
        {
            var _toxicity_percent =
                (
                    toxicity -
                    toxicity_damage_start
                ) /
                (
                    max_toxicity -
                    toxicity_damage_start
                );

            var _toxicity_damage =
                toxicity_damage_rate *
                max(
                    0.25,
                    _toxicity_percent
                ) *
                _delta_seconds;

            damage(
                _toxicity_damage
            );
        }


        if (
            _is_sprinting &&
            _is_moving &&
            !exhausted
        )
        {
            stamina -=
                stamina_drain_rate *
                _delta_seconds;

            stamina_regen_timer =
                stamina_regen_delay;

            if (stamina <= 0)
            {
                stamina = 0;
                exhausted = true;
            }
        }
        else
        {
            if (stamina_regen_timer > 0)
            {
                stamina_regen_timer -=
                    _delta_seconds;
            }
            else
            {
                stamina +=
                    stamina_regen_rate *
                    _delta_seconds;
            }

            stamina =
                clamp(
                    stamina,
                    0,
                    max_stamina
                );

            if (
                exhausted &&
                stamina >=
                stamina_recovery_required
            )
            {
                exhausted = false;
            }
        }
    };
}