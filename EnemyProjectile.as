package  {
	
	import flash.display.MovieClip;
	import flash.events.*;

	/*
		Represents all possible enemy projectile
	*/
	public class EnemyProjectile extends MovieClip {

		private var main:MovieClip;
		private var stats:StatisticEnemy;
		private var type:String;
		private var speed:Number;

		public function EnemyProjectile(type:String, _x:Number, _y:Number, rot:Number, stats:StatisticEnemy, m:MovieClip) {
			main = m;
			this.type = type;
			this.stats = stats;
			this.speed = getThisProjectileSpeed(type);

			this.x = _x;
			this.y = _y;

			this.gotoAndStop(type);
			this.rotation = rot;
			addEventListener(Event.ENTER_FRAME, enterFrameEvent);

		}

		/*
			Looks to hit enemy target
		*/
		private function contactEnemy():void
		{
			if(this.hitTestObject(main.player))
			{
				removeEventListener(Event.ENTER_FRAME, enterFrameEvent);
				main.arrows_mc.removeChild(this);
				main.player.getStats().takeDamage(stats.getDamage());
			}
		}

		/*
			Handles projectile movement
		*/
		private function movement():void
		{
			var ychange:Number, xchange:Number;
			ychange = ( Math.cos ( (Math.PI/180) * this.rotation ) ) * speed; // learn: This is cool!
			xchange = ( Math.sin ( (Math.PI/180) * this.rotation ) ) * speed; // learn: This is cool!
			y = y - ychange;
			x = x + xchange;
		}


		/*
			Obtains this projectiles speed based on it's type
		*/
		private function getThisProjectileSpeed(type:String):Number
		{
			var spd:Number = 1;

			switch(type)
			{
				case Const.MAGE_PROJECTILE:
					spd = 5;
				break;
			}

			return spd;
		}



		/*______________________EVENTS__________________________*/

		/*
			Searchs for hit test
		*/	
		private function enterFrameEvent(e:Event):void
		{
			contactEnemy();
			movement();
		}

	}
	
}
