var HUDInstance = {};

var PageEnum = {
    crosshairs: 0,
    pipper: 1,
    radar: 2,
    ccip: 1
};

var HUD = {
    new: func(group, instance) {
        var m = {parents:[HUD], Pages:{}};
        m.Instance = instance;

        m.Pages[PageEnum.crosshairs] = hud_crosshairs.new(group.createChild('group'), instance);
#        m.Pages[PageEnum.pipper] = hud_pipper.new(group.createChild('group'), instance);
        m.Pages[PageEnum.ccip] = hud_ccip.new(group.createChild('group'), instance);
        m.Pages[PageEnum.radar] = hud_radar.new(group.createChild('group'), instance);
        m.Power = props.globals.getNode("fdm/jsbsim/electric/output/gunsight", 1);
        m.Knob = props.globals.getNode("instrumentation/hud/knob", 1);

        m.ActivatePage(1);
        m.Timer = maketimer(0.05, m, m.Update);
        m.Timer.start();
        m.group = group;
        
        # HUD .ac coords: upper-left lower-right        
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
            if(me.ActivePage != (me.Knob.getValue() or 0)+1) {
                me.ActivatePage((me.Knob.getValue() or 0)+1);
            }
            if(me.ActivePage >= 0 and me.ActivePage < 3) {
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
