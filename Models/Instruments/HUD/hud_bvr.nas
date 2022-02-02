var hud_bvr = {
	new: func(canvasGroup, instance)
	{
		var m = { parents: [hud_bvr] };
		m.group = canvasGroup;
		canvas.parsesvg(canvasGroup, "Aircraft/MiG-23MLD/Models/Instruments/HUD/hud_bvr.svg");

		var svg_keys = ["horizonBar","marker1","marker2"];
		foreach(var key; svg_keys) {
			m[key] = canvasGroup.getElementById(key);
		}
		m.Rotation = props.globals.getNode("orientation/roll-deg", 1);
		m.marker1.hide();
		m.marker2.hide();
		return m;
	},
	update: func()
	{
		me.horizonBar.setRotation(me.Rotation.getValue()*D2R, me.horizonBar.getCenter());
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
