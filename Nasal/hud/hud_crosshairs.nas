var hud_crosshairs = {
	new: func(canvasGroup, instance)
	{
		var m = { parents: [hud_crosshairs] };
		m.group = canvasGroup;
		canvas.parsesvg(canvasGroup, "Aircraft/MiG-23MLD/Nasal/hud/hud_crosshairs.svg");
		return m;
	},
	update: func()
	{
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
