package  {
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	import flash.utils.setInterval;
	/*
		Base class for all enemies
	*/
	public class Enemy extends MovieClip {
		
		public var enemyType:String;
		public var id:Number;
		public var stats:StatisticEnemy, m:MovieClip, healthBar:MovieClip;
		
		public var deathAnimatoinDuration:Number = 40, DADT:Number = 0;

		public function Enemy() {}
		
		
		/*
			Handles recieving damage
		*/
		public function recieveDamage(_amt:Number):void
		{
			stats.health -= _amt;
			healthBar.setHealth(getStats().getHealth());
			if(stats.getHealth() <= 0 && stats.isAlive()) {
				stats.alive = false;
				this.gotoAndStop("die");
				DADT = 0;
			}
			this.blood_mc.gotoAndPlay("blood" + Main.random(4));
			return;
		}
		/*
			Handles fading as the enemy death animation is playing and has stopped.
		*/
		public function enterFrameHandler(e:Event):void
		{
		// [My] Health bar Handling
			healthBar.x = x;
			healthBar.y = y - 35;
		// Movement Handling
			var ttt:Number = 150;
			if(x < m.player.x - ttt) x += stats.movementSpeed;
			if(x > m.player.x + ttt) x -= stats.movementSpeed;
			if(y < m.player.y - ttt) y += stats.movementSpeed;
			if(y > m.player.y + ttt) y -= stats.movementSpeed;
			this.rotation = (Math.atan2(m.player.y - this.y, m.player.x - this.x) * (180 / Math.PI)) + 90;
		// Death Handling
			if(!stats.alive) {
				if(++DADT > 25) {
					this.alpha -= 0.02;
					healthBar.alpha -= 0.02;
					if(this.alpha < 0.01) {
						UNLOAD();
					}
				}
			}
			return;
		}
		/*
			UNLOADS
		*/
		public function UNLOAD():void
		{
			m.player.getStats().gainExp(getStats().getExpGiven());
			m.healths_mc.removeChild(healthBar);
			m.waveHandler.killEnemy(this);
			removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
			return;
		}
		
		
	



		/*____________________________________________GETTERS - SETTERS____________________________________________*/




		public function getStats():StatisticEnemy
		{
			return stats;
		}

		/*
			Obtains array container index id
		*/
		public function getId():Number
		{
			return id;
		}
		
		/*
			Set enemy index
		*/
		public function setId(n:Number):void
		{
			id = n;
		}


		/*
			Loads information for this enemy class.
		*/
		public function LOAD(MAIN:MovieClip, STATS:StatisticEnemy):void
		{
			m = MAIN;
			stats = STATS;

			healthBar = new HealthBar(); 
			healthBar.loadBar(stats.getHealthMax(), stats.getHealth()); // SET CLASS TYPE VARIABLES HERE
			m.healths_mc.addChild(healthBar);

			this.hitbox_mc.visible = m.HITBOXES_VISIBLE;
			addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}


	}
	
}
