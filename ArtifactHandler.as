package  {
	
	/*
		Represents heros artifact unequipped and equipped
	*/
	public class ArtifactHandler {
		
		//contains all artifact equipped and having an effect 
		private var artifactContainer:Array = [
											   new Artifact("glyph of haste"), 			new Artifact("empty"), new Artifact("locked"), new Artifact("locked"),
											   new Artifact("locked"), 					new Artifact("locked"), new Artifact("locked"), new Artifact("locked"),
											   new Artifact("locked"), 					new Artifact("locked"), new Artifact("locked"), new Artifact("locked"),
											   new Artifact("locked"), 					new Artifact("locked"), new Artifact("locked"), new Artifact("locked")
											   ];

		//contains all unequipped artifacts
	   	private var unequippedArtifacts:Array = [new Artifact("glyph of haste"), new Artifact("glyph of haste"), new Artifact("glyph of power"), new Artifact("glyph of health")]; 

		public function ArtifactHandler() {}


		/*
			Unlocks artifact slot given an index
		*/
		public function unlockArtifact(ind:Number):void
		{
			artifactContainer[ind] = new Artifact("empty");
		}

		/*
			Auto fill artifacts
		*/
		public function autoFillArtifacts():void
		{
			//count the number of freen spaces
			for(var i:Number = 0; i < artifactContainer.length; i++)
			{	
				if(artifactContainer[i].getArtifact() == "locked" || unequippedArtifacts.length <= 0)
				{
					break;
				}
				else
				{
					var ran:Number = Math.floor(Math.random() * unequippedArtifacts.length);
					var artifact:Artifact = unequippedArtifacts[ran];
					changeArtifact(i, ran);
				}
			}

		}



		/*
			change an artifact given a specific slot, removes it from stock
			removeSLot = 'artifactContainer' index being removed
			artifactIndex = 'unequippedArtifacts' index that will be swaped, if -1 that means we are only removing an index
		*/
		public function changeArtifact(removeSlot:Number, artifactIndex:Number)
		{

			//if the old artifact was not empty or locked, add it to unequippedArtifacts
			var prevArtifact:Artifact = artifactContainer[removeSlot];
			if(prevArtifact.getArtifact() != "locked" && prevArtifact.getArtifact() != "empty")
			{
				unequippedArtifacts.push(prevArtifact);
			}

			//If we did not click remove
			if(artifactIndex > -1)
			{
				var artifact:Artifact = unequippedArtifacts[artifactIndex];
				unequippedArtifacts.splice(artifactIndex, 1);
				artifactContainer[removeSlot] = artifact;
			}

			//If we are simply removing an artifact
			else
			{
				artifactContainer[removeSlot] = new Artifact("empty");
			}
		}

		/*
			Remove all artifacts and place them in the unequippedList
		*/
		public function removeAllArtifacts():void
		{
			var artifact:Artifact;
			for(var i:Number = 0; i < artifactContainer.length; i++)
			{
				if(artifactContainer[i].getArtifact() != "empty" && artifactContainer[i].getArtifact() != "locked")
				{
					artifact = artifactContainer[i];
					unequippedArtifacts.push(artifact);
					artifactContainer[i] = new Artifact("empty");
				}
			}
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




		/*___________________________________________________________GETTERS SETTERS____________________________________________________________*/
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
			unequippedArtifacts.push(artifact);
		}

		public function getUnequippedArtifacts():Array
		{
			return unequippedArtifacts.sortOn("artifact");
		}

		public function getEquippedArtifacts():Array
		{
			return artifactContainer;
		}
	}
	
}
