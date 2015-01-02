
package  {

	import flash.display.*;
	import flash.utils.*;
	import flash.events.TimerEvent;

	/*
		Represents loot that has been dropped
	*/
	public class Loot extends MovieClip {

		protected var title:String;
		protected var type:Number;
		private var tier:Number;

		public var timeoutTimer:Timer;
		public var dropDuration:Number = 0;

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

			timeoutTimer = new Timer(1000, dropDuration);
			timeoutTimer.start();
			this.time_txt.text = String(dropDuration);
			timeoutTimer.addEventListener(TimerEvent.TIMER, tick);
			timeoutTimer.addEventListener(TimerEvent.TIMER_COMPLETE, 
		  	function()
		  	{
				main.loot_mc.removeChild(main.loot_mc.getChildByName(name));
				timeoutTimer.stop();
			});
		}
		
		/*
			Ticks down countdown timer for user to see on loot
		*/
		private function tick(e:TimerEvent)
		{	
			this.time_txt.text = String(Number((dropDuration - e.currentTarget.currentCount)));
		}

		/*
			When clicked clear timeout
		*/
		public function clearTimeoutTimer():void
		{
			timeoutTimer.reset();
			timeoutTimer.stop();
		}

		/*
			Remove this movie clip
		*/
		public function remove(main:MovieClip)
		{
			try {
				timeoutTimer.reset();
				timeoutTimer.stop();
				main.loot_mc.removeChild(main.loot_mc.getChildByName(name));
			} catch(e:Error) {}
		}

		/*
			Determines length
		*/
		private function countDownFactory(tier:Number):Number
		{
			var ret:Number = 0;
			switch(tier)
			{
				case 0:
					ret = 10;
				break;
				case 1:
					ret = 7;
				break;
				case 2:
					ret = 5;
				break;
				case 3:
					ret = 3;
				break;
			}
			return ret;
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

		public function getTier():Number
		{
			return tier;
		}

		public function setTier(tier:Number):void
		{
			this.tier = tier;
			dropDuration = countDownFactory(tier);
		}

		/*
			go to and play scene
		*/
		public function scene():void
		{
			trace("gotoAndStop");
			this.gotoAndStop(tier);
		}

		
	}
	
}
