# MiG-23ML System Libraries
aircraft.livery.init("Aircraft/MiG-23MLD/Models/LiveriesML/");

var SweepAngles=[16,45,72]; #16=fully forward
var Sweep=0;
var SweepIndicator=0;

var wingSweep = func(direction) {
    Sweep += direction;

    if(Sweep > 2) {
        Sweep = 2;
    }
    if(Sweep < 0) {
        Sweep = 0;
    }
    SweepIndicator = Sweep-1;
    if(SweepIndicator < 0) SweepIndicator = 0;
    setprop("fdm/jsbsim/fcs/wing-sweep-cmd", (SweepAngles[Sweep]-16)/56.0);
    setprop("fdm/jsbsim/fcs/wing-sweep-indicator", SweepIndicator);
}
