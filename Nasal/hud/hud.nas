var HUDInstance = {};

var HUD = {
    new: func(group, instance) {
        var m = {parents:[HUD], Pages:{}};
        m.Instance = instance;

        m.Pages[0] = hud_pipper.new(group.createChild('group'), instance);
        m.Pages[1] = hud_crosshairs.new(group.createChild('group'), instance);
        m.Pages[2] = hud_pipper.new(group.createChild('group'), instance);
        m.Pages[3] = hud_ccip.new(group.createChild('group'), instance);
        m.Pages[4] = hud_crosshairs.new(group.createChild('group'), instance);
        m.Pages[5] = hud_ccip.new(group.createChild('group'), instance);
        m.Pages[6] = hud_radar.new(group.createChild('group'), instance);
        m.Power = props.globals.getNode("fdm/jsbsim/electric/output/gunsight", 1);
        m.Knob = props.globals.getNode("instrumentation/hud/knob", 1);
        m.HudMode = props.globals.getNode("instrumentation/hud/hud_mode", 1);
        m.TargetMode = props.globals.getNode("instrumentation/hud/target_mode", 1);
        m.Index = 0;

        m.ActivatePage(1);
        m.Timer = maketimer(0.05, m, m.Update);
        m.Timer.start();
        m.group = group;
        
        # HUD .ac coords: upper-left lower-right        
        #HudMath.init([-0.4-5.350,-0.095+0.017,0.18+0.537], [-0.4-5.350,0.065+0.017,0.02+0.537], [1024,1024], [0,1.0], [1,0.0], 0);
        HudMath.init([-3.327,-0.06948,0.4658-0.060], [-3.37518,0.06683,0.34452-0.060], [1024,1024], [0,1.0], [1,0.0], 0);
        return m;
    },
    ActivatePage: func(input = -1)
    {
        me.ActivePage = 0;
        for(var i=0; i < size(me.Pages); i=i+1) {
            if(i == input) {
                me.Pages[i].show();
                me.ActivePage = i;
            }
            else {
                me.Pages[i].hide();
            }
        }
    },
    Update: func()
    {
        if(me.Power.getValue() > 20) {
            if(me.HudMode.getValue() or 0) {
                # radar mode
                me.Index = 6;
            }
            else {
                # gunsight mode
                me.Index = (me.Knob.getValue() or 0) + 1;
                me.Index += (me.TargetMode.getValue() or 0) * 3;
            }

            if(me.ActivePage >= 0 and me.ActivePage <= 6) {
                if(me.ActivePage != me.Index) {
                    me.ActivatePage(me.Index);
                }
                me.Pages[me.ActivePage].update();
            }
            me.group.show();
        }
        else {
            me.group.hide();
        }
    }
};

var hudListener = setlistener("sim/signals/fdm-initialized", func () {

    var hudCanvas = canvas.new({
        "name": "HUD_Screen",
        "size": [1024, 1024],
        "view": [256, 256],
        "mipmapping": 1
    });
    hudCanvas.addPlacement({"node": "HUD_Screen"});
    hudCanvas.setColorBackground(0, 0, 0, 0);
    HUDInstance = HUD.new(hudCanvas.createGroup(), 0);
    removelistener(hudListener);
});
