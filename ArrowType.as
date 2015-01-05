package  {
	
	/*
		Represents an arrow
	*/
	public class ArrowType {
		
		private var type:String;
		private var description:String;
		private var damage:Number;
		private var speed:Number;
		private var accuracy:Number;
		private var waitTime:Number;
		private var effects:Array = [];

		public function ArrowType(TYPE:String) {
			type = TYPE;
			arrowStatsFactory(type);
		}
		
		
		private function arrowStatsFactory(type:String):void
		{
			switch(type)
			{
				case "wooden arrow":
					description = Const.ITEM_DESCRIPTION[type];
					damage = 0;//is not base damage (added to hero damage)
					speed = 11;//is base speed
					accuracy = 5;//0 is perfect accuracy, the higher the worse
					waitTime = 1;//1 second wait time
					effects = [];//specifies arrow constants
				break;
				case "steel arrow"://increase damage
					description = Const.ITEM_DESCRIPTION[type];
					damage = 1;
					speed = 9;
					accuracy = 10;
					waitTime = 2;
					effects = [];
				break;
				case "mithril arrow"://increase damage
					description = Const.ITEM_DESCRIPTION[type];
					damage = 3;
					speed = 7;
					accuracy = 12;
					waitTime = 3;
					effects = [];
				break;
				case "ice arrow": // 80% AoE SLOW
					description = Const.ITEM_DESCRIPTION[type];
					damage = 1;
					speed = 8;
					accuracy = 8;
					waitTime = 6;
					effects = [Const.SOME_AOE_EFFECT];
				break;
				case "fire arrow": // Creates fire spot which burns area on ground which hits someone
					description = Const.ITEM_DESCRIPTION[type];
					damage = 2;
					speed = 8;
					accuracy = 8;
					waitTime = 12;
					effects = [Const.SOME_AOE_EFFECT];
				break;
				case "earth arrow": // Creates a wall in front of enemy hit, stopping enemy movement at that location 
					description = Const.ITEM_DESCRIPTION[type];
					damage = 1;
					speed = 8;
					accuracy = 10;
					waitTime = 6;
					effects = [Const.SOME_AOE_EFFECT];
				break;
				case "thunder arrow": // stuns enemies in a range for 3 seconds
					description = Const.ITEM_DESCRIPTION[type];
					damage = 3;
					speed = 10;
					accuracy = 5;
					waitTime = 13;
					effects = [Const.SOME_AOE_EFFECT];
				break;
				case "dark arrow": // Pierces all enemies
					description = Const.ITEM_DESCRIPTION[type];
					damage = 5;
					speed = 13;
					accuracy = 0;
					waitTime = 5;
					effects = [Const.PIERCE_EFFECT];
				break;
				case "empty":
				default:
					description = "";
			}
		}
		
		/*
			Accuracy to be shot
		*/
		public function getAdjustedAccuracy():Number
		{
			if(accuracy <= 0) return 0;
			var randAccuracy = accuracy;
			
			if(Math.random() > .5)
			{
				randAccuracy = Math.round(Math.random() * accuracy);
			}
			else
			{
				randAccuracy = -Math.round(Math.random() * accuracy);
			}
			return randAccuracy;
		}

		public static function getAdjustedAccuracy(acc:Number):Number
		{
			if(acc <= 0) return 0;
			var randAccuracy = acc;
			
			if(Math.random() > .5)
			{
				randAccuracy = Math.round(Math.random() * acc);
			}
			else
			{
				randAccuracy = -Math.round(Math.random() * acc);
			}
			return randAccuracy;
		}
		
		/*GETTERS SETTERS*/

		/*
			Obtains wait time based on number of 100 milli seconds
		*/
		public function getWaitTime():Number
		{
			return waitTime * 10;
		}

		public function getType():String
		{
			return type;
		}
		
		public function getArrowDescription():String
		{
			return description;
		}
		
		public function getSpeed():Number
		{
			return speed;
		}
		
		public function getDamage():Number
		{
			return damage;
		}
		
		public function getAccuracy():Number
		{
			return accuracy;
		}

		public function doesHaveEffect(type:Number):Boolean
		{
			return effects.indexOf(type) != -1 ? true : false;
		}
		
		

	}
	
}
