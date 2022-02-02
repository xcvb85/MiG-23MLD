print("** Pylon & fire control system started. **");
var pylon1 = nil; #left outboard
var pylon2 = nil; #left inboard
var pylon3 = nil; #right inboard
var pylon4 = nil; #right outboard
var pylon5 = nil; #fuselage
var pylonI = nil; #gun

var msgA = "If you need to repair now, then use Menu-Location-SelectAirport instead.";
var msgB = "Please land before changing payload.";
var msgC = "Please land before refueling.";

var cannon = stations.SubModelWeapon.new("23mm Cannon", 0.254, 510, [9], [8], props.globals.getNode("fdm/jsbsim/fcs/guntrigger",1), 0, func{return 1;}, 0);
cannon.typeShort = "GUN";
cannon.brevity = "Guns guns";

var s5l = stations.SubModelWeapon.new("UB-32", 8, 32, [14], [], props.globals.getNode("fdm/jsbsim/fcs/s5trigger",1), 1, func{return 1;}, 1);
s5l.typeShort = "S-5";
s5l.brevity = "Rockets away";
var s5r = stations.SubModelWeapon.new("UB-32", 8, 32, [15], [], props.globals.getNode("fdm/jsbsim/fcs/s5trigger",1), 1, func{return 1;}, 1);
s5r.typeShort = "S-5";
s5r.brevity = "Rockets away";

var s24a = stations.SubModelWeapon.new("S-24", 520, 1, [16], [], props.globals.getNode("fdm/jsbsim/fcs/s24atrigger",1), 1, func{return 1;}, 1);
s24a.typeShort = "S-24";
s24a.brevity = "Rockets away";
var s24b = stations.SubModelWeapon.new("S-24", 520, 1, [17], [], props.globals.getNode("fdm/jsbsim/fcs/s24btrigger",1), 1, func{return 1;}, 1);
s24b.typeShort = "S-24";
s24b.brevity = "Rockets away";
var s24c = stations.SubModelWeapon.new("S-24", 520, 1, [18], [], props.globals.getNode("fdm/jsbsim/fcs/s24ctrigger",1), 1, func{return 1;}, 1);
s24c.typeShort = "S-24";
s24c.brevity = "Rockets away";
var s24d = stations.SubModelWeapon.new("S-24", 520, 1, [19], [], props.globals.getNode("fdm/jsbsim/fcs/s24dtrigger",1), 1, func{return 1;}, 1);
s24d.typeShort = "S-24";
s24d.brevity = "Rockets away";

var fuelTank = stations.FuelTank.new("Droptank", "droptank", 3, 200, "sim/model/MiG-23MLD/stores");

var pylonSets = {
    empty: {name: "Empty", content: [], fireOrder: [], launcherDragArea: 0.0, launcherMass: 0, launcherJettisonable: 0, showLongTypeInsteadOfCount: 0, category: 1},

    fueltank: {name: "Droptank", content: [fuelTank], fireOrder: [0], launcherDragArea: 0.35, launcherMass: 531, launcherJettisonable: 1, showLongTypeInsteadOfCount: 1, category: 2},
    mm23:  {name: "23mm Cannon", content: [cannon], fireOrder: [0], launcherDragArea: 0.0, launcherMass: 0, launcherJettisonable: 0, showLongTypeInsteadOfCount: 1, category: 1},
    upk23: {name: "UPK-23", content: [], fireOrder: [], launcherDragArea: 0.0, launcherMass: 480, launcherJettisonable: 0, showLongTypeInsteadOfCount: 0, category: 1},

    # A/A weapons
    R3R:    {name: "R-3R",      content: ["R-3R"], fireOrder: [0], launcherDragArea: -0.025, launcherMass: 0, launcherJettisonable: 0, showLongTypeInsteadOfCount: 1, category: 1}, # FIXME: actual drag values
    R13M:   {name: "R-13M",     content: ["R-13M"], fireOrder: [0], launcherDragArea: -0.025, launcherMass: 0, launcherJettisonable: 0, showLongTypeInsteadOfCount: 1, category: 1}, # FIXME: actual drag values
    R24R:   {name: "R-24R",     content: ["R-24R"], fireOrder: [0], launcherDragArea: -0.06, launcherMass: 0, launcherJettisonable: 0, showLongTypeInsteadOfCount: 1, category: 1}, # FIXME: actual drag values
    R24T:   {name: "R-24T",     content: ["R-24T"], fireOrder: [0], launcherDragArea: -0.06, launcherMass: 0, launcherJettisonable: 0, showLongTypeInsteadOfCount: 1, category: 1}, # FIXME: actual drag values
    R60M:   {name: "2 x R-60M", content: ["R-60M", "R-60M"], fireOrder: [0, 1], launcherDragArea: -0.05, launcherMass: 100, launcherJettisonable: 0, showLongTypeInsteadOfCount: 0, category: 1}, # FIXME: actual drag values
    R73:    {name: "R-73",      content: ["R-73"], fireOrder: [0], launcherDragArea: -0.05, launcherMass: 0, launcherJettisonable: 0, showLongTypeInsteadOfCount: 0, category: 1}, # FIXME: actual drag values

    # A/G weapons
    ub32l: {name: "UB-32",   content: [s5l], fireOrder: [0], launcherDragArea: 0.007, launcherMass: 230, launcherJettisonable: 0, showLongTypeInsteadOfCount: 0, category: 3},
    ub32r: {name: "UB-32",   content: [s5r], fireOrder: [0], launcherDragArea: 0.007, launcherMass: 230, launcherJettisonable: 0, showLongTypeInsteadOfCount: 0, category: 3},
    s24la: {name: "S-24",    content: [s24a], fireOrder: [0], launcherDragArea: 0.007, launcherMass: 0, launcherJettisonable: 0, showLongTypeInsteadOfCount: 0, category: 3},
    s24lb: {name: "S-24",    content: [s24b], fireOrder: [0], launcherDragArea: 0.007, launcherMass: 0, launcherJettisonable: 0, showLongTypeInsteadOfCount: 0, category: 3},
    s24lc: {name: "S-24",    content: [s24c], fireOrder: [0], launcherDragArea: 0.007, launcherMass: 0, launcherJettisonable: 0, showLongTypeInsteadOfCount: 0, category: 3},
    s24ld: {name: "S-24",    content: [s24d], fireOrder: [0], launcherDragArea: 0.007, launcherMass: 0, launcherJettisonable: 0, showLongTypeInsteadOfCount: 0, category: 3},
    f500:  {name: "FAB-500", content: ["FAB-500"], fireOrder: [0], launcherDragArea: 0.005, launcherMass: 70, launcherJettisonable: 0, showLongTypeInsteadOfCount: 0, category: 3},
    r500:  {name: "RBK-500", content: ["RBK-500"], fireOrder: [0], launcherDragArea: 0.005, launcherMass: 70, launcherJettisonable: 0, showLongTypeInsteadOfCount: 0, category: 3},
};

var pylon1set = [pylonSets.empty, pylonSets.R3R, pylonSets.R13M, pylonSets.R24R, pylonSets.R24T, pylonSets.upk23, pylonSets.f500, pylonSets.r500, pylonSets.ub32l, pylonSets.s24la];
var pylon2set = [pylonSets.empty, pylonSets.R3R, pylonSets.R13M, pylonSets.R60M, pylonSets.R73, pylonSets.s24lb];
var pylon3set = [pylonSets.empty, pylonSets.fueltank];
var pylon4set = [pylonSets.empty, pylonSets.R3R, pylonSets.R13M, pylonSets.R60M, pylonSets.R73, pylonSets.s24lc];
var pylon5set = [pylonSets.empty, pylonSets.R3R, pylonSets.R13M, pylonSets.R24R, pylonSets.R24T, pylonSets.upk23, pylonSets.f500, pylonSets.r500, pylonSets.ub32r, pylonSets.s24ld];

setprop("payload/armament/fire-control/serviceable", 1);
pylon1 = stations.Pylon.new("Left wing outboard pylon (#1)",  0, [4.510, -4.511, -0.100], pylon1set,  0, props.globals.getNode("fdm/jsbsim/inertia/pointmass-weight-lbs[0]",1),props.globals.getNode("fdm/jsbsim/inertia/pointmass-dragarea-sqft[0]",1),func{return getprop("payload/armament/fire-control/serviceable") and 1;},func{return 1;});
pylon2 = stations.Pylon.new("Left wing inboard pylon (#2)",   1, [3.575, -3.309,  0.025], pylon2set,  1, props.globals.getNode("fdm/jsbsim/inertia/pointmass-weight-lbs[1]",1),props.globals.getNode("fdm/jsbsim/inertia/pointmass-dragarea-sqft[1]",1),func{return getprop("payload/armament/fire-control/serviceable") and 1;},func{return 1;});
pylon3 = stations.Pylon.new("Center Station",                 2, [2.800,  0.000, -0.700], pylon3set,  2, props.globals.getNode("fdm/jsbsim/inertia/pointmass-weight-lbs[2]",1),props.globals.getNode("fdm/jsbsim/inertia/pointmass-dragarea-sqft[2]",1),func{return getprop("payload/armament/fire-control/serviceable") and 1;},func{return 1;});
pylon4 = stations.Pylon.new("Right wing inboard pylon (#3)",  3, [3.575,  3.309,  0.025], pylon4set,  3, props.globals.getNode("fdm/jsbsim/inertia/pointmass-weight-lbs[3]",1),props.globals.getNode("fdm/jsbsim/inertia/pointmass-dragarea-sqft[3]",1),func{return getprop("payload/armament/fire-control/serviceable") and 1;},func{return 1;});
pylon5 = stations.Pylon.new("Right wing outboard pylon (#4)", 4, [4.510,  4.511, -0.100], pylon5set,  4, props.globals.getNode("fdm/jsbsim/inertia/pointmass-weight-lbs[4]",1),props.globals.getNode("fdm/jsbsim/inertia/pointmass-dragarea-sqft[4]",1),func{return getprop("payload/armament/fire-control/serviceable") and 1;},func{return 1;});
pylonI = stations.InternalStation.new("Internal gun mount", 9, [pylonSets.mm23], props.globals.getNode("fdm/jsbsim/inertia/pointmass-weight-lbs[10]",1));

pylons = [pylon1, pylon2, pylon3, pylon4, pylon5, pylonI];
fcs = fc.FireControl.new(pylons, [5, 0, 4, 1, 3], ["23mm Cannon", "R-3R", "R-13M", "R-24R", "R-24T", "R-60M", "R-73", "UB-32", "FAB-500", "RBK-500", "S-24"]);
