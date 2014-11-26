package {
	import flash.display.MovieClip;
	import flash.events.*;
	public class Main extends MovieClip {
		public var transFrame:String = "load";
		public var waveHandler:WaveHandler;
		
		/*
			Begins loading process.
		*/
		public function Main() {
			stop();
			loaderInfo.addEventListener(ProgressEvent.PROGRESS, gameLoadHandler);
		}
		public function loadFrame():void {
			trace(currentLabel);
			switch(currentLabel) {
				case "ads":
				
				break;
				case "title":
					new_btn.addEventListener(MouseEvent.CLICK, newTitleB);
					load_btn.addEventListener(MouseEvent.CLICK, loadTitleB);
				break;
				case "game":
					waveHandler.init();
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
				play();
			}
			return;
		}
	}
	
}
