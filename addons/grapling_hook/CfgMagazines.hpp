class cfgMagazines {
	class Default;
	class CA_Magazine: Default{};
	class HandGrenade: CA_Magazine{};
	class ACE_grapling_hook: HandGrenade {
		inertia = 0.4;
		initSpeed = 14;
		magazineReloadTime = 5;
		maxRange = 32;
		midRange = 11;
		minRange = 5;
		model = PATHTOF(Data\HookTest.p3d);
		displayName = "grappling hook";
		picture = PATHTOF(Data\Hooksor.paa);
		displayNameShort = "grappling hook";
		ammo = "Hook_grapling_t1";
		mass = 8;
	};
};