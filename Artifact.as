package  {
	
	/*
		Represents a equipable artifiact
	*/
	public class Artifact {
		
		private var stats:Object = {};
		private var artifact:String;
		private var description:String;

		public function Artifact(artifact:String) {
			this.artifact = artifact;
			stats = artifactFactory(artifact);
		}
		
		/*
			Loads artifact based on name
		*/
		private function artifactFactory(aritifact:String):Object
		{
			var stats:Object = {
				castleHealth : 0,
				castleHealthRegeneration : 0,
				damage : 0,
				attackSpeed : 0,
				accuracy : 0,
				bowSpeed : 0,
				effect : "none"
				
			};

			switch(artifact)
			{
				case "glyph of minor haste":
					stats.attackSpeed = 100;
					description = "Descrease wait time to fire arrows";
				break;
				case "locked":
				default:

			}

			return stats;
		}


		/*GETTERS SETTERS*/
		public function getStats():Object
		{
			return stats;
		}

		public function getArtifact():Object
		{
			return artifact;
		}

		public function getDescription():String
		{
			return description;
		}

		public function getEffect():String
		{
			return stats.effect;
		}


	}
	
}
