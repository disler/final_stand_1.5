package  {
	import flash.display.MovieClip;
	import flash.utils.setTimeout;
	import flash.utils.clearTimeout;
	/*
		Handles display ONLY for user (place no events here, refer to controller.as for all user control)
	*/	
	public class Interface extends MovieClip {
		
		public var main:MovieClip;
		private var inGameInterfaceFocused:Number = .75;
		private var inGameInterfaceUnfocused:Number = .25;
		private var inGameInterfaceTimeout:uint;
		private var selectedArrow:Number = 0;
		private var inGameHealth:HealthBar;
		
		public function Interface() { 
			inGameInterface_mc.visible = false; 
			artifact_mc.visible = false; 
			proceed_mc.visible = false; 
		}
		
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
		public function interfaceStatusFactory(gameState:String):void
		{
			trace("gamestate: " + gameState);
			inGameInterface_mc.visible = false;
			artifact_mc.visible = false;
			proceed_mc.visible = false;
			artifact_mc.hover_mc.visible = false;

			if(gameState == "inGame")
			{
				inGameInterface_mc.visible = true;
				inGameInterface_mc.alpha = inGameInterfaceUnfocused;
				loadArrows(main.player.getStats().getEquippedArrows());
			}
			else if(gameState == "intermission")
			{
				trace("DISPLAY ALL INTERMISSION INTERFACE");
				//visibility
				artifact_mc.visible = true;
				proceed_mc.visible = true;
				artifact_mc.unequippedList_list.visible = false;

				loadArtifact();
			}
		}

		/*
			dispay hover message for in game interface, also handles positioning
		*/
		public function toggleInterfaceArtifactMessage(bool:Boolean, artifactIndex:Number):void
		{
			if(bool && artifactIndex > -1)
			{
				artifact_mc.hover_mc.visible = true;
				artifact_mc.hover_mc.x = 110;
				artifact_mc.hover_mc.y = 70;

				var artifact:Artifact = main.player.getStats().getArtifactByIndex(artifactIndex);
				artifact_mc.hover_mc.header_txt.text = 	main.utility.upperCaseFirst(artifact.getArtifact());
				artifact_mc.hover_mc.body_txt.text = 	main.utility.upperCaseFirst(artifact.getDescription());
			}
			else
			{
				artifact_mc.hover_mc.visible = false;
			}
		}


		/*
			load display for artifacts 
		*/
		public function loadArtifact():void
		{
			var artifacts:Array = main.player.getStats().getEquippedArtifacts();
			for(var i:Number = 0; i < artifacts.length; i++)
			{
				artifact_mc.artifactSquare_mc["_" + i].gotoAndStop(artifacts[i].getArtifact());
			}
		}

		/*
			close artifac tmenu
		*/
		public function closeArtifactInterface():void
		{
			artifact_mc.hover_mc.visible = false;
			artifact_mc.visible = false;
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