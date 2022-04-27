var hud_radar = {
	new: func(canvasGroup, instance)
	{
		var m = { parents: [hud_radar] };
		m.group = canvasGroup;
		canvas.parsesvg(canvasGroup, "Aircraft/MiG-23MLD/Nasal/hud/hud_radar.svg");

		var svg_keys = ["horizonBar", "marker", "course", "glideslope", "LA"];
		foreach(var key; svg_keys) {
			m[key] = canvasGroup.getElementById(key);
		}
		m.Roll = props.globals.getNode("orientation/roll-deg", 1);
		m.Pitch = props.globals.getNode("orientation/pitch-deg", 1);
		m.marker.hide();
		m.course.hide();
		m.glideslope.hide();
		m.LA.hide();
		return m;
	},
	update: func()
	{
		me.horizonBar.setRotation(me.Roll.getValue()*D2R, me.horizonBar.getCenter());
		me.horizonBar.setTranslation(0, -2*me.Pitch.getValue());
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
