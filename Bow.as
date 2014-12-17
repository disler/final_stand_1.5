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
			Generats bow statistics based on name
		*/
		private function bowFactory(_name:String):void
		{
			switch(_name)
			{
				case "guardian bow":
					stats.accuracy = 2;
					stats.maxCastleHealth = 5;
					stats.castleHealthRegeneration = 1;
				break;
				case "oak bow":
				default:
					description = "Sturdy bow made from oak";
					stats.accuracy = 5;


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
