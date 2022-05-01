print("** Pylon & fire control system started. **");
# launcher masses are a guess, used to identify type
var apu23 = 90;
var apu60 = 100;

var variant = getprop("/sim/variant-id");
var pylon1 = nil; #left outboard
var pylon2 = nil; #left inboard
var pylon3 = nil; #left fuselage
var pylon4 = nil; #fuselage
var pylon5 = nil; #right fuselage
var pylon6 = nil; #right inboard
var pylon7 = nil; #right outboard
var pylonI = nil; #gun

var msgA = "Please return to base.";
var msgB = "Refill complete.";

var cannon = stations.SubModelWeapon.new("23mm Cannon", 0.254, 510, [9], [8], props.globals.getNode("fdm/jsbsim/fcs/guntrigger",1), 0, func{return 1;}, 0);
cannon.typeShort = "GUN";
cannon.brevity = "Guns guns";

var s5l = stations.SubModelWeapon.new("UB-32", 8, 32, [14], [], props.globals.getNode("fdm/jsbsim/fcs/s5trigger",1), 1, func{return 1;}, 1);
s5l.typeShort = "S-5";
s5l.brevity = "Rockets away";
var s5r = stations.SubModelWeapon.new("UB-32", 8, 32, [15], [], props.globals.getNode("fdm/jsbsim/fcs/s5trigger",1), 1, func{return 1;}, 1);
s5r.typeShort = "S-5";
s5r.brevity = "Rockets away";

var fuelTank1 = stations.FuelTank.new("Droptank", "droptank", 4, 200, "sim/model/MiG-23MLD/stores");
var fuelTank2 = stations.FuelTank.new("Droptank", "droptank", 3, 200, "sim/model/MiG-23MLD/stores");
var fuelTank3 = stations.FuelTank.new("Droptank", "droptank", 5, 200, "sim/model/MiG-23MLD/stores");

var pylonSets = {
    empty: {name: "Empty", content: [], fireOrder: [], launcherDragArea: 0.0, launcherMass: 0, launcherJettisonable: 0, showLongTypeInsteadOfCount: 0, category: 1},

    fueltank1: {name: "Droptank", content: [fuelTank1], fireOrder: [0], launcherDragArea: 0.35, launcherMass: 531, launcherJettisonable: 1, showLongTypeInsteadOfCount: 1, category: 2},
    fueltank2: {name: "Droptank", content: [fuelTank2], fireOrder: [0], launcherDragArea: 0.35, launcherMass: 531, launcherJettisonable: 1, showLongTypeInsteadOfCount: 1, category: 2},
    fueltank3: {name: "Droptank", content: [fuelTank3], fireOrder: [0], launcherDragArea: 0.35, launcherMass: 531, launcherJettisonable: 1, showLongTypeInsteadOfCount: 1, category: 2},
    mm23:  {name: "23mm Cannon", content: [cannon], fireOrder: [0], launcherDragArea: 0.0, launcherMass: 0, launcherJettisonable: 0, showLongTypeInsteadOfCount: 1, category: 1},
    upk23: {name: "UPK-23", content: [], fireOrder: [], launcherDragArea: 0.0, launcherMass: 480, launcherJettisonable: 0, showLongTypeInsteadOfCount: 0, category: 1},

    # A/A weapons
    R3S:    {name: "R-3S",      content: ["R-3S"], fireOrder: [0], launcherDragArea: -0.025, launcherMass: apu23, launcherJettisonable: 0, showLongTypeInsteadOfCount: 1, category: 1}, # FIXME: actual drag values
    R13M:   {name: "R-13M",     content: ["R-13M"], fireOrder: [0], launcherDragArea: -0.025, launcherMass: apu23, launcherJettisonable: 0, showLongTypeInsteadOfCount: 1, category: 1}, # FIXME: actual drag values
    R24R:   {name: "R-24R",     content: ["R-24R"], fireOrder: [0], launcherDragArea: -0.06, launcherMass: apu23, launcherJettisonable: 0, showLongTypeInsteadOfCount: 1, category: 1}, # FIXME: actual drag values
    R24T:   {name: "R-24T",     content: ["R-24T"], fireOrder: [0], launcherDragArea: -0.06, launcherMass: apu23, launcherJettisonable: 0, showLongTypeInsteadOfCount: 1, category: 1}, # FIXME: actual drag values
    R60M:   {name: "2 x R-60M", content: ["R-60M", "R-60M"], fireOrder: [0, 1], launcherDragArea: -0.05, launcherMass: apu60, launcherJettisonable: 0, showLongTypeInsteadOfCount: 0, category: 1}, # FIXME: actual drag values
    R73:    {name: "R-73",      content: ["R-73"], fireOrder: [0], launcherDragArea: -0.05, launcherMass: 0, launcherJettisonable: 0, showLongTypeInsteadOfCount: 0, category: 1}, # FIXME: actual drag values

    # A/G weapons
    ub32l: {name: "UB-32",   content: [s5l], fireOrder: [0], launcherDragArea: 0.007, launcherMass: 230, launcherJettisonable: 0, showLongTypeInsteadOfCount: 0, category: 3},
    ub32r: {name: "UB-32",   content: [s5r], fireOrder: [0], launcherDragArea: 0.007, launcherMass: 230, launcherJettisonable: 0, showLongTypeInsteadOfCount: 0, category: 3},
    s24:   {name: "S-24",    content: ["S-24"], fireOrder: [0], launcherDragArea: 0.007, launcherMass: apu23, launcherJettisonable: 0, showLongTypeInsteadOfCount: 0, category: 3},
    kh23:  {name: "Kh-23",   content: ["Kh-23"], fireOrder: [0], launcherDragArea: -0.06, launcherMass: apu23, launcherJettisonable: 0, showLongTypeInsteadOfCount: 1, category: 3},
    f500:  {name: "FAB-500", content: ["FAB-500"], fireOrder: [0], launcherDragArea: 0.005, launcherMass: apu23, launcherJettisonable: 0, showLongTypeInsteadOfCount: 0, category: 3},
    r500:  {name: "RBK-500", content: ["RBK-500"], fireOrder: [0], launcherDragArea: 0.005, launcherMass: apu23, launcherJettisonable: 0, showLongTypeInsteadOfCount: 0, category: 3},
};

if(variant==1) {
    var pylon1set = [pylonSets.empty];
    var pylon2set = [pylonSets.empty, pylonSets.R13M, pylonSets.R24R, pylonSets.R24T, pylonSets.upk23, pylonSets.f500, pylonSets.r500, pylonSets.ub32l, pylonSets.s24, pylonSets.kh23];
    var pylon3set = [pylonSets.empty, pylonSets.R3S, pylonSets.R13M, pylonSets.R60M, pylonSets.R73, pylonSets.f500, pylonSets.s24];
    var pylon4set = [pylonSets.empty, pylonSets.fueltank1];
    var pylon5set = [pylonSets.empty, pylonSets.R3S, pylonSets.R13M, pylonSets.R60M, pylonSets.R73, pylonSets.f500, pylonSets.s24];
    var pylon6set = [pylonSets.empty, pylonSets.R13M, pylonSets.R24R, pylonSets.R24T, pylonSets.upk23, pylonSets.f500, pylonSets.r500, pylonSets.ub32r, pylonSets.s24, pylonSets.kh23];
    var pylon7set = [pylonSets.empty];
}
else {
    var pylon1set = [pylonSets.empty];
    var pylon2set = [pylonSets.empty, pylonSets.R13M, pylonSets.R24R, pylonSets.R24T, pylonSets.upk23, pylonSets.f500, pylonSets.r500, pylonSets.ub32l, pylonSets.s24, pylonSets.kh23];
    var pylon3set = [pylonSets.empty, pylonSets.R3S, pylonSets.R13M, pylonSets.R60M, pylonSets.s24];
    var pylon4set = [pylonSets.empty, pylonSets.fueltank1];
    var pylon5set = [pylonSets.empty, pylonSets.R3S, pylonSets.R13M, pylonSets.R60M, pylonSets.s24];
    var pylon6set = [pylonSets.empty, pylonSets.R13M, pylonSets.R24R, pylonSets.R24T, pylonSets.upk23, pylonSets.f500, pylonSets.r500, pylonSets.ub32r, pylonSets.s24, pylonSets.kh23];
    var pylon7set = [pylonSets.empty];
}

setprop("payload/armament/fire-control/serviceable", 1);
pylon1 = stations.Pylon.new("Left wing outboard pylon",  0, [4.510, -4.511, -0.100], pylon1set,  0, props.globals.getNode("fdm/jsbsim/inertia/pointmass-weight-lbs[0]",1),props.globals.getNode("fdm/jsbsim/inertia/pointmass-dragarea-sqft[0]",1),func{return getprop("payload/armament/fire-control/serviceable") and 1;},func{return 1;});
pylon2 = stations.Pylon.new("Left wing inboard pylon (#1)",   1, [4.510, -4.511, -0.100], pylon2set,  1, props.globals.getNode("fdm/jsbsim/inertia/pointmass-weight-lbs[1]",1),props.globals.getNode("fdm/jsbsim/inertia/pointmass-dragarea-sqft[1]",1),func{return getprop("payload/armament/fire-control/serviceable") and 1;},func{return 1;});
pylon3 = stations.Pylon.new("Left Fuselage (#3)",             2, [3.575, -3.309,  0.025], pylon3set,  2, props.globals.getNode("fdm/jsbsim/inertia/pointmass-weight-lbs[2]",1),props.globals.getNode("fdm/jsbsim/inertia/pointmass-dragarea-sqft[2]",1),func{return getprop("payload/armament/fire-control/serviceable") and 1;},func{return 1;});
pylon4 = stations.Pylon.new("Center Station",            3, [2.800,  0.000, -0.700], pylon4set,  3, props.globals.getNode("fdm/jsbsim/inertia/pointmass-weight-lbs[3]",1),props.globals.getNode("fdm/jsbsim/inertia/pointmass-dragarea-sqft[3]",1),func{return getprop("payload/armament/fire-control/serviceable") and 1;},func{return 1;});
pylon5 = stations.Pylon.new("Right Fuselage (#4)",            4, [3.575,  3.309,  0.025], pylon5set,  4, props.globals.getNode("fdm/jsbsim/inertia/pointmass-weight-lbs[4]",1),props.globals.getNode("fdm/jsbsim/inertia/pointmass-dragarea-sqft[4]",1),func{return getprop("payload/armament/fire-control/serviceable") and 1;},func{return 1;});
pylon6 = stations.Pylon.new("Right wing inboard pylon (#2)",  5, [4.510,  4.511, -0.100], pylon6set,  5, props.globals.getNode("fdm/jsbsim/inertia/pointmass-weight-lbs[5]",1),props.globals.getNode("fdm/jsbsim/inertia/pointmass-dragarea-sqft[5]",1),func{return getprop("payload/armament/fire-control/serviceable") and 1;},func{return 1;});
pylon7 = stations.Pylon.new("Right wing outboard pylon", 6, [4.510,  4.511, -0.100], pylon7set,  6, props.globals.getNode("fdm/jsbsim/inertia/pointmass-weight-lbs[6]",1),props.globals.getNode("fdm/jsbsim/inertia/pointmass-dragarea-sqft[6]",1),func{return getprop("payload/armament/fire-control/serviceable") and 1;},func{return 1;});
pylonI = stations.InternalStation.new("Internal gun mount",   7, [pylonSets.mm23], props.globals.getNode("fdm/jsbsim/inertia/pointmass-weight-lbs[10]", 1));

pylons = [pylon1, pylon2, pylon3, pylon4, pylon5, pylon6, pylon7, pylonI];
fcs = fc.FireControl.new(pylons, [7, 1, 5, 2, 4], ["23mm Cannon", "R-3S", "R-13M", "R-24R", "R-24T", "R-60M", "R-73", "UB-32", "FAB-500", "RBK-500", "S-24", "Kh-23"]);

var selectedWeapon = {};
var bore_loop = func {
    #enables firing of aim9 without radar. The aim-9 seeker will be fixed 3.5 degs below bore and any aircraft the gets near that will result in lock.
    if (fcs != nil) {
        selectedWeapon = fcs.getSelectedWeapon();
        if (selectedWeapon != nil and (selectedWeapon.type == "R-3S" or selectedWeapon.type == "R-13M" or selectedWeapon.type == "R-60M" or selectedWeapon.type == "R-73")) {
            selectedWeapon.setContacts(radar_system.getCompleteList());
            selectedWeapon.commandDir(0,-3.5);# the real is bored to -6 deg below real bore
        }
    }
    settimer(bore_loop, 0.5);
};
if (fcs!=nil) {
    bore_loop();
}

var refill_cannons = func {
    if(!getprop("payload/armament/msg") or getprop("gear/gear[0]/wow")) {
        # cannons
        setprop("ai/submodels/submodel[8]/count", 260);
        setprop("ai/submodels/submodel[9]/count", 260);
        setprop("ai/submodels/submodel[10]/count", 260);
        setprop("ai/submodels/submodel[11]/count", 260);
        setprop("ai/submodels/submodel[12]/count", 260);
        setprop("ai/submodels/submodel[13]/count", 260);
        screen.log.write(msgB, 0.5, 0.5, 1);
    }
    else {
        screen.log.write(msgA, 0.5, 0.5, 1);
    }
}

var refill_cf = func {
    if(!getprop("payload/armament/msg") or getprop("gear/gear[0]/wow")) {
        # chaffs/flares
        setprop("ai/submodels/submodel[0]/count", 40);
        setprop("ai/submodels/submodel[1]/count", 40);
        setprop("ai/submodels/submodel[2]/count", 40);
        setprop("ai/submodels/submodel[3]/count", 40);
        setprop("ai/submodels/submodel[4]/count", 40);
        setprop("ai/submodels/submodel[5]/count", 40);
        setprop("ai/submodels/submodel[6]/count", 40);
        setprop("ai/submodels/submodel[7]/count", 40);
        screen.log.write(msgB, 0.5, 0.5, 1);
    }
    else {
        screen.log.write(msgA, 0.5, 0.5, 1);
    }
}

var refill_chute = func {
    if(!getprop("payload/armament/msg") or getprop("gear/gear[0]/wow")) {
        # drag chute
        setprop("fdm/jsbsim/systems/chute/deploy-rqst", 0);
        setprop("controls/flight/chute_jettisoned", 0);
        screen.log.write(msgB, 0.5, 0.5, 1);
    }
    else {
        screen.log.write(msgA, 0.5, 0.5, 1);
    }
}

var empty = func {
    if(!getprop("payload/armament/msg") or getprop("gear/gear[0]/wow")) {
        pylon2.loadSet(pylonSets.empty);
        pylon3.loadSet(pylonSets.empty);
        pylon5.loadSet(pylonSets.empty);
        pylon6.loadSet(pylonSets.empty);
    } else {
        screen.log.write(msgA, 0.5, 0.5, 1);
    }
}

var aa_default = func {
    if(!getprop("payload/armament/msg") or getprop("gear/gear[0]/wow")) {
        pylon2.loadSet(pylonSets.R24R);
        pylon3.loadSet(pylonSets.R60M);
        pylon5.loadSet(pylonSets.R60M);
        pylon6.loadSet(pylonSets.R24T);
    } else {
        screen.log.write(msgA, 0.5, 0.5, 1);
    }
}

var aa_r3 = func {
    if(!getprop("payload/armament/msg") or getprop("gear/gear[0]/wow")) {
        pylon2.loadSet(pylonSets.R13M);
        pylon3.loadSet(pylonSets.R3S);
        pylon5.loadSet(pylonSets.R3S);
        pylon6.loadSet(pylonSets.R13M);
    } else {
        screen.log.write(msgA, 0.5, 0.5, 1);
    }
}

var ag_s5 = func {
    if(!getprop("payload/armament/msg") or getprop("gear/gear[0]/wow")) {
        pylon2.loadSet(pylonSets.ub32l);
        pylon3.loadSet(pylonSets.empty);
        pylon5.loadSet(pylonSets.empty);
        pylon6.loadSet(pylonSets.ub32r);
    } else {
        screen.log.write(msgA, 0.5, 0.5, 1);
    }
}

var ag_s24 = func {
    if(!getprop("payload/armament/msg") or getprop("gear/gear[0]/wow")) {
        pylon2.loadSet(pylonSets.s24);
        pylon3.loadSet(pylonSets.s24);
        pylon5.loadSet(pylonSets.s24);
        pylon6.loadSet(pylonSets.s24);
    } else {
        screen.log.write(msgA, 0.5, 0.5, 1);
    }
}

var ag_kh23 = func {
    if(!getprop("payload/armament/msg") or getprop("gear/gear[0]/wow")) {
        pylon2.loadSet(pylonSets.kh23);
        pylon3.loadSet(pylonSets.empty);
        pylon5.loadSet(pylonSets.empty);
        pylon6.loadSet(pylonSets.kh23);
    } else {
        screen.log.write(msgA, 0.5, 0.5, 1);
    }
}

var ag_f500 = func {
    if(!getprop("payload/armament/msg") or getprop("gear/gear[0]/wow")) {
        pylon2.loadSet(pylonSets.f500);
        pylon3.loadSet(pylonSets.f500);
        pylon5.loadSet(pylonSets.f500);
        pylon6.loadSet(pylonSets.f500);
    } else {
        screen.log.write(msgA, 0.5, 0.5, 1);
    }
}

var ag_r500 = func {
    if(!getprop("payload/armament/msg") or getprop("gear/gear[0]/wow")) {
        pylon2.loadSet(pylonSets.r500);
        pylon3.loadSet(pylonSets.empty);
        pylon5.loadSet(pylonSets.empty);
        pylon6.loadSet(pylonSets.r500);
    } else {
        screen.log.write(msgA, 0.5, 0.5, 1);
    }
}

var ag_upk23 = func {
    if(!getprop("payload/armament/msg") or getprop("gear/gear[0]/wow")) {
        pylon2.loadSet(pylonSets.upk23);
        pylon3.loadSet(pylonSets.empty);
        pylon5.loadSet(pylonSets.empty);
        pylon6.loadSet(pylonSets.upk23);
    } else {
        screen.log.write(msgA, 0.5, 0.5, 1);
    }
}
