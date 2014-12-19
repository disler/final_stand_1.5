﻿package  {
	
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
					description = Const.ITEM_DESCRIPTION[_name];
					stats.accuracy = 9;//the close to 0 the more accurate
					stats.maxCastleHealth = 10;
					stats.castleHealthRegeneration = 2;
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
