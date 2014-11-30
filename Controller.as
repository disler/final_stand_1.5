package  {
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	/*
		Controls all interface, players, and clicking
	*/
	public class Controller{
		public var shootDelayTimer:uint;
		public var gameState:String = "gameStart";
		public var m:MovieClip;
		public var toggleArrowLockTimeout:uint;
		public var toggleArrowLock:Boolean = false;
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
			if(_gameState == "inGame") {
				m.addEventListener(Event.ENTER_FRAME, controllerEnterFrameHandler);
				m.stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandlerInGame);
				m.stage.addEventListener(MouseEvent.CLICK, stageClickHandler);
				m.stage.focus = null;
			}
			return;
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
		
		/*________________________________________EVENTS_________________________________________*/
		
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
