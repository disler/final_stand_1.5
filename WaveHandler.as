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
		
		/*
			When an enemy is killed
		*/
		public function killEnemy(enemy:Enemy):void
		{
			remainingWaveEnemies--;
			main.removeChild(enemy);
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
			Messager.alertMessage("Wave complete!");
			
			//add break here
			waveId += 1;
			
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
			Messager.alertMessage("Begin Wave: " + waveId);
		}
		
		/*
			Creates an enemy after 'enemySpawnTimer' delay
		*/
		private function generateEnemyInterval():void
		{
			var enemyId:Number = enemyContainer.length;
			
			var enemy:Enemy = new Enemy();
			enemy.x = 10 + Math.random() * 800;
			enemy.y = 10 + Math.random() * 580;
			
			//temp click to kill
			enemy.addEventListener(MouseEvent.CLICK, killEnemyEvent);
			
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
				Messager.alertMessage("Final Enemy!");
				clearInterval(enemySpawnInterval);
			}
		}
		
		/*
			Returns a list of possible enemies based on the wave
		*/
		private function enemyFactory(wave:Number):Array
		{
			return [];
		}
		
		
		
		
		/*____________________________________________	EVENT METHODS____________________________________________*/
		/*
			When a mouse click kills an enemy
			testing method
		*/
		private function killEnemyEvent(e:MouseEvent):void
		{
			var mc = (e.target as Enemy);
			killEnemy(mc);
		}
		
		
		/*____________________________________________GETTERS - SETTERS____________________________________________*/
		
		public function getEnemies():Array
		{
			return enemyContainer;
		}

	}
	
}
