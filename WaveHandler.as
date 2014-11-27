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
		private var enemySpawnTimer:Number;
		private var enemySpawnInterval:uint;
		
		//contains all currently spawned enemies
		private var enemyContainer:Array = [];
		private var remainingWaveEnemies:Number;
		private var killedWaveEnemies:Number;
		private var totalEnemiesKilled:Number;
		
		
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
		
		
		
		
		
		
		/*____________________________________________PRIVATE FUNCTIONS____________________________________________*/
		
		/*
			Determines how many enemies to create and when, based on the wave
		*/
		private function generateWave(whichWave:Number):void
		{
			unspawnedEnemies = (whichWave * 5) + 5;
			enemySpawnTimer = 500 + (Math.random() * (100 * 20 - whichWave));
			enemySpawnInterval = setInterval(generateEnemy, enemySpawnTimer);
		}
		
		/*
			Creates an enemy after 'enemySpawnTimer' delay
		*/
		public function generateEnemy():void
		{
			//trace("spawning enemy");
			
			var enemyId:Number = enemyContainer.length;
			
			var enemy:Enemy = new Enemy();
			enemy.y = 0 + Math.random() * 860;
			enemy.x = 0 + Math.random() * 640;
			enemy.m = main;
			enemy.s = new StatisticEnemy();
			enemy.LOAD();
			
			//temp click to kill
			//enemy.addEventListener(MouseEvent.CLICK, killEnemy);
			
			for(var i:Number = 0; i < enemyContainer.length; i++)
			{
				if(enemyContainer[i] == null)
				{
					enemyContainer[i] = enemy;
					enemy.setId(i);
					break;
				}
			}
			
			main.addChild(enemy);
			
			unspawnedEnemies--;
			if(unspawnedEnemies == 0)
			{
				trace("done");
				clearInterval(enemySpawnInterval);
			}
		}
		
		
		/*
			TEST FUNCTION TO KILL
		*/	
		public function killEnemy(mc:Enemy):void
		{
			enemyContainer[mc.getId()] = null;
			main.removeChild(mc);
			return;
		}
		
		
		
		/*____________________________________________GETTERS - SETTERS____________________________________________*/
		
		public function getEnemies():Array
		{
			return enemyContainer;
		}

	}
	
}
