var hud_ccip = {
	new: func(canvasGroup, instance)
	{
		var m = { parents: [hud_ccip] };
		m.group = canvasGroup;
		#m.group.setTranslation(HudMath.getCenterOrigin());
		canvas.parsesvg(canvasGroup, "Aircraft/MiG-23MLD/Nasal/hud/hud_crosshairs.svg");

		var svg_keys = ["cross"];
		foreach(var key; svg_keys) {
			m[key] = canvasGroup.getElementById(key);
		}
		m.cross.hide();
		m.selectedWeapon = {};
		return m;
	},
	update: func()
	{
		me.cross.hide();
		me.selectedWeapon = pylons.fcs.getSelectedWeapon();
		if(me.selectedWeapon != nil) {
			if (me.selectedWeapon.type == "FAB-500" or me.selectedWeapon.type == "RBK-500") {
				me.ccipPos = me.selectedWeapon.getCCIPadv(16,0.1);
				if(me.ccipPos != nil) {
					me.cross.show();
					me.hud_pos = HudMath.getPosFromCoord(me.ccipPos[0]);
					me.cross.setTranslation(me.hud_pos);
					#print(me.hud_pos[0]," ",me.hud_pos[1]," ",me.hud_pos[2]," ",me.hud_pos[3]);
				}
			}
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
