package  {
	import flash.utils.*;
	import flash.display.*;
	import flash.events.*;
	
	/*
		Manages each wave, it's progress and enemies
	*/
	public class WaveHandler {
		
		/*____________________________________________VARS____________________________________________*/
		
		//reference to main
		private var main:MovieClip;
		
		//current wave
		private var waveId:Number = 0;
		private var unspawnedEnemies:Number; 
		public var enemySpawnTimer:Number;
		private var enemySpawnInterval:uint;
		
		//contains all currently spawned enemies
		private var enemyContainer:Array = [];
		private var remainingWaveEnemies:Number;
		private var killedWaveEnemies:Number;

		private var lootCount:Number = 0;
		private var totalEnemiesKilled:Number;

		private var kills:Number = 0;
		
		//contains all objects that can be hittable
	 	private var hittables:Array;
		
		
		
		/*____________________________________________PUBLIC FUNCTIONS____________________________________________*/
		
		/*
			set wave
		*/
		public function WaveHandler(m:MovieClip, setWave:Number) {
			
			waveId = setWave;
			main = m;
			
			resetEnemyContainer();
			
		}

		/*
			Resets enemy container
		*/
		public function resetEnemyContainer():void
		{
			for(var i:Number = 0; i < 100; i++)
			{
				enemyContainer[i] = null;
			}
		}
		
		/*
			Begins waves
		*/
		public function init():void {
			generateWave(waveId);
			SoundHandler.playMusic("game1");
		}
		
		/*
			When an enemy is killed
		*/
		public function killEnemy(enemy:Enemy):void
		{
			kills++;
			remainingWaveEnemies--;
			spawnLoot(enemy);
			main.enemies_mc.removeChild(enemy);
			enemyContainer[enemy.getId()] = null;
			
			if(noRemainingEnemies())
			{
				waveComplete();
			}
		}

		/*
			Removes enemy when game is over
		*/
		public function removeEnemy(enemy:Enemy):void
		{
			main.enemies_mc.removeChild(enemy);
			enemyContainer[enemy.getId()] = null;
		}
		
		
		/*____________________________________________PRIVATE FUNCTIONS____________________________________________*/
			
		/*
			Handles spawning loot given an enemies death
		*/
		private function spawnLoot(enemy:Enemy):void
		{
			var loot:Loot;
			var lootRoll:Object = LootHandler.lootRoll(enemy.getStats().getLootTier());
			var bool = lootRoll.bool;

			//if we rolled for loot
			if(bool)
			{
				loot = LootHandler.getLoot(lootRoll.tier, main.player.getStats().getUniqueLoot());
			}
			//if we receive no loot we roll for gold
			else
			{
				bool = LootHandler.goldRoll();
				//if we roll for gold
				if(bool)
				{
					loot = LootHandler.getGold(waveId);
				}
			}

			//if we got any loot
			if(bool)
			{
				loot.x = enemy.x;
				loot.y = enemy.y;
				loot.name = "lo" + lootCount;
				lootCount++;
				
				main.con.handleNewLoot(loot);
				main.loot_mc.addChild(loot);
			}

		}

		/*
			Iterate to the next break/wave
		*/	
		public function waveComplete():void
		{
			Messenger.alertMessage("Wave complete!");
			
			//add break here
			waveId += 1;

			//complete wave move to intermission mode
			main.changeGameState("intermission");
			SoundHandler.playSound("waveDone");
		}


		/*
			Starts the next wave
		*/
		public function startWave():void
		{
			//reset castle health
			main.player.getStats().resetHealth();

			//create next wave
			generateWave(waveId);
			
			if(waveId < 10)
			SoundHandler.playMusic("game1");
			if(waveId > 9 && waveId < 20)
			SoundHandler.playMusic("game2");
			if(waveId > 19 && waveId < 31)
			SoundHandler.playMusic("game3");
		}
		
		/*
			Checks 'enemyContainer' to see if there are any remaining enemies
		*/
		private function noRemainingEnemies():Boolean
		{
			if(remainingWaveEnemies == 0)
			{
				for(var i:Number = 0; i < enemyContainer.length; i++)
				{
					if(enemyContainer[i] != null)
					{
						return false;
					}
				}
				return true;
			}
			return false;
		}
		
		/*
			Determines how many enemies to create and when, based on the wave
		*/
		private function generateWave(whichWave:Number):void
		{
			//generators
			unspawnedEnemies = Math.round(Math.pow(whichWave, 1.3)) + 5;
			enemySpawnTimer = 3000 - Math.round((Math.random() * 750)) - Math.floor(Math.pow(whichWave, 1.1));
			
			
			remainingWaveEnemies = unspawnedEnemies;
			enemySpawnInterval = setInterval(generateEnemyInterval, enemySpawnTimer);
			Messenger.alertMessage("Begin Wave: " + waveId);
		}
		
		/*
			Creates an enemy after 'enemySpawnTimer' delay
		*/
		private function generateEnemyInterval():void
		{
			var enemyId:Number = enemyContainer.length;
			
			var enemy:Enemy = enemyFactory(waveId);
			var coords = getValidXYSpawn();
			enemy.x = coords.x;
			enemy.y = coords.y;
			
			for(var i:Number = 0; i < enemyContainer.length; i++)
			{
				if(enemyContainer[i] == null)
				{
					enemyContainer[i] = enemy;
					enemy.setId(i);
					break;
				}
			}
			
			main.enemies_mc.addChild(enemy);
			
			unspawnedEnemies--;
			if(unspawnedEnemies == 0)
			{
				Messenger.alertMessage("Final Enemy!");
				clearInterval(enemySpawnInterval);
			}
		}

		/*
			Obtains enemy that can be spawned htis wave
		*/
		private function enemyFactory(_waveId:Number):Enemy
		{
			var enemy:Enemy;
			var waveDiff:Number;

			if(_waveId < 3)
			{
				waveDiff = 1;//bandits
			}
			else if(_waveId >= 3 && _waveId < 7)
			{
				waveDiff = 2;//bandits, guardian
			}
			else if(_waveId >= 7 && _waveId < 10)
			{
				waveDiff = 3;//bandits, guardian, mage
			}
			else if(_waveId >= 10 && _waveId < 15)
			{
				waveDiff = 4;//bandits, guardian, mage, hyper guard
			}
			else if(_waveId >= 15 && _waveId < 20)
			{
				waveDiff = 5;//bandits, guardian, mage, hyper guard, assassian
			}
			else//all other waves
			{
				waveDiff = 6;//bandits, guardian, mage, hyper guard, assassian, archers
			}
			return enemyClassFactory(waveDiff);
		}




		/*
			Enemy class factory, determines type of enemy to be spawned based on random number given
			the larger the number the larger type of enemies that could be spawn (all have equal chance)
		*/
		private function enemyClassFactory(typeNumber:Number):Enemy
		{
			var roll:Number = Math.round(Math.random() * typeNumber);
			roll = roll == 0 ? 1 : roll;
			var enemy:Enemy;
			var enemyNumber:Number;
			switch(roll)
			{
				//spawn a bandit
				case 1:
					enemy = new Bandit();
					enemyNumber = Const.BANDIT;
				break;
				//spawn a guard
				case 2:
					enemy = new Guard();
					enemyNumber = Const.GUARD;
				break;
				//spawn a mage
				case 3:
					enemy = new Mage();
					enemyNumber = Const.MAGE;
				break;
				//spawn a hyper guard
				case 4:
					enemy = new HyperGuard();
					enemyNumber = Const.HYPER_GUARD;
				break;
				//spawn a assassian
				case 5:
					enemy = new Assassian();
					enemyNumber = Const.ASSASSIAN;
				break;
				//spawn a archer
				case 6:
					enemy = new Archer();
					enemyNumber = Const.ARCHER;
				break;
			}

			enemy.LOAD(main, new StatisticEnemy(enemyStatisticFactory(enemyNumber)));
			return enemy;
		}	

		/*
			Obtains enemy statistics based on type
		*/
		private function enemyStatisticFactory(enemyType:Number):Object
		{
			var stats:Object;
			switch(enemyType)
			{
				case Const.BANDIT:
					stats = {
						type : "bandit",
						HEALTH : 2 + (Math.floor(waveId/5)),
						DAMAGE: 1 + (Math.floor(waveId/10)),
						ATTACK_SPEED : 4000,
						MOVEMENT_SPEED : 1.2, 
						EXP_GIVEN : 20,
						LOOT_TIER : 0
					};
				break;

				case Const.GUARD:
					stats = { 
						type : "guard",
						HEALTH : 5 + (Math.floor(waveId/5)),
						DAMAGE: 1 + (Math.floor(waveId/10)),
						ATTACK_SPEED : 5000,
						MOVEMENT_SPEED : .5, 
						EXP_GIVEN : 30,
						LOOT_TIER : 1
					};
				break;

				case Const.MAGE:
					stats = { 
						type : "mage",
						HEALTH : 3 + (Math.floor(waveId/5)),
						DAMAGE: 3 + (Math.floor(waveId/10)),
						ATTACK_SPEED : 4000,
						MOVEMENT_SPEED : 1.5, 
						EXP_GIVEN : 40,
						LOOT_TIER : 2
					};
				break;

				case Const.HYPER_GUARD:
					stats = { 
						type : "hyper guard",
						HEALTH : 10 + (Math.floor(waveId/5)),
						DAMAGE: 1 + (Math.floor(waveId/10)),
						ATTACK_SPEED : 5000,
						MOVEMENT_SPEED : .3, 
						EXP_GIVEN : 50,
						LOOT_TIER : 2
					};
				break;

				case Const.ASSASSIAN:
					stats = { 
						type : "assassian",
						HEALTH : 3 + (Math.floor(waveId/5)),
						DAMAGE: 2 + (Math.floor(waveId/10)),
						ATTACK_SPEED : 3000,
						MOVEMENT_SPEED : 2, 
						EXP_GIVEN : 50,
						LOOT_TIER : 3
					};
				break;

				case Const.ARCHER:
					stats = { 
						type : "archer",
						HEALTH : 1 + (Math.floor(waveId/5)),
						DAMAGE: 1 + (Math.floor(waveId/10)),
						ATTACK_SPEED : 3000,
						MOVEMENT_SPEED : 1, 
						EXP_GIVEN : 50,
						LOOT_TIER : 3
					};
				break;
			}
			return stats;
		}
		
		/*
			Returns a valid enemy spawning x coord
		*/
		private function getValidXYSpawn():Object
		{
			var coords:Object = {x : 0 , y : 0};
			switch(Main.random(4))
			{
				case 0://spawn from top
					coords.x = Main.random(Const.STAGE_WIDTH);
					coords.y = -Const.OFF_SCREEN_OFF_SET;
				break;
				case 1://spawn from right
					coords.x = Const.STAGE_WIDTH + Const.OFF_SCREEN_OFF_SET;
					coords.y = Main.random(Const.STAGE_HEIGHT);
				break;
				case 2://spawn from bottom
					coords.x = Main.random(Const.STAGE_WIDTH);
					coords.y = Const.STAGE_HEIGHT + Const.OFF_SCREEN_OFF_SET;
				break;
				case 3://spawn from left
					coords.x = -Const.OFF_SCREEN_OFF_SET;
					coords.y = Main.random(Const.STAGE_HEIGHT);
				break;
			}
			return coords;
		}


		/*
			You have ended the waves (Death)
		*/
		public function endWaves():void
		{
			unspawnedEnemies = 0;
			remainingWaveEnemies = 0;
			clearInterval(enemySpawnInterval);
		}
		
		/*____________________________________________	EVENT METHODS____________________________________________*/


		
		
		
		/*____________________________________________GETTERS - SETTERS____________________________________________*/
		
		public function getEnemies():Array
		{
			return enemyContainer;
		}

		public function getWave():Number
		{
			return waveId;
		}


		public function getKills():Number
		{
			return kills;
		}


		/*____________________________________________    TESTING     ____________________________________________*/
		


		/*
			Spawns a specific enemy FOR TESTING ONLY
		*/
		private function enemyClassFactoryTesting(enemyConst:Number):Enemy
		{
			var enemy:Enemy;
			var enemyNumber:Number;
			switch(enemyConst)
			{
				//spawn a bandit
				case 1:
					enemy = new Bandit();
					enemyNumber = Const.BANDIT;
				break;
				//spawn a guard
				case 2:
					enemy = new Guard();
					enemyNumber = Const.GUARD;
				break;
				case 3:
					enemy = new Mage();
					enemyNumber = Const.MAGE;
				break;
				case 4:
					enemy = new HyperGuard();
					enemyNumber = Const.HYPER_GUARD;
				break;
				case 5:
					enemy = new Assassian();
					enemyNumber = Const.ASSASSIAN;
				break;

				case 6:
					enemy = new Archer();
					enemyNumber = Const.ARCHER;
				break;
			}

			enemy.LOAD(main, new StatisticEnemy(enemyStatisticFactory(enemyNumber)));
			return enemy;
		}

		
	}
	
}
