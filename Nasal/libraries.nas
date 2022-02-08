# MiG-23MLD System Libraries
aircraft.livery.init("Aircraft/MiG-23MLD/Models/Liveries/");

var SweepAngles=[16,33,45,72]; #16=fully forward
var Sweep=0;
var SweepIndicator=0;

var engineStart = func {
    if(getprop("fdm/jsbsim/electric/output/pump") > 20 and
    getprop("fdm/jsbsim/electric/output/starterunit") > 20)
    {
        setprop("controls/engines/engine/starter", 1);
    }
}

var autostart = func {
    setprop("fdm/jsbsim/electric/switches/battery",1);
    setprop("fdm/jsbsim/electric/switches/pump",1);
    setprop("fdm/jsbsim/electric/switches/starterunit",1);
    setprop("fdm/jsbsim/electric/switches/dc-gen",1);
    setprop("fdm/jsbsim/electric/switches/ac-gen",1);
    setprop("fdm/jsbsim/fcs/wing-sweep-cmd",0);
    setprop("fdm/jsbsim/fcs/oxygen",1);
    setprop("controls/engines/engine[0]/starter", "true");
    settimer(func {
        setprop("controls/engines/engine[0]/cutoff", "false");
        setprop("fdm/jsbsim/electric/switches/gunsight",1);
        setprop("fdm/jsbsim/electric/switches/starterunit",0);
        flap_setting(2);
    }, 5);
}

var wingSweep = func(direction) {
    Sweep += direction;

    if(Sweep > 3) {
        Sweep = 3;
    }
    if(Sweep < 0) {
        Sweep = 0;
    }
    SweepIndicator = Sweep-1;
    if(SweepIndicator < 0) SweepIndicator = 0;
    setprop("fdm/jsbsim/fcs/wing-sweep-cmd", (SweepAngles[Sweep]-16)/56.0);
    setprop("fdm/jsbsim/fcs/wing-sweep-indicator", SweepIndicator);
}

var flap_setting = func(button) {
    # button 0 = off
    # button 1 = up
    # button 2 = takeoff
    # button 3 = landing
    if ( button == 0 ) {
        setprop("controls/flight/flap-panel/up",0);
        setprop("controls/flight/flap-panel/takeoff",0);
        setprop("controls/flight/flap-panel/landing",0);
    } elsif ( button == 1 and getprop("controls/flight/flap-panel/up") != 1 ) {
        setprop("controls/flight/flap-panel/up",1);
        setprop("controls/flight/flap-panel/takeoff",0);
        setprop("controls/flight/flap-panel/landing",0);
    setprop("controls/flight/flaps",0);
    } elsif ( button == 2 and getprop("controls/flight/flap-panel/takeoff") != 1 ) {
        setprop("controls/flight/flap-panel/up",0);
        setprop("controls/flight/flap-panel/takeoff",1);
        setprop("controls/flight/flap-panel/landing",0);
    setprop("controls/flight/flaps",0.5);
    } elsif ( button == 3 and getprop("controls/flight/flap-panel/landing") != 1 ) {
        setprop("controls/flight/flap-panel/up",0);
        setprop("controls/flight/flap-panel/takeoff",0);
        setprop("controls/flight/flap-panel/landing",1);
        setprop("controls/flight/flaps",1);
    }
}

var flap_keybind = func(button) {
    # button = 0 increase (flaps down)
    # button = 1 decrease (flaps up)
    if ( button == 0 ) {
        if (getprop("controls/flight/flap-panel/up")) {
            flap_setting(2);
        } elsif (getprop("controls/flight/flap-panel/takeoff")) {
            flap_setting(3);
        }
    } else {
        if (getprop("controls/flight/flap-panel/landing")) {
            flap_setting(2);
        } elsif (getprop("controls/flight/flap-panel/takeoff")) {
            flap_setting(1);
        }
    }
}

var refill = func {
    if(getprop("gear/gear[0]/wow")) {
        # drag chute
        setprop("fdm/jsbsim/systems/chute/deploy-rqst", 0);
        setprop("controls/flight/chute_jettisoned", 0);

        # chaffs/flares
        setprop("ai/submodels/submodel[0]/count", 40);
        setprop("ai/submodels/submodel[1]/count", 40);
        setprop("ai/submodels/submodel[2]/count", 40);
        setprop("ai/submodels/submodel[3]/count", 40);
        setprop("ai/submodels/submodel[4]/count", 40);
        setprop("ai/submodels/submodel[5]/count", 40);
        setprop("ai/submodels/submodel[6]/count", 40);
        setprop("ai/submodels/submodel[7]/count", 40);

        # cannons
        setprop("ai/submodels/submodel[8]/count", 260);
        setprop("ai/submodels/submodel[9]/count", 260);
        setprop("ai/submodels/submodel[10]/count", 260);
        setprop("ai/submodels/submodel[11]/count", 260);
        setprop("ai/submodels/submodel[12]/count", 260);
        setprop("ai/submodels/submodel[13]/count", 260);

        screen.log.write("refill complete", 0.5, 0.5, 1);
    }
    else {
        screen.log.write("Please return to base", 0.5, 0.5, 1);
    }
}


var ownship_pos = geo.Coord.new();
var SubSystem_Main = {
	new : func (_ident){

        var obj = { parents: [SubSystem_Main]};
        input = {
                 FrameRate                 : "/sim/frame-rate",
                 frame_rate                : "/sim/frame-rate",
                 frame_rate_worst          : "/sim/frame-rate-worst",
                 elapsed_seconds           : "/sim/time/elapsed-sec",

                 ElapsedSeconds            : "/sim/time/elapsed-sec",
                 IAS                       : "/velocities/airspeed-kt",
                 Nz                        : "/accelerations/pilot-gdamped",
                 alpha                     : "/fdm/jsbsim/aero/alpha-deg",
                 altitude_ft               : "/position/altitude-ft",
                 baro                      : "/instrumentation/altimeter/setting-hpa",
                 beta                      : "/orientation/side-slip-deg",
                 brake_parking             : "/controls/gear/brake-parking",
                 engine_n2                 : "/engines/engine[0]/n2",
                 eta_s                     : "/autopilot/route-manager/wp/eta-seconds",
                 flap_pos_deg              : "/fdm/jsbsim/fcs/flap-pos-deg",
                 gear_down                 : "/controls/gear/gear-down",
                 gmt                       : "/sim/time/gmt",
                 gmt_string                : "/sim/time/gmt-string",
                 groundspeed_kt            : "/velocities/groundspeed-kt",
                 gun_rounds                : "/sim/model/f16/systems/gun/rounds",
                 heading                   : "/orientation/heading-deg",
                 mach                      : "/instrumentation/airspeed-indicator/indicated-mach",
                 measured_altitude         : "/instrumentation/altimeter/indicated-altitude-ft",
                 pitch                     : "/orientation/pitch-deg",
                 radar_range               : "/instrumentation/radar/radar2-range",
                 nav_range                 : "/autopilot/route-manager/wp/dist",
                 roll                      : "/orientation/roll-deg",
                 route_manager_active      : "/autopilot/route-manager/active",
                 speed                     : "/fdm/jsbsim/velocities/vt-fps",
                 symbol_reject             : "/controls/HUD/sym-rej",
                 target_display            : "/sim/model/f16/instrumentation/radar-awg-9/hud/target-display",
                 v                         : "/fdm/jsbsim/velocities/v-fps",
                 vc_kts                    : "/fdm/jsbsim/velocities/vc-kts",
                 view_internal             : "/sim/current-view/internal",
                 w                         : "/fdm/jsbsim/velocities/w-fps",
                 weapon_mode               : "/sim/model/f16/controls/armament/weapon-selector",
                 wow                       : "/fdm/jsbsim/gear/wow",
                 yaw                       : "/fdm/jsbsim/aero/beta-deg",
                };

        foreach (var name; keys(input)) {
            emesary.GlobalTransmitter.NotifyAll(notifications.FrameNotificationAddProperty.new(_ident,name, input[name]));
        }

        #
        # recipient that will be registered on the global transmitter and connect this
        # subsystem to allow subsystem notifications to be received
        obj.recipient = emesary.Recipient.new(_ident~".Subsystem");
        obj.recipient.Main = obj;

        obj.recipient.Receive = func(notification)
        {
            if (notification.NotificationType == "FrameNotification")
            {
                me.Main.update(notification);
                ownship_pos.set_latlon(getprop("position/latitude-deg"), getprop("position/longitude-deg"), getprop("position/altitude-ft")*FT2M);
                notification.ownship_pos = ownship_pos;
                return emesary.Transmitter.ReceiptStatus_OK;
            }
            return emesary.Transmitter.ReceiptStatus_NotProcessed;
        };
        emesary.GlobalTransmitter.Register(obj.recipient);

		return obj;
	},
    update : func(notification) {
    },
};
subsystem = SubSystem_Main.new("SubSystem_Main");
