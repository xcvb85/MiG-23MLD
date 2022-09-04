var hud_manual = {
	new: func(canvasGroup, instance, ag)
	{
		var m = { parents: [hud_manual] };
		m.group = canvasGroup;
		canvas.parsesvg(canvasGroup, "Aircraft/MiG-23MLD/Nasal/hud/hud_manual.svg");
		canvas.parsesvg(canvasGroup, "Aircraft/MiG-23MLD/Nasal/hud/hud_crosshairs.svg");
		m.cross = canvasGroup.getElementById("cross");
		m.cross.setTranslation(10, 10);
		m.vert = props.globals.getNode("instrumentation/hud/hud_vert", 1);
		m.horz = props.globals.getNode("instrumentation/hud/hud_horz", 1);
		
		if(!ag) {
			m.cross.hide();
		}
		return m;
	},
	update: func()
	{
		me.cross.setTranslation(2*(me.horz.getValue() or 0), 2*(me.vert.getValue() or 0));
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
