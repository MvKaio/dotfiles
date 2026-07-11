local primary        = "rgb(7aa2f7)"
local surface        = "rgb(1a1b26)"
local secondary      = "rgb(bb9af7)"
local error_color    = "rgb(f7768e)"
local surface_lowest = "rgb(1a1b26)"

hl.config({
    general = {
        col = {
            active_border   = primary,
            inactive_border = surface,
        },
    },

    group = {
        col = {
            border_active          = secondary,
            border_inactive        = surface,
            border_locked_active   = error_color,
            border_locked_inactive = surface,
        },

        groupbar = {
            col = {
                active          = secondary,
                inactive        = surface_lowest,
                locked_active   = error_color,
                locked_inactive = surface,
            },
        },
    },
})
