package {
	import flash.display.MovieClip;
	import flash.events.*;
	public class Main extends MovieClip {
		public var DEBUG_MODE:Number = 1; // 0: off, 1: on
		public var DEBUG_FRAME:String = "game";
		public var HITBOXES_VISIBLE:Boolean = false;
		public var TITLE_AUTOPLAY:Boolean = false;
		public var SKIP_ADS:Boolean = false;
		
		public var con:Controller;
		public var player:MovieClip, s:Statistic;
		public var transFrame:String = "load";
		public var waveHandler:WaveHandler;
		
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
			Initiates (player) statistics and sets him on the stage properly with 
			NEW stats.
		*/
		public function startPlayer():void {
			player = new Hero();
			player.loadHero(430, 320, this, new Statistic());
			characters_mc.addChild(player);
			return;
		}
		public function loadFrame():void {
			switch(currentLabel) {
				case "ads":
				
				break;
				case "title":
					new_btn.addEventListener(MouseEvent.CLICK, newTitleB);
					load_btn.addEventListener(MouseEvent.CLICK, loadTitleB);
				break;
				case "game":
					waveHandler.init();
					con = new Controller(this, "inGame"); // gameMode var
					startPlayer();
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
	}
	
}
