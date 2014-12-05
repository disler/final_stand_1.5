package  {
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.events.*;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	import fl.controls.List;
	/*
		Controls all interface, players, and clicking
	*/
	public class Controller{
		public var shootDelayTimer:uint;
		public var gameState:String = "gameStart";
		public var m:MovieClip;
		public var toggleArrowLockTimeout:uint;
		public var toggleArrowLock:Boolean = false;
		public var artifactList_ref:List;
		private var equippedArtifactSlot:Number;
		/*
			Attaches listener events
		*/
		public function Controller(M:MovieClip, _gameState:String) {
			m = M;
			inGameControllerFactory(_gameState);
		}
		/*
			Attaches listener events
		*/
		public function inGameControllerFactory(_gameState:String):void {
			//remove all events to refresh for new gameState
			m.removeEventListener(Event.ENTER_FRAME, controllerEnterFrameHandler);
			m.stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDownHandlerInGame);
			m.stage.removeEventListener(MouseEvent.CLICK, stageClickHandler);


			//in combat events
			if(_gameState == "inGame") {
				m.addEventListener(Event.ENTER_FRAME, controllerEnterFrameHandler);
				m.stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandlerInGame);
				m.stage.addEventListener(MouseEvent.CLICK, stageClickHandler);
				m.stage.focus = null;
			}

			//between wave events
			else if(_gameState == "intermission") {
				m._interface.proceed_mc.addEventListener(MouseEvent.CLICK, clickProceedToBattleEvent);
				
				//for testing
				displayArtifactInterface();
			}
			return;
		}

		/*
			Responsible for closing all intermission menus
		*/
		public function closeAllIntermissionMenus():void
		{
			closeUnequippedArtifacts();
		}

		/*
			Open artifact interface
		*/
		public function displayArtifactInterface():void
		{
			var reference:MovieClip = m._interface.artifact_mc;
			var arr:Array = m.player.getStats().getEquippedArtifacts();
			for(var i:Number = 0; i < 16; i++)
			{
				if(arr[i].getArtifact() != "locked")
				{
					reference.artifactSquare_mc["_" + i].addEventListener(MouseEvent.CLICK, clickArtifactEvent);
				}
				reference.artifactSquare_mc["_" + i].addEventListener(MouseEvent.ROLL_OVER, rollOverArtifactEvent);
				reference.artifactSquare_mc["_" + i].addEventListener(MouseEvent.ROLL_OUT, rollOutArtifactEvent);
			}


			//clear all button
			reference.clear_mc.addEventListener(MouseEvent.CLICK, clearArtifactsEvent);
			reference.auto_mc.addEventListener(MouseEvent.CLICK, autoFillArtifactsEvent);
			reference.exit_mc.addEventListener(MouseEvent.CLICK, exitArtifactInterfaceEvent);

		}

		/*
			Flags Keys which are pressed
		*/
		public function playerShootArrow():void { 
			var arr:Projectile = new Projectile();
			arr.loadProjectile(m.player.x, m.player.y, m, m.player.rotation, m.player.getStats().getDamage(), m._interface.getSelectedArrow());
			m.arrows_mc.addChild(arr);
			clearTimeout(shootDelayTimer);
			return;
		}
		
		/*	
			Click the stage and shoot an arrow in that direction
		*/
		private function stageClick():void
		{
			m.player.gotoAndStop("shoot");
			shootDelayTimer = setTimeout(playerShootArrow, Const.SHOOT_DELAY);
		}

		/*
			Proceed to the next wave
		*/
		private function clickProceedToBattle():void
		{
			closeAllIntermissionMenus();
			m.changeGameState("inGame");	
			m.waveHandler.startWave();
		}

		/*
			Click an artifact and display list
		*/
		private function clickArtifact(mc:DisplayObject):void
		{
			//display
			artifactList_ref = m._interface.artifact_mc.unequippedList_list;
			artifactList_ref.dataProvider.removeAll();
			artifactList_ref.visible = true;

			//trim slot name
			equippedArtifactSlot = Number(mc.name.split("_").join(""));

			//add labeling to list menu
			var unequippedArtifacts:Array = m.player.getStats().getUnequippedArtifacts();
			if(m.player.getStats().getEquippedArtifacts()[equippedArtifactSlot].getArtifact() != "empty")
			{
				artifactList_ref.addItem( { label : "remove" } );
			}
			for(var i:Number = 0; i < unequippedArtifacts.length; i++)
			{
				artifactList_ref.addItem( { label : unequippedArtifacts[i].getArtifact(), ind : i } );
			}

			//add event
			artifactList_ref.addEventListener(Event.CHANGE, clickUnequippedArtifactEvent);

		}

		/*
			Swap selected artifact with clicked one based on label
		*/
		public function clickUnequippedArtifact(artifactIndex:Number):void
		{

			var fromSlot = equippedArtifactSlot;
			equippedArtifactSlot = -1;

			m.player.getStats().equipArtifact(fromSlot, artifactIndex);

			closeUnequippedArtifacts();
			m._interface.loadArtifact();
		}

		/*
			Resets unequipped artifacts
		*/
		public function closeUnequippedArtifacts():void
		{
			artifactList_ref = m._interface.artifact_mc.unequippedList_list;
			artifactList_ref.visible = false;
			artifactList_ref.removeEventListener(Event.CHANGE, clickUnequippedArtifactEvent);
			artifactList_ref.dataProvider.removeAll();
		}

		/*
			Clear artifacts
		*/
		public function clearArtifacts():void
		{
			m.player.getStats().removeAllArtifacts();
			m._interface.loadArtifact();
		}

		/*
			Auto fill in artifacts
		*/
		public function autoFillArtifacts():void
		{
			m.player.getStats().autoFillArtifacts();
			m._interface.loadArtifact();
		}

		/*
			When hover over an artifact, display the hover message and contents of artifact
		*/
		public function rollOverArtifact(mc:DisplayObject):void
		{
			m._interface.toggleInterfaceArtifactMessage(true, Number(mc.name.split("_").join("")));
		}

		/*
			When you hover out an artifact, remove the hover message
		*/
		public function rollOutArtifact():void
		{
			m._interface.toggleInterfaceArtifactMessage(false, -1);
		}

		/*
			Exit artifact interface
		*/
		public function exitArtifactInterface():void
		{
			closeUnequippedArtifacts();

			var reference:MovieClip = m._interface.artifact_mc;
			reference.clear_mc.removeEventListener(MouseEvent.CLICK, clearArtifactsEvent);
			reference.auto_mc.removeEventListener(MouseEvent.CLICK, autoFillArtifactsEvent);
			reference.exit_mc.removeEventListener(MouseEvent.CLICK, exitArtifactInterfaceEvent);
			m._interface.closeArtifactInterface();
		}
		
		/*________________________________________EVENTS_________________________________________*/

		/*
			event for exiting artifact interface
		*/
		public function exitArtifactInterfaceEvent(e:Event):void
		{
			exitArtifactInterface();
		}

		/*
			event for rollling over equipped artifact
		*/
		public function rollOverArtifactEvent(e:Event):void
		{
			rollOverArtifact(e.target as DisplayObject);
		}
		
		/*
			event for rollling over equipped artifact
		*/
		public function rollOutArtifactEvent(e:Event):void
		{
			rollOutArtifact();
		}

		/*
			Event for auto filling artifacts
		*/
		public function autoFillArtifactsEvent(e:Event):void
		{
			autoFillArtifacts();
		}
		/*
			event for clearing artifacts 
		*/
		public function clearArtifactsEvent(e:Event):void
		{
			clearArtifacts();
		}

		/*
			event for clicking unequipped artifact
		*/
		public function clickUnequippedArtifactEvent(e:Event)
		{
			clickUnequippedArtifact(e.target.selectedItem.ind);
		}

		/*
			Event for clicking artifact
		*/
		public function clickArtifactEvent(e:MouseEvent):void
		{
			clickArtifact((e.target as DisplayObject));
		}

		/*
			Clicked 'proceed to battle'
		*/
		public function clickProceedToBattleEvent(e:MouseEvent):void
		{
			clickProceedToBattle();
		}

		/*
			Mouse is pressed anywhere
		*/
		public function stageClickHandler(e:MouseEvent):void {
			stageClick();
			return;
		}
		/*
			Flags Keys which are pressed
		*/
		public function keyDownHandlerInGame(e:KeyboardEvent):void {
			var canSelectArrowBool:Boolean = false;
			switch(e.keyCode)
			{
				case 81:
					canSelectArrowBool = m._interface.toggleArrow(0);
				break;
				case 87:
					canSelectArrowBool = m._interface.toggleArrow(1);
				break;
				case 69:
				 	canSelectArrowBool = m._interface.toggleArrow(2);
				break;
			}

			if(!canSelectArrowBool)
			{
				if(!toggleArrowLock)
				{
					toggleArrowLock = true;
					Messenger.alertMessage("You cannot select that");
					
					toggleArrowLockTimeout = setTimeout(function()
												{
													clearTimeout(toggleArrowLockTimeout);
													toggleArrowLock = false;
												}, Const.WARNING_MESSAGE_SPAM_TIMER);
				}
			}
			return;
		}
		/*
			Flags Keys which are released
		*/
		public function keyUpHandler(e:KeyboardEvent):void {
			return;
		}
		/*
			Controls the player on every frame.
		*/
		public function playerHandler():void {
		// Handling Rotation - SOH CAH TOA
			m.player.rotation = (Math.atan2(m.mouseY - m.player.y, m.mouseX - m.player.x) * (180 / Math.PI)) + 90;
			return;
		}
		/*
			Controls game-wide events every frame.
		*/
		public function controllerEnterFrameHandler(e:Event):void {
			playerHandler();
			return;
		}
		
		
	}
	
}
