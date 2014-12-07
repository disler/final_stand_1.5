﻿package  {
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
		private var enemySpawnTimer:Number;
		private var enemySpawnInterval:uint;
		
		//contains all currently spawned enemies
		private var enemyContainer:Array = [];
		private var remainingWaveEnemies:Number;
		private var killedWaveEnemies:Number;
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
		}
		
		/*
			When an enemy is killed
		*/
		public function killEnemy(enemy:Enemy):void
		{
			kills++;
			remainingWaveEnemies--;
			main.enemies_mc.removeChild(enemy);
			enemyContainer[enemy.getId()] = null;
			
			if(noRemainingEnemies())
			{
				waveComplete();
			}
		}
		
		
		/*____________________________________________PRIVATE FUNCTIONS____________________________________________*/
		
		/*
			Iterate to the next break/wave
		*/	
		private function waveComplete():void
		{
			Messenger.alertMessage("Wave complete!");
			
			//add break here
			waveId += 1;

			main.player.getStats().resetHealth();

			main.changeGameState("intermission");
		}

		/*
			Starts the next wave
		*/
		public function startWave():void
		{
			generateWave(waveId);
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
			unspawnedEnemies = Math.round(Math.pow(whichWave, 1.5)) + 5;
			enemySpawnTimer = 2000 - Math.round((Math.random() * 500)) - ((20 * whichWave));
			
			
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
				waveDiff = 1;
			}
			else if(_waveId >= 3 && _waveId < 8)
			{
				waveDiff = 2;
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
			switch(typeNumber)
			{
				//spawn a bandit
				case 1:
					enemy = new Bandit();
					//enemy.gotoAndStop("bandit");
					enemyNumber = Const.BANDIT;
				break;
				//spawn a guard
				case 2:
					enemy = new Guard();
					//enemy.gotoAndStop("guard");
					enemyNumber = Const.GUARD;
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
						HEALTH : 2,
						DAMAGE: 1,
						ATTACK_SPEED : 4000,
						MOVEMENT_SPEED : 1, 
						EXP_GIVEN : 20
					};
				break;

				case Const.GUARD:
					stats = { 
						HEALTH : 5,
						DAMAGE: 1,
						ATTACK_SPEED : 6000,
						MOVEMENT_SPEED : .5, 
						EXP_GIVEN : 30
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

		
	}
	
}
