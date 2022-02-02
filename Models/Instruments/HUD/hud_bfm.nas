var hud_bfm = {
	new: func(canvasGroup, instance)
	{
		var m = { parents: [hud_bfm] };
		m.group = canvasGroup;
		canvas.parsesvg(canvasGroup, "Aircraft/MiG-23MLD/Models/Instruments/HUD/hud_bfm.svg");
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
