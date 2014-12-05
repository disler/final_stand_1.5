﻿package  {
	
	/*
		Represents a bow
	*/
	public class Bow {

		private var name:String;
		private var description:String;
		private var stats:Object = {
			castleHealth : 0,
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
			return name;
		}

		public function getStats()
		{
			return name;
		}
		
	}
	
}