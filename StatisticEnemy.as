package  {
	import flash.display.MovieClip;
	public class StatisticEnemy  {
		public var health:Number, healthMax;
		public var damage:Number;
		public var attackSpeed:Number;
		public var movementSpeed:Number;
		public var alive:Boolean = true;
		public function StatisticEnemy(HEALTH:Number = 3, DAMAGE:Number = 1, ATTACK_SPEED:Number = 30, MOVEMENT_SPEED:Number = 2) { 
			health = healthMax = HEALTH;
			damage = DAMAGE;
			attackSpeed = ATTACK_SPEED;
			movementSpeed = MOVEMENT_SPEED;
		}
	}
	
}
