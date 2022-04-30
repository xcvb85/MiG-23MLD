var hud_radar = {
	new: func(canvasGroup, instance)
	{
		var m = { parents: [hud_radar] };
		m.group = canvasGroup;
		canvas.parsesvg(canvasGroup, "Aircraft/MiG-23MLD/Nasal/hud/hud_radar.svg");

		var svg_keys = ["horizonBar", "marker", "course", "glideslope",
						"ralt", "radar", "irst",
						"w1", "w2", "w3", "w4", "la"];
		foreach(var key; svg_keys) {
			m[key] = canvasGroup.getElementById(key);
		}
		
		m.marker.hide();
		m.course.hide();
		m.radar.hide();
		m.irst.hide();
		m.glideslope.hide();
		m.w1.hide();
		m.w2.hide();
		m.w3.hide();
		m.w4.hide();
		m.la.hide();
		
		m.roll = props.globals.getNode("orientation/roll-deg", 1);
		m.pitch = props.globals.getNode("orientation/pitch-deg", 1);
		m.altitude = props.globals.getNode("instrumentation/radar-altimeter/radar-altitude-ft", 1);
		return m;
	},
	update: func()
	{
		me.horizonBar.setRotation(me.roll.getValue()*D2R, me.horizonBar.getCenter());
		me.horizonBar.setTranslation(0, -2*me.pitch.getValue());
		me.ralt.setTranslation(0, -0.03*me.altitude.getValue());
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
