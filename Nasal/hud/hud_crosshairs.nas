var hud_crosshairs = {
	new: func(canvasGroup, instance)
	{
		var m = { parents: [hud_crosshairs] };
		m.group = canvasGroup;
		canvas.parsesvg(canvasGroup, "Aircraft/MiG-23MLD/Nasal/hud/hud_crosshairs.svg");

		var svg_keys = ["cross"];
		foreach(var key; svg_keys) {
			m[key] = canvasGroup.getElementById(key);
		}
		m.Pitch = props.globals.getNode("fdm/jsbsim/systems/headsight/pitch-shift", 1);
		m.Yaw = props.globals.getNode("fdm/jsbsim/systems/headsight/yaw-shift", 1);
		return m;
	},
	update: func()
	{
		me.cross.setTranslation(-500*me.Yaw.getValue() or 0, 1500*me.Pitch.getValue() or 0);
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
