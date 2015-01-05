package  {
	
	/*
		Represents a bow
	*/
	public class Bow {

		private var name:String;
		private var description:String;
		private var stats:Object = {
			maxCastleHealth : 0,
			castleHealthRegeneration : 0,
			damage : 0,
			attackSpeed : 0,
			accuracy : 0,
			bowSpeed : 0,
			effect : "none"
		};


		public function Bow(name:String) {
			this.name = name;
			bowFactory(name);
		}


		/*
			Generates bow statistics based on name
		*/
		private function bowFactory(_name:String):void
		{
			switch(_name)
			{
				case "guardian bow": // tank bow
					description = Const.ITEM_DESCRIPTION[_name];
					stats.accuracy = 8;//the close to 0 the more accurate
					stats.maxCastleHealth = 10;
					stats.castleHealthRegeneration = 2;
				break;
				case "vicious bow": // power bow
					description = Const.ITEM_DESCRIPTION[_name];
					stats.accuracy = 15;//the close to 0 the more accurate
					stats.damage = 3;
					stats.maxCastleHealth = 5;
				break;
				case "agile bow": // attack speed bow
					description = Const.ITEM_DESCRIPTION[_name];
					stats.accuracy = 11;//the close to 0 the more accurate
					stats.maxCastleHealth = 5;
					stats.attackSpeed = 4;
				break;
				case "absolute bow": // accuracy bow
					description = Const.ITEM_DESCRIPTION[_name];
					stats.accuracy = 0;//the close to 0 the more accurate
					stats.maxCastleHealth = 5;
					stats.castleHealthRegeneration = 1;
				break;
				case "sonic bow":// arrow speed bow
					description = Const.ITEM_DESCRIPTION[_name];
					stats.accuracy = 7;//the close to 0 the more accurate
					stats.maxCastleHealth = 5;
					stats.castleHealthRegeneration = 3;
					stats.bowSpeed = 8;
				break;
				case "limbow":// awesome
					description = Const.ITEM_DESCRIPTION[_name];
					stats.accuracy = 1;//the close to 0 the more accurate
					stats.maxCastleHealth = 7;
					stats.castleHealthRegeneration = ;
					stats.bowSpeed = 5;
					stats.damage = 3;
				break;
				case "oak bow":
				default:
					description = Const.ITEM_DESCRIPTION[_name];
					stats.accuracy = 4;


			}
		}


		/*GETTERS SETTERS*/

		public function getName()
		{
			return name;
		}

		public function getDescription()
		{
			return description;
		}

		public function getStats()
		{
			return stats;
		}
		
	}
	
}
