package  {

	import flash.display.*;
	import flash.utils.*;

	/*
		Represents loot that has been dropped
	*/
	public class Loot extends MovieClip {

		protected var title:String;
		private var nukeTimer:uint;

		public function Loot(title:String) 
		{
			this.title = title;
		}

		/*
			Time until the loot removes it self
		*/
		public function timeout(main):void
		{
			nukeTimer = setTimeout(function()
			{
				main.loot_mc.removeChild(main.loot_mc.getChildByName(name));
				clearTimeout(nukeTimer);
			}, 5000);
		}

		/*Getters Setters*/
		public function getTitle():String
		{
			return title;
		}

		
	}
	
}
