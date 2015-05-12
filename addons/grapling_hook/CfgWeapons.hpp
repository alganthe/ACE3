class CfgWeapons {
    class GrenadeLauncher;
	class Throw: GrenadeLauncher{
		muzzles[] += {"ThrowHook"};
	  class ThrowMuzzle;
	  class ThrowHook: ThrowMuzzle {
		magazines[] = {"ACE_grapling_hook"};
		};
	};
};