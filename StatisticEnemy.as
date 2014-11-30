package  {
	import flash.display.MovieClip;
	
	/*
		Contains statistics for all enemies
	*/
	public class StatisticEnemy  {
		public var health:Number, healthMax;
		public var damage:Number;
		public var attackSpeed:Number;
		public var movementSpeed:Number;
		//oncase his speed was set to 0
		public var baseMovementSpeed:Number;
		public var expGiven:Number;
		public var alive:Boolean = true;
		
		public function StatisticEnemy(stats:Object) { 
			health = healthMax = Number(stats.HEALTH);
			damage = Number(stats.DAMAGE);
			attackSpeed = Number(stats.ATTACK_SPEED);
			movementSpeed = Number(stats.MOVEMENT_SPEED);
			baseMovementSpeed = Number(stats.MOVEMENT_SPEED);
			expGiven = Number(stats.EXP_GIVEN);
		}

		/*
			Reduce health by x amount
		*/
		public function reduceHealth(_amt:Number):void
		{
			health -= _amt;
			if(health < 0)
			{
				health = 0;
			}
		}




		/*____________________________________________GETTERS - SETTERS____________________________________________*/
		
		public function getExpGiven():Number
		{
			return expGiven;
		}

		public function getHealth():Number
		{
			return health;
		}

		public function getHealthMax():Number
		{
			return healthMax;
		}

		public function getDamage():Number
		{
			return damage;
		}

		public function getAttackSpeed():Number
		{
			return attackSpeed;
		}

		public function getMovementSpeed():Number
		{
			return movementSpeed;
		}

		public function isAlive():Boolean
		{
			return alive;
		}





		public function setHealth(val:Number):void
		{
			health = val;
		}

		public function setDamage(val:Number):void
		{
			damage = val;
		}

		public function setAttackSpeed(val:Number):void
		{
			attackSpeed = val;
		}

		public function setMovementSpeed(val:Number):void
		{
			movementSpeed = val;
		}

		public function setAlive(val:Boolean):void
		{
			alive = val;
		}





	}
	
}
