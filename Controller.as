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
				m.stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
				m.stage.addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
				m.stage.addEventListener(MouseEvent.CLICK, stageClickHandler);
				m.stage.focus = null;
			}
			return;
		}
		/*
			Mouse is pressed anywhere
		*/
		public function stageClickHandler(e:MouseEvent):void {
			m.p.gotoAndStop("shoot");
			shootDelayTimer = setTimeout(playerShootArrow, Const.SHOOT_DELAY);
			return;
		}
		/*
			Flags Keys which are pressed
		*/
		public function playerShootArrow():void { 
			var arr:MovieClip = new Projectile();
			arr.loadProjectile(m.p.x, m.p.y, m, m.p.rotation, 5);
			m.arrows_mc.addChild(arr);
			return;
		}
		/*
			Flags Keys which are pressed
		*/
		public function keyDownHandler(e:KeyboardEvent):void {
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
			m.p.rotation = (Math.atan2(m.mouseY - m.p.y, m.mouseX - m.p.x) * (180 / Math.PI)) + 90;
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
