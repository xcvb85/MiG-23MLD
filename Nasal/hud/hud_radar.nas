var hud_radar = {
	new: func(canvasGroup, instance)
	{
		var m = { parents: [hud_radar] };
		m.group = canvasGroup;
		canvas.parsesvg(canvasGroup, "Aircraft/MiG-23MLD/Nasal/hud/hud_radar.svg");

		var svg_keys = ["horizonBar", "fd", "localizer", "glideslope",
						"ralt", "radar_lock", "irst_lock", "target",
						"w1", "w2", "w3", "w4", "la", "layer1"];
		foreach(var key; svg_keys) {
			m[key] = canvasGroup.getElementById(key);
		}
		
		m.radar_lock.hide();
		m.irst_lock.hide();
		m.la.hide();
		m.target.hide();
		
		m.hud_night = props.globals.getNode("instrumentation/hud/hud_night", 1);
		
		m.p_roll = props.globals.getNode("orientation/roll-deg", 1);
		m.p_pitch = props.globals.getNode("orientation/pitch-deg", 1);
		m.p_altitude = props.globals.getNode("instrumentation/radar-altimeter/radar-altitude-ft", 1);
		
		m.p_localizer = props.globals.getNode("instrumentation/nav/in-range", 1);
		m.p_glideslope = props.globals.getNode("instrumentation/nav/has-gs", 1);
		m.p_loc_deflection = props.globals.getNode("instrumentation/nav/heading-needle-deflection-norm", 1);
		m.p_gs_deflection = props.globals.getNode("instrumentation/nav/gs-needle-deflection-norm", 1);
		
		m.p_marm = props.globals.getNode("controls/armament/master-arm", 1);
		m.p_w1 = props.globals.getNode("payload/armament/station/id-1-count", 1);
		m.p_w2 = props.globals.getNode("payload/armament/station/id-5-count", 1);
		m.p_w3 = props.globals.getNode("payload/armament/station/id-2-count", 1);
		m.p_w4 = props.globals.getNode("payload/armament/station/id-4-count", 1);
		return m;
	},
	update: func()
	{
		me.horizonBar.setRotation(me.p_roll.getValue()*D2R, me.horizonBar.getCenter());
		me.horizonBar.setTranslation(0, -2*me.p_pitch.getValue());
		me.ralt.setTranslation(0, -0.03*me.p_altitude.getValue());
		
		if(me.hud_night.getValue() or 0) {
			me.layer1.setColor(1, 1, 0);
		}
		else {
			me.layer1.setColor(0, 1, 0);
		}
		
		if(me.p_localizer.getValue()) {
			me.localizer.show();
			me.p_glideslope.getValue()?me.glideslope.show():me.glideslope.hide();
			me.fd.show();
			me.fd.setTranslation(50*me.p_loc_deflection.getValue(), -50*me.p_gs_deflection.getValue());
		}
		else {
			me.localizer.hide();
			me.fd.hide();
		}
		
		if(me.p_marm.getValue()) {
			me.p_w1.getValue()>0?me.w1.show():me.w1.hide();
			me.p_w2.getValue()>0?me.w2.show():me.w2.hide();
			me.p_w3.getValue()>0?me.w3.show():me.w3.hide();
			me.p_w4.getValue()>0?me.w4.show():me.w4.hide();
		}
		else {
			me.w1.hide();
			me.w2.hide();
			me.w3.hide();
			me.w4.hide();
		}
	},
	show: func()
	{
		me.group.show();
	},
	hide: func()
	{
		me.group.hide();
	}
};
