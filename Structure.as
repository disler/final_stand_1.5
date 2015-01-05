package  {

	import flash.display.MovieClip;
	import flash.events.*;
	import flash.utils.*;
	
	public class Structure extends MovieClip{

		private var id:Number;
		private var hp:Number;
		private var maxHp:Number;
		private var respawnTimeout:uint;
		private var type:Number;
		private var healthBar:HealthBar;
		private var main:MovieClip
		private var alive:Boolean = true;
		private var reviveTimeout:uint; 
		private var fadeOutTimer:Timer = null;
		private var projectileInterval:uint;
		private const projectileType:String = Const.DARK_BOMB_PROJECTILE;


		
		public function Structure(type:Number, main:MovieClip) {
			this.type = type;
			this.main = main;
			structureFactory(type);
			healthBar = new HealthBar();
			healthBar.setHealth(hp);
			projectileInterval = setInterval(fireProjectile, 5000 + Math.random() * Const.STRUCTURE_PROJECTILE_INTERVAL[type]);
		}


		/*
			Projectile interval
		*/
		private function fireProjectile():void
		{
			this.rotation = (Math.atan2(main.player.y - this.y, main.player.x - this.x) * (180 / Math.PI)) + 90;
			if(alive)
			{
				main.con.fireEnemyProjectile(projectileType,
											this.x,
											this.y,
											this.rotation,
											new StatisticEnemy({
													HEALTH : 10,
													DAMAGE: 3,
													ATTACK_SPEED : 1,
													MOVEMENT_SPEED : 1, 
													EXP_GIVEN : 1,
													LOOT_TIER : 0
												})
											);
			}
		}


		/*
			Take damage, if die temp destory
		*/
		public function recieveDamage(damage:Number):void
		{
			if(alive)
			{
				hp -= damage;
				if(hp <= 0)
				{
					hp = 0;
					alive = false;
					temporaryDestroy();
				}
				healthBar.setHealth(hp);
			}
		}

		/*
			Destroy and remove this object from view for an amount of time
		*/
		private function temporaryDestroy():void
		{
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
			});
			fadeOutTimer.start();

			reviveTimeout = setTimeout(revive, Const.STRUCTURE_REVIVE_TIME[type]);
		}

		/*
			Bring structure back to life
		*/
		private function revive()
		{
			hp = maxHp;
			alive = true;
			healthBar.setHealth(hp);
			this.alpha = 1;
			healthBar.alpha = 1;
			fadeOutTimer.stop();
		}


		/*
			Loads health bar positioning
		*/
		public function loadHealthBar():void
		{
			main.healths_mc.addChild(healthBar);
			healthBar.loadBar(maxHp, hp); // SET CLASS TYPE VARIABLES HERE
			healthBar.x = this.x;
			healthBar.y = this.y - 45;
			
		}

		/*
				Creates structure stats
		*/
		private function structureFactory(type:Number)
		{
			switch(type)
			{
				case Const.STRUCTURE_DARK_WELL:
					maxHp = 10;
					hp = maxHp;
				break;
			}
		}


		/*
			unload by champion dealth
		*/
		public function unloadByDeath()
		{
			main.enemies_mc.removeChild(main.enemies_mc.getChildByName(name));
			main.healths_mc.removeChild(healthBar);
			main.waveHandler.removeStructure(this);
			clearTimeout(reviveTimeout);
			clearInterval(projectileInterval);
			if(fadeOutTimer)
			{
				fadeOutTimer.stop();
			}
		}


		public function setId(id:Number)
		{
			this.id = id;
		}

		public function isAlive():Boolean
		{
			return alive;
		}


	}
	
}
