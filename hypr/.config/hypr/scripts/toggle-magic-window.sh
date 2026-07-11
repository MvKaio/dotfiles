#!/bin/sh

log_file=/tmp/hypr-toggle-magic-window.log

log() {
    printf '%s %s\n' "$(date '+%F %T')" "$*" >>"$log_file"
}

workspace_selector() {
    jq -r '
        if (.name // "" | test("^[0-9]+$")) then
            (.id | tostring)
        elif (.name // "") != "" and (.name // "" | startswith("special:") | not) then
            "name:\(.name)"
        else
            empty
        end
    '
}

move_to_workspace() {
    workspace_lua=$(printf '%s' "$1" | jq -Rs .)
    hyprctl dispatch "hl.dsp.window.move({ workspace = $workspace_lua })"
}

log "---"
log "toggle requested"

active_window=$(hyprctl -j activewindow 2>&1)
active_window_status=$?
log "activewindow status=$active_window_status"
log "activewindow=$active_window"

if [ "$active_window_status" -ne 0 ]; then
    exit "$active_window_status"
fi

window_workspace=$(printf '%s' "$active_window" | jq -r '.workspace.name // empty' 2>>"$log_file")
monitor_id=$(printf '%s' "$active_window" | jq -r '.monitor // empty' 2>>"$log_file")
log "window_workspace=$window_workspace monitor_id=$monitor_id"

if [ "$window_workspace" = "special:magic" ]; then
    if [ -n "$monitor_id" ]; then
        monitors=$(hyprctl -j monitors 2>&1)
        monitors_status=$?
        log "monitors status=$monitors_status"
        log "monitors=$monitors"

        if [ "$monitors_status" -ne 0 ]; then
            exit "$monitors_status"
        fi

        target_workspace=$(
            printf '%s' "$monitors" |
                jq -r --argjson monitor "$monitor_id" '
                    .[]
                    | select(.id == $monitor)
                    | .activeWorkspace
                ' |
                workspace_selector
        )
    fi

    if [ -z "${target_workspace:-}" ]; then
        active_workspace=$(hyprctl -j activeworkspace 2>&1)
        active_workspace_status=$?
        log "activeworkspace fallback status=$active_workspace_status"
        log "activeworkspace fallback=$active_workspace"

        if [ "$active_workspace_status" -ne 0 ]; then
            exit "$active_workspace_status"
        fi

        target_workspace=$(printf '%s' "$active_workspace" | workspace_selector)
    fi

    log "target_workspace=$target_workspace"

    if [ -z "$target_workspace" ]; then
        exit 1
    fi

    move_to_workspace "$target_workspace" >>"$log_file" 2>&1
    dispatch_status=$?
    log "dispatch status=$dispatch_status command=hl.dsp.window.move({ workspace = \"$target_workspace\" })"
    exit "$dispatch_status"
fi

move_to_workspace "special:magic" >>"$log_file" 2>&1
dispatch_status=$?
log "dispatch status=$dispatch_status command=hl.dsp.window.move({ workspace = \"special:magic\" })"
exit "$dispatch_status"
