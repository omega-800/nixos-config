{
  globals,
  inputs,
  config,
  pkgs,
  usr,
  sys,
  lib,
  ...
}:
let
  inherit (pkgs) nixGL;
  inherit (lib)
    concatMapStrings
    concatMapStringsSep
    genList
    mkOption
    mkIf
    types
    ;
  inherit (globals.styling) colors;
  cfg = config.u.wm.mango;

  map9 = f: concatMapStringsSep "\n" f (map toString (genList (x: x + 1) 9));
in
{
  options.u.wm.mango.enable = mkOption {
    type = types.bool;
    default = usr.wm == "mango";
  };

  imports = [ inputs.mango.hmModules.mango ];

  config = mkIf cfg.enable {
    wayland.windowManager.mango = {
      enable = true;
      settings = ''
        keymode=common
        bind=SUPER+SHIFT,r,reload_config
        bind=SUPER+SHIFT,q,quit
        bind=SUPER,q,killclient,
        bind=SUPER,Tab,focusstack,next
        bind=SUPER+SHIFT,Tab,focusstack,prev
        bind=SUPER,u,focuslast
        bind=SUPER,Left,focusdir,left
        bind=SUPER,Right,focusdir,right
        bind=SUPER,Up,focusdir,up
        bind=SUPER,Down,focusdir,down
        bind=SUPER+SHIFT,Up,exchange_client,up
        bind=SUPER+SHIFT,Down,exchange_client,down
        bind=SUPER+SHIFT,Left,exchange_client,left
        bind=SUPER+SHIFT,Right,exchange_client,right
        bind=CTRL+SHIFT,Up,smartmovewin,up
        bind=CTRL+SHIFT,Down,smartmovewin,down
        bind=CTRL+SHIFT,Left,smartmovewin,left
        bind=CTRL+SHIFT,Right,smartmovewin,right
        bind=CTRL+ALT,Up,smartresizewin,up
        bind=CTRL+ALT,Down,smartresizewin,down
        bind=CTRL+ALT,Left,smartresizewin,left
        bind=CTRL+ALT,Right,smartresizewin,right

        # switch window status
        bind=SUPER,g,toggleglobal,
        bind=ALT,Tab,toggleoverview,
        bind=ALT,backslash,togglefloating,
        bind=ALT,a,togglemaxmizescreen,
        bind=ALT,f,togglefullscreen,
        bind=ALT+SHIFT,f,togglefakefullscreen,
        bind=SUPER,i,minimized,
        bind=SUPER+SHIFT,o,toggleoverlay,
        bind=SUPER+SHIFT,I,restore_minimized
        bind=ALT,z,toggle_scratchpad

        # scroller layout
        bind=ALT,e,set_proportion,1.0
        bind=ALT,x,switch_proportion_preset,

        # tile layout
        bind=SUPER,e,incnmaster,1
        bind=SUPER,t,incnmaster,-1
        bind=ALT+SUPER,h,setmfact,-0.05
        bind=ALT+SUPER,l,setmfact,+0.05
        bind=ALT+SUPER,k,setsmfact,-0.05
        bind=ALT+SUPER,j,setsmfact,+0.05
        bind=ALT,s,zoom,

        # switch layout
        bind=CTRL+SUPER,i,setlayout,spiral
        bind=CTRL+SUPER,l,setlayout,scroller
        bind=CTRL+SUPER,r,setlayout,deck
        bind=SUPER+SHIFT,n,switch_layout

        # tag switch
        bind=SUPER,Left,viewtoleft,0
        bind=CTRL,Left,viewtoleft_have_client,0
        bind=SUPER,Right,viewtoright,0
        bind=CTRL,Right,viewtoright_have_client,0
        bind=CTRL+SUPER,Left,tagtoleft,0
        bind=CTRL+SUPER,Right,tagtoright,0

        ${map9 (i: "bind=Ctrl,KP_${i},view,${i},0")}
        ${map9 (i: "bind=Alt,KP_${i},tag,${i},0")}
        ${map9 (i: "bind=ctrl+Super,KP_${i},toggletag,${i},0")}
        ${map9 (i: "bind=Super,KP_${i},toggleview,${i},0")}

        # monitor switch
        bind=alt+shift,Left,focusmon,left
        bind=alt+shift,Right,focusmon,right
        bind=alt+shift,Up,focusmon,up
        bind=alt+shift,Down,focusmon,down
        bind=SUPER+Alt,Left,tagmon,left
        bind=SUPER+Alt,Right,tagmon,right
        bind=SUPER+Alt,Up,tagmon,up
        bind=SUPER+Alt,Down,tagmon,down

        # gaps
        bind=ALT+SHIFT,X,incgaps,1
        bind=ALT+SHIFT,Z,incgaps,-1
        bind=ALT+SHIFT,R,togglegaps

        # Mouse Button Bindings
        mousebind=SUPER,btn_left,moveresize,curmove
        mousebind=alt,btn_middle,set_proportion,0.5
        mousebind=SUPER,btn_right,moveresize,curresize
        mousebind=SUPER+CTRL,btn_left,minimized
        mousebind=SUPER+CTRL,btn_right,killclient
        mousebind=SUPER+CTRL,btn_middle,togglefullscreen
        mousebind=NONE,btn_middle,togglemaxmizescreen,0
        mousebind=NONE,btn_left,toggleoverview,-1
        mousebind=NONE,btn_right,killclient,0

        # Axis Bindings
        axisbind=SUPER,UP,viewtoleft_have_client
        axisbind=SUPER,DOWN,viewtoright_have_client
        axisbind=alt,UP,focusdir,left
        axisbind=alt,DOWN,focusdir,right
        axisbind=shift+super,UP,exchange_client,left
        axisbind=shift+super,DOWN,exchange_client,right
        axisbind=ctrl+alt,UP,increase_proportion,0.1
        axisbind=ctrl+alt,DOWN,increase_proportion,-0.1

        # Gesturebind
        gesturebind=none,left,3,focusdir,left
        gesturebind=none,right,3,focusdir,right
        gesturebind=none,up,3,focusdir,up
        gesturebind=none,down,3,focusdir,down
        gesturebind=none,left,4,viewtoleft_have_client
        gesturebind=none,right,4,viewtoright_have_client
        gesturebind=none,up,4,toggleoverview
        gesturebind=none,down,4,toggleoverview

        # namescrtachpad
        # bind=ctrl+super,h,toggle_named_scratchpad,st-yazi,none,st -c st-yazi -e yazi
        # windowrule=isnamedscratchpad:1,width:1280,height:800,appid:st-yazi

        # Effect
        blur=0
        blur_layer=1
        blur_optimized=1
        blur_params_num_passes = 2
        blur_params_radius = 5
        blur_params_noise = 0.02
        blur_params_brightness = 0.9
        blur_params_contrast = 0.9
        blur_params_saturation = 1.2

        shadows = 1
        layer_shadows = 1
        shadow_only_floating=1
        shadows_size = 12
        shadows_blur = 15
        shadows_position_x = 0
        shadows_position_y = 0
        shadowscolor= 0x000000ff

        border_radius=6
        no_radius_when_single=0
        focused_opacity=1.0
        unfocused_opacity=1.0

        # Animation Configuration
        animations=1
        layer_animations=1
        animation_type_open=zoom
        animation_type_close=slide 
        layer_animation_type_open=slide
        layer_animation_type_close=slide 
        animation_fade_in=1
        animation_fade_out=1
        tag_animation_direction=1
        zoom_initial_ratio=0.3
        zoom_end_ratio=0.7
        fadein_begin_opacity=0.6
        fadeout_begin_opacity=0.8
        # animation_duration_move=300
        # animation_duration_open=250
        # animation_duration_tag=200
        # animation_duration_close=600
        animation_duration_move=500
        animation_duration_open=400
        animation_duration_tag=350
        animation_duration_close=800
        animation_curve_open=0.46,1.0,0.29,1.1
        animation_curve_move=0.46,1.0,0.29,1
        animation_curve_tag=0.46,1.0,0.29,1
        animation_curve_close=0.08,0.92,0,1

        # Scroller Layout Setting
        scroller_structs=20
        scroller_default_proportion=0.8
        scroller_focus_center=0
        scroller_prefer_center=1
        edge_scroller_pointer_focus=1
        scroller_default_proportion_single=1.0
        scroller_proportion_preset=0.5,0.8,1.0

        # Master-Stack Layout Setting
        new_is_master=1
        smartgaps=0
        default_mfact=0.55
        default_smfact=0.55
        default_nmaster=1

        # Overview Setting
        hotarea_size=10
        enable_hotarea=1
        ov_tab_mode=0
        overviewgappi=5
        overviewgappo=30

        # Misc
        xwayland_persistence=1
        syncobj_enable=0
        no_border_when_single=0
        axis_bind_apply_timeout=100
        focus_on_activate=1
        inhibit_regardless_of_visibility=0
        sloppyfocus=1
        warpcursor=1
        focus_cross_monitor=0
        focus_cross_tag=0
        circle_layout=spiral,scroller
        enable_floating_snap=1
        snap_distance=50
        cursor_size=24
        cursor_theme=Bibata-Modern-Ice
        cursor_hide_timeout=0
        drag_tile_to_tile=0
        single_scratchpad = 1

        # keyboard
        repeat_rate=50
        repeat_delay=300
        numlockon=1
        xkb_rules_layout=ch
        xkb_rules_variant=de
        # xkb_rules_options=ctrl:nocaps
        # xkb_rules_options=grp:alt_altgr_toggle,caps:hyper

        # Trackpad 
        disable_trackpad=0
        tap_to_click=1
        tap_and_drag=1
        drag_lock=1
        mouse_natural_scrolling=0
        trackpad_natural_scrolling=0
        disable_while_typing=1
        left_handed=0
        middle_button_emulation=0
        swipe_min_threshold=1
        accel_profile=2
        accel_speed=0.0
        # scroll_button=274
        # scroll_method=1

        # Appearance
        gappih=5
        gappiv=5
        gappoh=5
        gappov=5
        scratchpad_width_ratio=0.8
        scratchpad_height_ratio=0.9
        borderpx=4
        rootcolor=0x201b14ff
        bordercolor=0x444444ff
        focuscolor=0xc9b890ff
        maxmizescreencolor=0xDA7510ff
        urgentcolor=0xad401fff
        scratchpadcolor=0xc4939dff
        globalcolor=0x8d64cfff
        overlaycolor=0x89aa61ff
      '';
      autostart_sh = ''
        ${concatMapStrings (c: c + "\n") config.u.wm.wayland.autoStart}
      '';
    };
  };
}
