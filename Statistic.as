package  {
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.utils.*;
	import flash.events.TimerEvent;

	/*max health, damage, attackSpeed, accuracy, armor piece, projectile piece
		handles player statistics
	*/
	public class Statistic  {

		public var castleHealth:Number = 0;
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
		public var bowContainer:Array = [null, null, null, null, null, null];
		public var gold:Number = 100;
		public var bow:Bow;
		public var healthRegenInterval:uint;

		public var arrowTimers:Array = [null, null, null];
		public var shootable:Array = [false, false, false];
		public var pieMaskContainer:Array = [];

		
		/*
			Statistic initializer for new hero
		*/
		public function Statistic(HEALTHBAR:HealthBar, MAIN:MovieClip, CASTLEHEALTH:Number = 10, CASTLEHEALTHREGENERATION:Number = 0, ACCURACY:Number = 0, BOWSPEED:Number = 0, DAMAGE:Number = 1, ATTACK_SPEED:Number = 0, EXP:Number = 0, MAXEXP:Number = 100, LEVEL:Number = 1) { 
			castleHealth = CASTLEHEALTH;
			maxCastleHealth = CASTLEHEALTH;
			castleHealthRegeneration = CASTLEHEALTHREGENERATION;
			damage = DAMAGE;
			attackSpeed = ATTACK_SPEED;
			bowSpeed = BOWSPEED;
			accuracy = ACCURACY;
			exp = EXP;
			maxExp = MAXEXP;
			level = LEVEL;
			healthBar = HEALTHBAR;
			main = MAIN;

			//arrows
			equippedArrows = [new ArrowType("wooden arrow"), new ArrowType("empty"), new ArrowType("empty")];


			//initiate pie masks
			for(var i:Number = 1; i < 4; i++)
			{
				var ref:MovieClip = main.interface_mc.inGameInterface_mc["arrow" + i + "_mc"];
				var halfX:Number = ref.width/2;
				var radius:Number = ref.width/2; 
				var halfY:Number = ref.height/2;

				var circ:Sprite = new Sprite();
				circ.graphics.beginFill(0xFFFFFF, .5);
				circ.graphics.drawCircle(0, 0, radius);
				circ.graphics.endFill();
				circ.x = halfX;
				circ.y = halfY;
				ref.addChild(circ);

				var pmask:Sprite = new Sprite();
				pmask.x = halfX;
				pmask.y = halfY;
				ref.addChild(pmask);
				circ.mask = pmask;

				var pie:PieMask = new PieMask( 	pmask.graphics, 0, radius, 
												0, 
												0,
												200,
												3);
				pie.drawWithFill();
				pieMaskContainer.push(pie);
			}

			//bow
			bow = new Bow("oak bow");
			loadBowBonus(bow);

			//load players bow frame
			bowVisual();

			//ARTIFACT
			artifactHandler = new ArtifactHandler();
			loadArtifactBonus(artifactHandler);
			main.interface_mc.inGameInterface_mc.health_mc.health_txt.text = castleHealth;

			//arrow timers
			setupArrowTimers();

			//health regeneration interval
			healthRegenInterval = setInterval(healthRegeneration, Const.HEALTH_REGENERATION_INTERVAL);
		}

		/*
			Instantly kill enemy
		*/
		public function instantDeath(occ:Number = 0):Boolean
		{
			var roll = occ * Const.INSTANT_DEATH_PERCENTAGE;
			if(Math.floor(Math.random() * 100) <= roll)
			{
				return true;
			}
			return false;
			
		}

		/*
			Pierce enemy sheild
		*/
		public function pierceEnemy(occ:Number = 0):Boolean
		{
			var roll = occ * Const.SHEILD_BREAK_PERCENTAGE;
			if(Math.floor(Math.random() * 100) <= roll)
			{
				return true;
			}
			return false;
		}

		public function pierceProjectile(occ:Number = 0):Boolean
		{
			var roll = occ * Const.COLLISION_BREAK_PERCENTAGE;
			if(Math.floor(Math.random() * 100) <= roll)
			{
				return true;
			}
			return false;
		}


		/*
			Returns the number of times an arrow can be shot based on the 'glyph of multishot'
		*/	
		public function multiShot(occ:Number = 0):Number
		{
			var successPercentage:Number = occ * Const.MULTI_SHOT_ROLL_PERCENTAGE;
			var shots:Number = 1;
			
			if(successPercentage <= 100)
			{
				if(Math.floor(Math.random() * 100) < successPercentage)
				{
					shots++;
				}
			}
			else if(successPercentage <= 200)
			{
				shots++;
				if(Math.floor(Math.random() * 100) < successPercentage - 100)
				{
					shots++;
				}
			}

			return shots;
		}

		/*_________________________________________ARROW TIMERS_________________________________________*/
		
		public function canShootArrow(slot:Number):Boolean
		{
			return shootable[slot];
		}
		/*
			Initiates all nessacary arrow timers
		*/
		private function setupArrowTimers():void
		{
			for(var i:Number = 0; i < equippedArrows.length; i++)
			{
				//if this arrow is not empty set up the arrow timer
				if(equippedArrows[i].getType() != "empty")
				{
					setupArrowTimer(i);
				}
			}
		}

		/*
			Sets up a single arrow timer given a slot
		*/
		private function setupArrowTimer(slot:Number):void
		{
			//calculate bonus waittime
			var waitTime:Number = equippedArrows[slot].getWaitTime();
			var bonusReduceWaitTime = getAttackSpeed();
			var reducedWaitTime = waitTime * Math.pow(1 - Const.ARROW_SPEED_REDUCER, bonusReduceWaitTime);
			
			//create timer object
			// /2 and *2 to increase frames inwhich pie mask loads
			arrowTimers[slot] = new Timer(Const.ARROW_TICK_INTERVAL/3, reducedWaitTime*3);

			
			//when the timer has proceed a single tick
			arrowTimers[slot].addEventListener(TimerEvent.TIMER, 
			function(e:TimerEvent) 
			{
				arrowTick(e, slot);
			});
			
			//when the timer is complete
			arrowTimers[slot].addEventListener(TimerEvent.TIMER_COMPLETE, 
			function(e:TimerEvent)
			{
				arrowTickComplete(e, slot);
			});
			arrowTimers[slot].start();
		}



		/*
			Tick interval for arrow reloading
		*/
		private function arrowTick(e:TimerEvent, slot:Number):void
		{
			//render PieMask
			pieMaskContainer[slot].drawWithFill(e.currentTarget.currentCount / e.currentTarget.repeatCount);
		}

		/*
			When arrow timer has been completed
		*/
		private function arrowTickComplete(e:TimerEvent, slot:Number):void
		{
			arrowTimers[slot].stop();
			shootable[slot] = true;
		}

		/*
			Resets arrow timer after it's been shot
		*/
		public function resetArrowTimer(slot:Number):void
		{
			arrowTimers[slot].reset();
			arrowTimers[slot].start();
			shootable[slot] = false;
		}















		/*
			Called every 5 seconds to regenerate health
		*/
		private function healthRegeneration():void
		{
			if(main.gameState == "inGame")
			{
				if(castleHealth < maxCastleHealth)
				{
					castleHealth += castleHealthRegeneration;
					main._interface.loadHpNoFlash(getHealth(), getMaxHealth());
				}

				if(castleHealth > maxCastleHealth)
				{
					var diff:Number = castleHealth - maxCastleHealth;
					castleHealth -= diff;
					main._interface.loadHpNoFlash(getHealth(), getMaxHealth());
				}
			}
		}


		/*____________________________________________'BOW'_________________________________________*/

		/*
			For when we have looted a new bow
		*/
		public function addBow(bow:Bow):void
		{
			for(var i:Number = 0 ; i < bowContainer.length; i++)
			{
				if(bowContainer[i] == null)
				{
					bowContainer[i] = bow;
					break;
				}
			}
		}

		/*
			Equip a new bow based on string, reduce old stats increase by new stats
		*/
		public function equipBow(bowSlot:Number):void
		{
			//grab new bow
			var bowToBeEquipped = bowContainer[bowSlot];

			//swap old bow
			bowContainer[bowSlot] = bow;
			//remove current bonuses
			resetBowBonus(bow);
			//equip new bow
			bow = bowToBeEquipped;
			//visuals
			main._interface.loadCurrentBow();
			//add new bonuses
			loadBowBonus(bow);
			//reset arrow timers
			setupArrowTimers();
			//reset stat display
			main.interface_mc.loadPrimaryInterfaceText();
			//player visuals
			bowVisual();
		}

		/*
			Handle displaying bow
		*/
		public function bowVisual():void
		{
			main.player.I.bow_mc.gotoAndStop(bow.getName());
		}




		/*
			Loads bow statistic bonuses 
		*/
		public function loadBowBonus(bow:Bow):void
		{
			var stats:Object = bow.getStats();

			maxCastleHealth +=  stats.maxCastleHealth;
			castleHealthRegeneration += stats.castleHealthRegeneration;
			damage += stats.damage;
			attackSpeed += stats.attackSpeed;
			accuracy += stats.accuracy;
			bowSpeed += stats.bowSpeed;
		}

		/*
			resets bow statistic bonuses
		*/
		public function resetBowBonus(bow:Bow):void
		{
			var stats:Object = bow.getStats();

			maxCastleHealth -=  stats.maxCastleHealth;
			castleHealthRegeneration -= stats.castleHealthRegeneration;
			damage -= stats.damage;
			attackSpeed -= stats.attackSpeed;
			accuracy -= stats.accuracy;
			bowSpeed -= stats.bowSpeed;
		}

		/*____________________________________________'ARTIFACTS'_________________________________________*/





		/*
			Returns the occurence of a specific glyph
		*/
		public function occurrence(str:String):Number
		{
			return artifactHandler.occurrence(str);
		}



		public function getArtifactByIndex(ind:Number):Artifact
		{
			return artifactHandler.getEquippedArtifacts()[ind];
		}

		/*
			Auto fills artifacts
		*/
		public function autoFillArtifacts():void
		{
			resetArtifactBonus(artifactHandler);
			artifactHandler.autoFillArtifacts();
			loadArtifactBonus(artifactHandler);
			main.interface_mc.loadPrimaryInterfaceText();
			setupArrowTimers();
		}

		/*
			Gets array of currently equiped artifacts
		*/	
		public function getEquippedArtifacts():Array
		{
			return artifactHandler.getEquippedArtifacts();
		}

		/*
			Gets array of unequipped artifacts
		*/
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
			main.interface_mc.loadPrimaryInterfaceText();
			setupArrowTimers();
		}

		/*
			Removes all artifacts
		*/
		public function removeAllArtifacts():void
		{
			resetArtifactBonus(artifactHandler);
			artifactHandler.removeAllArtifacts();
			loadArtifactBonus(artifactHandler);
			main.interface_mc.loadPrimaryInterfaceText();
			setupArrowTimers();
		}

		/*
			loads all current statistic bonuses from artifacts (THIS SHOULD ALWAYS BE CALLED DIRECTLY AFTER CHANGING ARTIFACTS)
		*/
		public function loadArtifactBonus(artifactHandler:ArtifactHandler):void
		{
			var stats:Object = artifactHandler.getAllStats();

			maxCastleHealth +=  stats.castleHealth;
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

			maxCastleHealth -=  stats.castleHealth;
			castleHealthRegeneration -= stats.castleHealthRegeneration;
			damage -= stats.damage;
			attackSpeed -= stats.attackSpeed;
			accuracy -= stats.accuracy;
			bowSpeed -= stats.bowSpeed;
		}
		


		/*________________________________ARROWS________________________________*/

		/*
			Equip and arrow to a slot
		*/
		public function equipArrow(arrowName:String, slot:Number)
		{
			var newArrow:ArrowType = new ArrowType(arrowName);
			var oldArrow:ArrowType = equippedArrows[slot];
			var oldArrowAsLoot:Loot;

			equippedArrows[slot] = newArrow;
			main._interface.loadArrows(equippedArrows);

			//if the old arrow was an arrow not an empty slot
			if(oldArrow.getType() != "empty")
			{
				oldArrowAsLoot = new Loot(oldArrow.getType(), Const.LOOT_ARROW);
				oldArrowAsLoot.x = 100 + (slot * 97);
				oldArrowAsLoot.y = 220;
				main.loot_mc.addChild(oldArrowAsLoot);
				main.con.handleNewLoot(oldArrowAsLoot);
			};

			setupArrowTimer(slot);
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
			
			if(exp > maxExp && level < Const.MAX_LEVEL)
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
			unlockArtifactSlot();

			
			Messenger.alertMessage("You have leved up! Level: " + level);
		}

		/*
			Handles unlocking artifact slots
		*/
		public function unlockArtifactSlot():void
		{
			if(Const.ARTIFACT_SLOT_LEVELS.indexOf(level) != -1)
			{
				for(var i:Number = 0; i < getEquippedArtifacts().length; i++)
				{
					if(getEquippedArtifacts()[i].getArtifact() == "locked")
					{
						artifactHandler.unlockArtifact(i);
						Messenger.alertMessage("You have unlocked a new artifact slot!");
						break;
					}
				}
			}
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
			main._interface.loadHpFlash(getHealth(), getMaxHealth());
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
			clearInterval(healthRegenInterval);
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

		/*
			Returns all battle stats for projectile
		*/
		public function getBattleStats():Object
		{
			return {
				castleHealth : maxCastleHealth,
				castleHealthRegeneration : castleHealthRegeneration,
				damage : damage,
				attackSpeed : attackSpeed,
				accuracy : accuracy,
				bowSpeed : bowSpeed,
				effect : "none"
			};
		}

		/*
			Returns true if this bow is owned
		*/
		public function containsBow(bow:Bow):Boolean
		{
			for(var i:Number = 0; i < bowContainer.length; i++)
			{
				if(bowContainer[i] != null)
				{
					if(bowContainer[i].getName() == bow.getName() ||  bowContainer[i].getName() == this.bow.getName())
					{
						return true;
					}
				}
			}
			return false;
		}

		/*
			Returns ture if the arrow is owned
		*/
		public function containsArrow(arrow:ArrowType):Boolean
		{
			for(var i:Number = 0; i < equippedArrows.length; i++)
			{
				if(equippedArrows[i].getType() == arrow.getType())
				{
					return true;
				}
			}
			return false;
		}

		/*____________________________________________GETTERS - SETTERS____________________________________________*/
		

		public function getBowContainer():Array
		{
			return bowContainer;
		}
		/*
			Obtains the string value of all currently owned bows and arrows
		*/
		public function getUniqueLoot():Array
		{
			var ret:Array = [];

			for(var i:Number = 0; i < equippedArrows.length; i++)
			{
				if(equippedArrows[i].getType() != "empty")
				{
					ret.push(equippedArrows[i].getType());
				}
			}

			//account for currently equipped bow
			var tempBowContainer:Array = bowContainer;
			tempBowContainer.push(bow);

			for(i = 0; i < tempBowContainer.length; i++)
			{
				if(tempBowContainer[i] != null)
				{
					ret.push(tempBowContainer[i].getName());
				}
			}
			return ret;
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


		public function getDamage():Number
		{
			return damage;
		}


		public function getAttackSpeed():Number
		{
			return attackSpeed;
		}


		public function getAccuracy():Number
		{
			return accuracy;
		}


		public function getBowSpeed():Number
		{
			return bowSpeed;
		}

		public function getBowName():String
		{
			return bow.getName();
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
