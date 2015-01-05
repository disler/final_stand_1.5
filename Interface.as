package  {
	import flash.display.MovieClip;
	import flash.utils.setTimeout;
	import flash.utils.clearTimeout;
	import flash.utils.*;
	import flash.events.MouseEvent;
	import flash.text.*;
	import fl.managers.StyleManager;
	import fl.controls.TextInput;


	/*
		Handles display ONLY for user (place no events here, refer to controller.as for all user control)
	*/	
	public class Interface extends MovieClip {
		
		public var main:MovieClip;
		private var inGameInterfaceFocused:Number = .80;
		private var inGameInterfaceUnfocused:Number = .45;
		private var inGameInterfaceTimeout:uint;
		private var selectedArrow:Number = 0;
		private var primaryInterface_ref:MovieClip;
		
		public function Interface() { 
			artifact_mc.visible = false; 
			proceed_mc.visible = false;
			mouse_mc.loot_mc.visible = false;
			primaryInterface_ref = primaryInterface_mc.primaryInterfaceIn_mc;
		}
		
		/*
			Sets up player interface, when given the correct data
		*/
		public function LOAD(MAIN:MovieClip, GAMESTATE:String, HEALTHBAR:HealthBar):void
		{
			main = MAIN;
			interfaceStatusFactory(GAMESTATE);
			treasure_mc.addEventListener(MouseEvent.CLICK, main.con.treasureClick);
			main.interface_mc.inGameInterface_mc.arrow1_mc.addEventListener(MouseEvent.CLICK, main.con.arrowClick);
			main.interface_mc.inGameInterface_mc.arrow2_mc.addEventListener(MouseEvent.CLICK, main.con.arrowClick);
			main.interface_mc.inGameInterface_mc.arrow3_mc.addEventListener(MouseEvent.CLICK, main.con.arrowClick);
		}
		/*
			Alters the state of the interface based on the gameState
		*/
		public function interfaceStatusFactory(gameState:String):void
		{
			artifact_mc.visible = false;
			proceed_mc.visible = false;
			proceed_mc.gotoAndStop(0);
			artifact_mc.hover_mc.visible = false;
			primaryInterface_ref.visible = false;

			if(gameState == "inGame")
			{
				inGameInterface_mc.alpha = inGameInterfaceUnfocused;
				loadArrows(main.player.getStats().getEquippedArrows());
				loadHpBar(main.player.getStats().getHealth(), main.player.getStats().getMaxHealth());
			}
			else if(gameState == "intermission")
			{
				//visibility
				proceed_mc.visible = true;
				proceed_mc.gotoAndPlay(2);
				displayPrimaryInterface();
			}
			else if(gameState == "gameOver")
			{
				
			}
			else if(gameState =="cutscene")
			{}
		}

		/*
			Animation for displaying primary interface
		*/
		public function displayPrimaryInterface():void
		{
			primaryInterface_ref.visible = true;
			primaryInterface_mc.alpha = 0;
			primaryInterface_mc.gotoAndPlay(2);
			loadPrimaryInterfaceText();
			loadCurrentBow();
			//fade in interval
			var fadeInInterval:uint = setInterval(function()
			{
				if(primaryInterface_mc.alpha > .9)
				{
					clearInterval(fadeInInterval);
				}
				else
				{
					primaryInterface_mc.alpha += .1;
				}
			}, 100);

		}

		/*
			Loads display for currently equipped bow
		*/
		public function loadCurrentBow():void
		{
			primaryInterface_mc.primaryInterfaceIn_mc.bow_mc.gotoAndStop(main.player.getStats().getBowName());
		}




		/*
			Animation for closing primary interface
		*/
		public function closePrimaryInterface():void
		{
			primaryInterface_ref = primaryInterface_mc.primaryInterfaceIn_mc;

			primaryInterface_mc.gotoAndPlay("fadeOut");

			//fade in interval
			var fadeInInterval:uint = setInterval(function()
			{
				if(primaryInterface_mc.alpha < 0)
				{
					clearInterval(fadeInInterval);
				}
				else
				{
					primaryInterface_mc.alpha -= .1;
				}
			}, 100);
		} 

		/*
			Loads display for hp
		*/
		public function loadHpBar(hp:Number, maxHp:Number):void
		{

			inGameInterface_mc.health_mc.bar_mc.scaleX = (hp / maxHp);
			inGameInterface_mc.health_mc.health_txt.text = hp.toString();
			
		}

		/*
			Display hp with new ammounts
		*/
		public function loadHpFlash(hp:Number, maxHp:Number):void
		{
			loadHpBar(hp, maxHp);
			fadeInInterface();
		}

		/*
			Display hp with no flash
		*/
		public function loadHpNoFlash(hp:Number, maxHp:Number):void
		{
			loadHpBar(hp, maxHp);
		}




		/*
			Dynamically loads text for prime interface
		*/
		public function loadPrimaryInterfaceText():void
		{
			//game stats
			primaryInterface_ref = primaryInterface_mc.primaryInterfaceIn_mc;

			primaryInterface_ref.wave_txt.text = main.player.getStats().getLevel();
			primaryInterface_ref.gold_txt.text = main.player.getStats().getGold();
			primaryInterface_ref.kills_txt.text = main.waveHandler.getKills();

			//hero stats
			primaryInterface_ref.castleHealth_txt.text 				= main.player.getStats().getMaxHealth();
			primaryInterface_ref.castleHealthRegeneration_txt.text 	= main.player.getStats().getHealthRegeneration();
			primaryInterface_ref.damage_txt.text 					= main.player.getStats().getDamage();
			primaryInterface_ref.attackSpeed_txt.text 				= main.player.getStats().getCalculatedAttackSpeed() + "%";
			primaryInterface_ref.accuracy_txt.text 					= main.player.getStats().getCalculatedAccuracy() + "%";
			primaryInterface_ref.arrowSpeed_txt.text 				= main.player.getStats().getBowSpeed();

			//bow
			primaryInterface_ref.bow_txt.text = main.utility.upperCaseFirst(main.player.getStats().getBowName());

		}


		/*
			display artifac tinterface
		*/
		public function displayArtifactInterface():void
		{
			proceed_mc.visible = false;
			artifact_mc.visible = true;
			artifact_mc.unequippedList_list.visible = false;
			loadArtifact();
		}

		/*
			dispay hover message for in game interface, also handles positioning
		*/
		public function toggleInterfaceArtifactMessage(bool:Boolean, artifactIndex:Number):void
		{
			if(bool && artifactIndex > -1)
			{
				artifact_mc.hover_mc.visible = true;
				artifact_mc.hover_mc.x = main.stage.mouseX + 20;
				artifact_mc.hover_mc.y = main.stage.mouseY + 20;

				var artifact:Artifact = main.player.getStats().getArtifactByIndex(artifactIndex);
				var artifactName:String = main.utility.upperCaseFirst(artifact.getArtifact())

				//trim to size
				if(artifactName == "Glyph of health regeneration")
				{
					artifactName = "Glyph of health regen";
				}
				artifact_mc.hover_mc.header_txt.text = artifactName;
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
			proceed_mc.visible = true;
		}
		
		/*
			loads the display settings for in game arrow interface
		*/
		public function loadArrows(arr:Array):void
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

		public function getSelectedArrowIndex():Number
		{
			return selectedArrow;
		}

	}
	
}