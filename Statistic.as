package  {
	import flash.display.MovieClip;
	/*
		handles player statistics
	*/
	public class Statistic  {

		public var castleHealth:Number;
		public var maxCastleHealth:Number;
		public var damage:Number;
		public var attackSpeed:Number;
		public var exp:Number = 0;
		public var maxExp:Number = 0;
		public var level:Number = 0;
		public var hasLeveledUp:Number = 0;
		public var alive:Boolean = true;
		public var equippedArrows:Array;
		public var healthBar:HealthBar;
		public var main:MovieClip;
		
		/*
			Statistic initializer for new hero
		*/
		public function Statistic(HEALTHBAR:HealthBar, MAIN:MovieClip, CASTLEHEALTH:Number = 10, DAMAGE:Number = 1, ATTACK_SPEED:Number = 30, EXP:Number = 0, MAXEXP:Number = 100, LEVEL:Number = 1) { 
			castleHealth = CASTLEHEALTH;
			maxCastleHealth = CASTLEHEALTH;
			damage = DAMAGE;
			attackSpeed = ATTACK_SPEED;
			exp = EXP;
			maxExp = MAXEXP;
			level = LEVEL;
			equippedArrows = [new ArrowType("wooden_arrow"), new ArrowType("steel_arrow"), new ArrowType("empty")];
			healthBar = HEALTHBAR;
			main = MAIN;
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
		
		/*
			Generates the next required amount of exp
		*/
		public function getNextMaxExp(oldMaxExp:Number):Number
		{
			return Math.round(oldMaxExp * 1.2); 
		}

		/*
			Hero tower has taken damage
		*/
		public function takeDamage(amount:Number):void
		{
			castleHealth -= amount;
			healthBar.setHealth(castleHealth);
			main._interface.fadeInInterface();
			if (castleHealth <= 0) {
				gameOver();
			}
		}	

		/*
			When hp reaches 0
		*/
		public function gameOver()
		{

		}

		/*____________________________________________GETTERS - SETTERS____________________________________________*/
		
		public function getDamage():Number
		{
			return damage;
		}
		
		public function getEquippedArrows():Array
		{
			return equippedArrows;
		}
		
		public function getHealth():Number
		{
			return castleHealth;
		}
		
		public function getMaxHealth():Number
		{
			return maxCastleHealth;
		}


	}
	
}
