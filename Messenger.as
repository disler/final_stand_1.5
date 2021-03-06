﻿package  {
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
			_ms.y = 500 + (20 * m.utility.countChildren(m.messages_mc));
			_ms.text_mc.text_txt.text = _ms.text_mc.text2_txt.text = s;
			_ms.main = m;
			m.messages_mc.addChild(_ms);
			if(pms != null) {
				if(pms.currentFrame < 40) pms.y -= 20;
			}
			pms = _ms;
			return;
		}

		public static function lootMessage(s:String, type:Number):void
		{
			var _ms:MovieClip = new Messenger();
			_ms.x = 20;
			_ms.y = 500 + (20 * m.utility.countChildren(m.messages_mc));

			switch(type)
			{
				case Const.LOOT_MESSAGE_DEFAULT:
					_ms.text_mc.text_txt.textColor = 0xFFFF00;
				break;
				case Const.LOOT_MESSAGE_ARROW:
					_ms.text_mc.text_txt.textColor = 0x11FF11;
				break;
				case Const.LOOT_MESSAGE_BOW:
					_ms.text_mc.text_txt.textColor = 0xaaFF00;
				break;
				case Const.LOOT_MESSAGE_ARTIFACT:
					_ms.text_mc.text_txt.textColor = 0xFF22FF;
				break;
			}
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
