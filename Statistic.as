﻿package  {
	import flash.display.MovieClip;
	/*
		Passed as a dynamic variable.
	*/
	public class Statistic  {
		public var health:Number;
		public var damage:Number;
		public var attackSpeed:Number;
		public var exp:Number = 0;
		public var maxExp:Number = 0;
		public var level:Number = 0;
		public var hasLeveledUp:Number = 0;
		public var alive:Boolean = true;
		
		/*
			Statistic initializer for new hero
		*/
		public function Statistic(HEALTH:Number = 60, DAMAGE:Number = 1, ATTACK_SPEED:Number = 30, EXP:Number = 0, MAXEXP:Number = 100, LEVEL:Number = 1) { 
			health = HEALTH;
			damage = DAMAGE;
			attackSpeed = ATTACK_SPEED;
			exp = EXP;
			maxExp = MAXEXP;
			level = LEVEL;
		}
		
		/*
			increased exp, if overlap: level up and alert
		*/
		public function gainExp(amount:Number):void
		{
			exp += amount;
			
			if(exp > maxExp)
			{
				
				//increase level
				level += 1;
				//overlap exp
				exp = exp - maxExp;
				//stack any current 'level ups'
				hasLeveledUp += 1;
				//obtain next 'maxExp' amount
				maxExp = getNextMaxExp(maxExp);

				Messenger.alertMessage("You have leved up! Level: " + level);
			}
		}
		
		public function getNextMaxExp(oldMaxExp:Number):Number
		{
			return Math.round(oldMaxExp * 1.2); 
		}



		/*____________________________________________GETTERS - SETTERS____________________________________________*/
		
		public function getDamage():Number
		{
			return damage;
		}
	}
	
}
