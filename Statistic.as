package  {
	import flash.display.MovieClip;


	/*
		handles player statistics
	*/
	public class Statistic  {

		public var castleHealth:Number;
		public var maxCastleHealth:Number;
		public var castleHealthRegeneration:Number;
		public var damage:Number;
		public var attackSpeed:Number;
		public var accuracy:Number;
		public var bowSpeed:Number;
		public var level:Number = 0;
		public var hasLeveledUp:Number = 0;
		public var exp:Number = 0;
		public var maxExp:Number = 0;
		public var alive:Boolean = true;
		public var equippedArrows:Array;
		public var healthBar:HealthBar;
		public var main:MovieClip;
		public var artifactHandler:ArtifactHandler;
		public var gold:Number;
		
		/*
			Statistic initializer for new hero
		*/
		public function Statistic(HEALTHBAR:HealthBar, MAIN:MovieClip, CASTLEHEALTH:Number = 10, CASTLEHEALTHREGENERATION:Number = 0, BOWSPEED:Number = 0, DAMAGE:Number = 1, ATTACK_SPEED:Number = 30, EXP:Number = 0, MAXEXP:Number = 100, LEVEL:Number = 1) { 
			castleHealth = CASTLEHEALTH;
			maxCastleHealth = CASTLEHEALTH;
			castleHealthRegeneration = CASTLEHEALTHREGENERATION;
			damage = DAMAGE;
			attackSpeed = ATTACK_SPEED;
			bowSpeed = BOWSPEED;
			exp = EXP;
			maxExp = MAXEXP;
			level = LEVEL;
			equippedArrows = [new ArrowType("wooden_arrow"), new ArrowType("steel_arrow"), new ArrowType("empty")];
			healthBar = HEALTHBAR;
			main = MAIN;

			//ARTIFACT
			artifactHandler = new ArtifactHandler();
			loadArtifactBonus(artifactHandler);
		}

		/*____________________________________________'ARTIFACTS'_________________________________________*/
		public function getArtifactByIndex(ind:Number):Artifact
		{
			return artifactHandler.getEquippedArtifacts()[ind];
		}

		public function autoFillArtifacts():void
		{
			resetArtifactBonus(artifactHandler);
			artifactHandler.autoFillArtifacts();
			loadArtifactBonus(artifactHandler);
		}
		public function getEquippedArtifacts():Array
		{
			return artifactHandler.getEquippedArtifacts();
		}

		public function getUnequippedArtifacts():Array
		{
			return artifactHandler.getUnequippedArtifacts();
		}

		/*
			Add an artifact
		*/
		public function addArtifact(artifact:Artifact):void
		{
			artifactHandler.addArtifactToList(artifact);
		}

		/*
			Equip an artifact: reset stats, add artifact, load new stats
		*/
		public function equipArtifact(slot:Number, artifactIndex:Number):void
		{
			resetArtifactBonus(artifactHandler);
			artifactHandler.changeArtifact(slot, artifactIndex);
			loadArtifactBonus(artifactHandler);
		}

		/*
			Removes all artifacts
		*/
		public function removeAllArtifacts():void
		{
			resetArtifactBonus(artifactHandler);
			artifactHandler.removeAllArtifacts();
			loadArtifactBonus(artifactHandler);
		}

		/*
			loads all current statistic bonuses from artifacts (THIS SHOULD ALWAYS BE CALLED DIRECTLY AFTER CHANGING ARTIFACTS)
		*/
		public function loadArtifactBonus(artifactHandler:ArtifactHandler):void
		{
			var stats:Object = artifactHandler.getAllStats();

			maxCastleHealth +=  stats.maxCastleHealth;
			castleHealthRegeneration += stats.castleHealthRegeneration;
			damage += stats.damage;
			attackSpeed += stats.attackSpeed;
			accuracy += stats.accuracy;
			bowSpeed += stats.bowSpeed;
		}

		/*
			reduces all current statistic bonuess from artifacts for when new statistics are added (THIS SHOULD ALWAYS BE CALLED BEFORE CHANGING ARTIFACTS)
		*/
		public function resetArtifactBonus(artifactHandler:ArtifactHandler):void
		{
			var stats:Object = artifactHandler.getAllStats();

			maxCastleHealth -=  stats.maxCastleHealth;
			castleHealthRegeneration -= stats.castleHealthRegeneration;
			damage -= stats.damage;
			attackSpeed -= stats.attackSpeed;
			accuracy -= stats.accuracy;
			bowSpeed -= stats.bowSpeed;
		}
		







		/*
			Reset health to max health
		*/
		public function resetHealth():void
		{
			castleHealth = maxCastleHealth;
		}




		/*
			increased exp, if overlap: level up and alert
		*/
		public function gainExp(amount:Number):void
		{
			exp += amount;
			
			if(exp > maxExp)
			{
				levelUp();
			}
		}

		/*	
			Leveling up
		*/
		public function levelUp():void
		{
			//increase level
			level += 1;
			//overlap exp
			exp = exp - maxExp;
			//stack any current 'level ups'
			hasLeveledUp += 1;
			//obtain next 'maxExp' amount
			maxExp = getNextMaxExp(maxExp);
			//reset health to be max
			resetHealth();



			//unlock artifact slots based on level


			
			Messenger.alertMessage("You have leved up! Level: " + level);
		}
		
		/*
			Generates the next required amount of exp
		*/
		public function getNextMaxExp(oldMaxExp:Number):Number
		{
			return Math.round(oldMaxExp * 1.2); 
		}

		/*
			Hero tower has taken damage
		*/
		public function takeDamage(amount:Number):void
		{
			castleHealth -= amount;
			healthBar.setHealth(castleHealth);
			main._interface.fadeInInterface();
			if (castleHealth <= 0) {
				gameOver();
			}
		}	

		/*
			When hp reaches 0
		*/
		public function gameOver()
		{
			trace("you have died");
		}


		/*	
			Add x amount to current gold
		*/
		public function addGold(amt:Number):void
		{
			gold += amt;
		}

		/*
			Spend x amount of current gold (given that it will not exceed current amount of gold)
		*/
		public function spendGold(amt:Number):void
		{
			gold -= amt;
		}

		/*____________________________________________GETTERS - SETTERS____________________________________________*/
		
		public function getDamage():Number
		{
			return damage;
		}
		
		public function getEquippedArrows():Array
		{
			return equippedArrows;
		}
		
		public function getHealth():Number
		{
			return castleHealth;
		}
		
		public function getMaxHealth():Number
		{
			return maxCastleHealth;
		}

		public function getHealthRegeneration():Number
		{
			return castleHealthRegeneration;
		}

		public function getGold():Number
		{
			return gold;
		}

		public function setGold(gold:Number):void
		{
			this.gold = gold;
		}


	}
	
}
