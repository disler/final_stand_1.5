package  {
	import flash.display.MovieClip;
	import flash.utils.setTimeout;
	import flash.utils.clearTimeout;
	/*
		Handles display for user
	*/	
	public class Interface extends MovieClip {
		
		public var main:MovieClip;
		private var inGameInterfaceFocused:Number = .75;
		private var inGameInterfaceUnfocused:Number = .25;
		private var inGameInterfaceTimeout:uint;
		private var selectedArrow:Number = 0;
		private var inGameHealth:HealthBar;
		
		public function Interface() { inGameInterface_mc.visible = false; }
		
		/*
			Sets up player interface, when given the correct data
		*/
		public function LOAD(MAIN:MovieClip, GAMESTATE:String, HEALTHBAR:HealthBar):void
		{
			main = MAIN;
			inGameHealth = HEALTHBAR;
			inGameHealth.loadBar(main.player.getStats().getMaxHealth(), main.player.getStats().getHealth());
			interfaceStatusFactory(GAMESTATE);
		}
		
		/*
			Alters the state of the interface based on the gameState
		*/
		private function interfaceStatusFactory(gameState:String):void
		{
			if(gameState == "inGame")
			{
				inGameInterface_mc.visible = true;
				inGameInterface_mc.alpha = inGameInterfaceUnfocused;
				loadArrows(main.player.getStats().getEquippedArrows());
			}
		}
		
		/*
			loads the display settings for in game arrow interface
		*/
		private function  loadArrows(arr:Array):void
		{
			inGameInterface_mc.arrow1_mc.gotoAndStop(arr[0].getType());
			inGameInterface_mc.arrow2_mc.gotoAndStop(arr[1].getType());
			inGameInterface_mc.arrow3_mc.gotoAndStop(arr[2].getType());
			inGameInterface_mc.selector_mc.x = inGameInterface_mc.arrow1_mc.x;
			inGameInterface_mc.selector_mc.y = inGameInterface_mc.arrow1_mc.y;
		}
		
		/*
			When the controller selects a new arrowType
		*/
		public function toggleableArrow(slot:Number):Boolean
		{
			if(main.player.getStats().getEquippedArrows()[slot].getType() != "empty")
			{
				return true;
			}
			return false;
		}


		/*
			Toggle arrows based on arrows slot, if no arrow exists in the slot false is returned, true otherwise
		*/
		public function toggleArrow(slot:Number):Boolean
		{
			if(toggleableArrow(slot)) 
			{
				selectedArrow = slot;
				inGameInterface_mc.selector_mc.x = inGameInterface_mc["arrow" + Number(slot+1) + "_mc"].x;
				inGameInterface_mc.selector_mc.y = inGameInterface_mc["arrow" + Number(slot+1) + "_mc"].y;
				
				//set a timer to fade out after attention has left this area
				fadeInInterface();
				return true;
			}

			return false;
		}

		/*
			Makes interface fade in
		*/
		public function fadeInInterface()
		{
			inGameInterface_mc.alpha = inGameInterfaceFocused;
			clearTimeout(inGameInterfaceTimeout);
			inGameInterfaceTimeout = setTimeout(function()
									  {
										  inGameInterface_mc.alpha = inGameInterfaceUnfocused;
										  clearTimeout(inGameInterfaceTimeout);
									  }, 3000);
		}

		/*
			Returns currently selected arrow
		*/
		public function getSelectedArrow():ArrowType
		{
			return main.player.getStats().getEquippedArrows()[selectedArrow];
		}

	}
	
}