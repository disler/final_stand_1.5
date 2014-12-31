package {
	import flash.display.MovieClip;
	import flash.events.*;

	public class Main extends MovieClip {
		public var DEBUG_MODE:Number = 1; // 0: off, 1: on, 2: end wave
		public var DEBUG_FRAME:String = "game";
		public var HITBOXES_VISIBLE:Boolean = false;
		public var TITLE_AUTOPLAY:Boolean = false;
		public var SKIP_ADS:Boolean = false;
		
		//represents 
		public var con:Controller;
		public var player:MovieClip;
		public var transFrame:String = "load";
		public var waveHandler:WaveHandler;

		public var utility:Utility;
		
		public var _interface:Interface;
		public var gameState:String;

		public var wasDead:Boolean = false;
		
		/*
			Begins loading process.
		*/
		public function Main() {

			stop(); 
			if(DEBUG_MODE == 0) {
				loaderInfo.addEventListener(ProgressEvent.PROGRESS, gameLoadHandler);
			} else {
				play();
				SKIP_ADS = true;
			}
			Messenger.m = this;
		}

		/*
			change the wasdead bool
		*/
		public function setWasDead(b:Boolean):void
		{
			wasDead = b;
		}


		public function changeGameState(state:String):void
		{
			gameState = state;
			con.inGameControllerFactory(state);
			_interface.interfaceStatusFactory(state);
		}


		/*
			Loads game frames			
		*/
		public function loadFrame():void {
			switch(currentLabel) {
				case "ads":
				
				break;
				case "title":
					new_btn.addEventListener(MouseEvent.CLICK, newTitleB);
					load_btn.addEventListener(MouseEvent.CLICK, loadTitleB);
				break;
				case "game":
					gameState = "inGame";
					_interface = interface_mc;

					//if we were just dead
					if(wasDead)
					{
						player.getStats().restart();
					}
					//if this is a new game
					else
					{
						utility = new Utility();
						con = new Controller(this, gameState); // gameMode var
						waveHandler.init();

						//player
						player = new Hero();
						player.loadHero(this, new Statistic(null, this));
					}
					
					_interface.LOAD(this, gameState, null);
					player.x = 430;
					player.y = 320;
					characters_mc.addChild(player);


					if(wasDead)
					{
						changeGameState("intermission");
						setWasDead(false);
					}


					if(DEBUG_MODE == 2) { waveHandler.enemySpawnTimer = 902900; waveHandler.waveComplete(); con.inGameControllerFactory("intermission"); }
				break;
				default:
					trace("Unknown frame: " + currentLabel);
				break;
			}
			return;
		}
		/*
			Transitions frame to another (black fade)
		*/
		public function trans(newFrame:String):void {
			transFrame = newFrame;
			trans_mc.gotoAndPlay(2);
			return;
		}
		/*
			Clicking new game.
		*/
		public function newTitleB(e:MouseEvent):void {
			waveHandler = new WaveHandler(this, 1);
			trans("game");
			return;
		}
		/*
			Clicking load game.
		*/
		public function loadTitleB(e:MouseEvent):void {
			// do: LOAD THE GAME 
			waveHandler = new WaveHandler(this, 1);
			trans("game");
			return;
		}
		/*
			Loads the game when data is loaded, displays load progress, and sends to ad page.
		*/
		public function gameLoadHandler(e:ProgressEvent):void {
			load_mc.bar_mc.scaleX = e.bytesLoaded / e.bytesTotal;
			if(load_mc.bar_mc.scaleX == 1.00) {
				if(TITLE_AUTOPLAY) {
					play();
					load_mc.gotoAndStop(3);
				}
				else
				load_mc.gotoAndStop(2);
			}
			return;
		}
		
		
		/*
			Returns number from 0 to num_max (not including num_max).
		*/
		public static function random(num_max:Number):Number {
			return Math.floor(Math.random() * num_max);
		}
		/*
			Returns true is x3 and y3 are within x1 to x2 and y1 to y2
		*/
		public static function inArea(x1:Number, y1:Number, x2:Number, y2:Number, x3:Number, y3:Number):Boolean {
			if(x3 >= x1 && x3 < x2) {
				if(y3 >= y1 && y3 < y2) {
					return true;
				}
			}
			return false;
		}
	}
	
}





