package  {
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.utils.setInterval;
	import flash.utils.setTimeout;
	
	/*
		Assassian class
	*/
	public class Assassian extends Enemy {

		private var stealth:Boolean = true;

		public function Assassian() {}
		
		/*
			Loads information for this enemy class.
		*/
		override public function LOAD(MAIN:MovieClip, STATS:StatisticEnemy):void
		{
			//default load behavior
			defaultLoad(MAIN, STATS);

			handleStealth();

			//add listeners
			addEventListener(Event.ENTER_FRAME, enterFrameEvent);
			addEventListener(Event.ENTER_FRAME, handleMovementEvent);
		}

		/*
			Handles stealth
		*/
		private function handleStealth():void
		{
			if(stealth)
			{
				this.alpha = .02;
				healthBar.alpha = 0;
			}
			else
			{
				this.alpha = 1;
				healthBar.alpha = 1;
			}
		}


		/*
			Handles being detected or going out of stealth
		*/
		public function unstealth():void
		{
			stealth = false;
			handleStealth();
		}

		/*
			Places into stealth
		*/
		public function inStealth():void
		{
			stealth = true;
			handleStealth();
		}



		/*____________________________________________ EVENTS ____________________________________________*/

		private function enterFrameEvent(e:Event):void
		{
			handleDeath();
			setHpBarPositioning();
			handleRotation();
		}

		private function handleMovementEvent(e:Event):void
		{
			this.handleMovement();
		}


		/*________________________________________________FUNCTIONS________________________________________________*/
		/*
			Handles player movement every frame
			Default, is to walk up to walk up to the castle
		*/
		override public function handleMovement() {
			
			if(x < m.player.x - Const.CASTLE_WIDTH_BORDER) {
				x += getStats().movementSpeed;
			} 
			else if (x > m.player.x + Const.CASTLE_WIDTH_BORDER) {
				x -= getStats().movementSpeed;
			}
			else {
				endMovementX = true;
			}

			if(y < m.player.y - Const.CASTLE_HEIGHT_BORDER) {
				y += getStats().movementSpeed;
			}
			else if(y > m.player.y + Const.CASTLE_HEIGHT_BORDER) {
				y -= getStats().movementSpeed;
			}
			else {
				endMovementY = true;
			}

			if(endMovementX && endMovementY) {
				this.I.gotoAndStop("stand");
				removeEventListener(Event.ENTER_FRAME, handleMovementEvent);

				unstealth();
				combat();
				
				combatInterval = setInterval(combat, getStats().getAttackSpeed());
			}

		}


		/*
			Called after 'attackSpeed', fires projectile to kill enemy
		*/
		override public function combat():void
		{
			I.gotoAndStop("attack");
			damageDelay = setTimeout(function()
			{
				m.player.getStats().takeDamage(getStats().getDamage());
			}, Const.ASSASSIAN_ATTACK_DELAY_TIMER);
			return;
		}

		


	}
	
}
