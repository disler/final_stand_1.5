package  {
	
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.utils.*;

	/*
		Represents all possible enemy projectile
	*/
	public class EnemyProjectile extends MovieClip {

		private var main:MovieClip;
		private var stats:StatisticEnemy;
		private var type:String;
		private var speed:Number;
		public static var projCount:Number = 0; 

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

			if(main.player.getStats().occurrence("glyph of collision"))
			{
				addEventListener(Event.ENTER_FRAME, contactProjectileEvent);
			}

			projCount++;

		}

		/*
			If this projectile comes in contact with the heros projectile, test for 'glyph of collision'
		*/
		private function contactProjectileEvent(e:Event):void
		{
			for(var i:Number = 0; i < main.arrows_mc.numChildren; i++)
			{
				var _arrow:Projectile = main.arrows_mc.getChildAt(i) as Projectile;
				if(_arrow != null)
				{
					if(this.hitTestObject(_arrow))
					{
						var occ:Number = main.player.getStats().occurrence("glyph of collision");
						var roll:Boolean = main.player.getStats().pierceProjectile(occ);
						if(roll)
						{
							kill();
						}
					}
				}
			}
		}

		/*
			Remove this object
		*/
		public function kill():void
		{
			removeEventListener(Event.ENTER_FRAME, enterFrameEvent);
			removeEventListener(Event.ENTER_FRAME, contactProjectileEvent);
			main.arrows_mc.removeChild(this);
		}

		/*
			Looks to hit enemy target
		*/
		private function contactEnemy():void
		{
			if(this.hitTestObject(main.player))
			{
				kill();
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
				case Const.ARCHER_PROJECTILE:
					spd = 8;
				break;
				case Const.ARCHER_PROJECTILE_DARK:
					spd = 10;
				break;
				case Const.ARCHER_PROJECTILE_DARK_DOUBLE:
					spd = 12;
				break;
				case Const.DARK_BOMB_PROJECTILE:
					spd = 9;
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
