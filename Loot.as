
package  {

	import flash.display.*;
	import flash.utils.*;

	/*
		Represents loot that has been dropped
	*/
	public class Loot extends MovieClip {

		protected var title:String;
		protected var type:Number;
		private var nukeTimer:uint;

		public function Loot(title:String, type:Number) 
		{
			this.title = title;
			this.type = type;
		}

		/*
			Time until the loot removes it self
		*/
		public function timeout(main:MovieClip):void
		{
			nukeTimer = setTimeout(function()
			{
				main.loot_mc.removeChild(main.loot_mc.getChildByName(name));
				clearTimeout(nukeTimer);
			}, 10000);
		}

		/*
			When clicked clear timeout
		*/
		public function clearTimeoutTimer():void
		{
			clearTimeout(nukeTimer);
		}

		/*
			Remove this movie clip
		*/
		public function remove(main:MovieClip)
		{
			clearTimeout(nukeTimer);
			main.loot_mc.removeChild(main.loot_mc.getChildByName(name));
		}

		/*Getters Setters*/
		public function getTitle():String
		{
			return title;
		}

		public function getType():Number
		{
			return type;
		}
		
		
	}
	
}
