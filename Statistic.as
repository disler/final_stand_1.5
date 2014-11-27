package  {
	import flash.display.MovieClip;
	/*
		Passed as a dynamic variable.
	*/
	public class Statistic  {
		public var health:Number;
		public var damage:Number;
		public var attackSpeed:Number;
		public var alive:Boolean = true;
		public function Statistic(HEALTH:Number = 60, DAMAGE:Number = 1, ATTACK_SPEED:Number = 30) { 
			health = HEALTH;
			damage = DAMAGE;
			attackSpeed = ATTACK_SPEED;
		}
	}
	
}
