package  {
	
	/*
		Represents heros artifact unequipped and equipped
	*/
	public class ArtifactHandler {
		
		//contains all artifact equipped and having an effect 
		private var artifactContainer:Array = [
											   new Artifact("glyph of minor haste"), 	new Artifact("locked"), new Artifact("locked"), new Artifact("locked"),
											   new Artifact("locked"), 					new Artifact("locked"), new Artifact("locked"), new Artifact("locked"),
											   new Artifact("locked"), 					new Artifact("locked"), new Artifact("locked"), new Artifact("locked"),
											   new Artifact("locked"), 					new Artifact("locked"), new Artifact("locked"), new Artifact("locked")
											   ];

		//contains all unequipped artifacts
	   	private var uneqippedArtifacts:Array; 

		public function ArtifactHandler() {}

		/*
			change an artifact given a specific slot
		*/
		public function changeArtifact(slot:Number, artifact:Artifact)
		{
			//if the old artifact was not empty or locked, add it to unequippedArtifacts
			var prevArtifact:Artifact = artifactContainer[slot];
			if(prevArtifact.getArtifact() != "locked" || prevArtifact.getArtifact() != "empty")
			{
				uneqippedArtifacts.push(prevArtifact);
			}
			artifactContainer[slot] = artifact;
		}


		/*
			Iterates through list of artifacts and adds them to a new object with the sum of stats of them all
		*/
		public function getAllStats():Object
		{
			var stats:Object = {
				castleHealth : 0,
				castleHealthRegeneration: 0,
				damage : 0,
				attackSpeed : 0,
				accuracy : 0,
				bowSpeed : 0,
				effect : "none"
			}

			for(var i:Number = 0; i < artifactContainer.length; i++)
			{
				var thisArtifact:Artifact;
				if(artifactContainer[i].getArtifact() == "locked" || artifactContainer[i].getArtifact() == "empty")
				{
					continue
				}
				else
				{
					thisArtifact = artifactContainer[i];

					stats.castleHealth += thisArtifact.getStats().castleHealth;
					stats.damage += thisArtifact.getStats().damage;
					stats.attackSpeed += thisArtifact.getStats().attackSpeed;
					stats.accuracy += thisArtifact.getStats().accuracy;
					stats.bowSpeed += thisArtifact.getStats().bowSpeed;
				}
			}

			return stats;
		}

		/*
			Compiles a list of all effects currently equiped
		*/
		public function getAllStatEffects():Array
		{
			var arr:Array;

			for(var i:Number = 0; i < artifactContainer.length; i++)
			{
				if(artifactContainer[i].getArtifact() != "locked" || artifactContainer[i].getArtifact() != "empty")
				{
					arr.push(artifactContainer[i].getEffect());
				}
			}

			return arr;
		}

		/*
			Adds an artifact to your current unequipped artifacts
		*/
		public function addArtifactToList(artifact:Artifact):void
		{
			uneqippedArtifacts.push(artifact);
		}

		/*GETTERS SETTERS*/
		public function getUnequippedArtifacts():Array
		{
			return uneqippedArtifacts;
		}

	}
	
}
