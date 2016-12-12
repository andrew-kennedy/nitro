function fish_right_prompt
    set -l status_copy $status
    set -l status_code $status_copy
    set -l status_color grey
    set -l duration_glyph

    switch "$status_copy"
        case 0 "$_nitro_status_last"
            set status_code
    end

    set -g _nitro_status_last $status_copy

    if test "$status_copy" -eq 0
        set duration_glyph ""
    else
        set status_color red
    end

    if test "$CMD_DURATION" -gt 250
        set -l status_string
        if test ! -z "$status_code"
            set status_string " ($status_code)"
        end

        set -l duration (echo $CMD_DURATION | humanize_duration)
        set status_string "$status_string ($duration) $duration_glyph"
        segment_right $status_color black $status_string (set_color normal)

    else
        if test ! -z "$status_code"
            segment_right $status_color black " $status_code " (set_color normal)
        end
    end

    # add fish_vi_mode segments
    if test "$fish_key_bindings" = "fish_vi_key_bindings"
      switch $fish_bind_mode
        case default
          segment_right brwhite red "[N]"
        case insert
          segment_right brwhite green "[I]"
        case replace-one
          segment_right brwhite green "[R]"
        case visual
          segment_right brwhite magenta "[V]"
      end
      set_color normal
    end
    segment_close
end
