package  {

	import flash.display.MovieClip;
	import flash.events.*;
	import flash.utils.*;
	
	public class Cloner extends MovieClip{

		var cloneDelayTimer:uint;
		var fadeOutTimer:Timer;
		var main:MovieClip;
		var healthBar:HealthBar;
		var stats:StatisticEnemy;

		public function Cloner(cloneType:String, cloneTime:Number, main:MovieClip, stats:StatisticEnemy, hb:MovieClip) {
			
			//initialization
			this.gotoAndStop(cloneType);
			this.main = main;
			this.stats = stats;

			//health bar
			this.healthBar = new HealthBar(); 
			this.healthBar.loadBar(stats.getHealthMax(), stats.getHealth()); 

			//clone timeout
			cloneDelayTimer = setTimeout(fadeOut, cloneTime);			
		}

		public function setHpBarPositioning()
		{
			this.healthBar.x = this.x;
			this.healthBar.y = this.y - 35;
			main.healths_mc.addChild(healthBar);
		}

		/*
			Slowly fade out this mc
		*/
		private function fadeOut()
		{
			clearTimeout(cloneDelayTimer);

			fadeOutTimer = new Timer(100, 20);
			
			//every tick
			fadeOutTimer.addEventListener(TimerEvent.TIMER, 
			function()
			{
				alpha -= 0.05;
				healthBar.alpha -= 0.05;
			});
			
			//ticks complete
			fadeOutTimer.addEventListener(TimerEvent.TIMER_COMPLETE,
			function()
			{
				fadeOutTimer.stop();
				main.enemies_mc.removeChild(main.enemies_mc.getChildByName(name));
				main.healths_mc.removeChild(healthBar);
			});

			fadeOutTimer.start();
		}


		/*
			unload by champion dealth
		*/
		public function unloadByDeath()
		{
			main.enemies_mc.removeChild(main.enemies_mc.getChildByName(name));
			main.healths_mc.removeChild(healthBar);
			clearTimeout(cloneDelayTimer);
			fadeOutTimer.stop();
		}

	}
	
}
