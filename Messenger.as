package  {
	import flash.display.MovieClip;
	
	/*
		This class manages messages for the player to load ('level complete')
	*/
	public class Messenger extends MovieClip {
		
		private var main:MovieClip;
		public static var m:MovieClip;
		public static var pms:MovieClip;
		
		public function Messenger() {
			
		}
		public function d() {
			main.messages_mc.removeChild(this);
		}
		
		public static function alertMessage(s:String):void {
			var _ms:MovieClip = new Messenger();
			_ms.x = 20;
			_ms.y = 500;
			_ms.text_mc.text_txt.text = _ms.text_mc.text2_txt.text = s;
			_ms.main = m;
			m.messages_mc.addChild(_ms);
			if(pms != null) {
				if(pms.currentFrame < 40) pms.y -= 20;
			}
			pms = _ms;
			return;
		}

	}
	
}
