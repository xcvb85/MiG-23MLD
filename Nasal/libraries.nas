# System Libraries
var SweepAngles=[];
var Sweep=0;
var SweepIndicator=0;

if(getprop("/sim/variant-id")==1) {
    aircraft.livery.init("Aircraft/MiG-23MLD/Models/LiveriesMLD/");
    SweepAngles=[16,33,45,72]; #16=fully forward
}
else {
    aircraft.livery.init("Aircraft/MiG-23MLD/Models/LiveriesML/");
    SweepAngles=[16,45,72]; #16=fully forward
}

var wingSweep = func(direction) {
    Sweep += direction;

    if(Sweep > size(SweepAngles)-1) {
        Sweep = size(SweepAngles)-1;
    }
    if(Sweep < 0) {
        Sweep = 0;
    }
    SweepIndicator = Sweep-1;
    if(SweepIndicator < 0) SweepIndicator = 0;
    setprop("fdm/jsbsim/fcs/wing-sweep-cmd", (SweepAngles[Sweep]-16)/56.0);
    setprop("fdm/jsbsim/fcs/wing-sweep-indicator", SweepIndicator);
}

# Generic System Libraries
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
