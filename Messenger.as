package  {
	import flash.display.MovieClip;
	
	/*
		This class manages messages for the player to load ('level complete')
	*/
	public class Messenger {
		
		private var main:MovieClip;
		
		public function Messenger(m:MovieClip) {
			main = m;
		}
		
		public static function alertMessage(s:String):void {
			trace("ALERT MESSAGE: " + s);
		}

	}
	
}
