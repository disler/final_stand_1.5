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

		public function ArrowType(TYPE:String) {
			type = TYPE;
			arrowStatsFactory(type);
		}
		
		
		private function arrowStatsFactory(type:String):void
		{
			switch(type)
			{
				case "wooden_arrow":
					description = "A light-weight, wooden arrow";
					damage = 0;//is not base speed (added to hero damage)
					speed = 7;//is base speed
					accuracy = 5;//0 is perfect accuracy, the higher the worse
				break;
				case "steel_arrow":
					description = "A powerful yet heavier arrow";
					damage = 1;
					speed = 5;
					accuracy = 10;
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
			if(accuracy == 0) return 0;
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
			if(acc == 0) return 0;
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
		
		

	}
	
}
