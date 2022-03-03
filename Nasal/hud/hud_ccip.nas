var hud_ccip = {
	new: func(canvasGroup, instance)
	{
		var m = { parents: [hud_ccip] };
		m.group = canvasGroup;
		canvas.parsesvg(canvasGroup, "Aircraft/MiG-23MLD/Nasal/hud/hud_pipper.svg");

		var svg_keys = ["cross"];
		foreach(var key; svg_keys) {
			m[key] = canvasGroup.getElementById(key);
		}
		m.Pitch = props.globals.getNode("fdm/jsbsim/systems/headsight/pitch-shift", 1);
		m.Yaw = props.globals.getNode("fdm/jsbsim/systems/headsight/yaw-shift", 1);
		m.selectedWeapon = {};
		return m;
	},
	update: func()
	{
		me.selectedWeapon = pylons.fcs.getSelectedWeapon();
		if(me.selectedWeapon != nil) {
			var ccip = me.selectedWeapon.getCCIPadv(16,0.1);
			if (ccip != nil) {
				var c = HudMath.getPosFromCoord(ccip[0]);
				print(c[0],size(c));
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
