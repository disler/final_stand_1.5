package  {
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.utils.*;
	
	/*
		Archer class
	*/
	public class Archer extends Enemy {

		public function Archer() {}
		
		/*
			Loads information for this enemy class.
		*/
		override public function LOAD(MAIN:MovieClip, STATS:StatisticEnemy):void
		{
			//default load behavior
			defaultLoad(MAIN, STATS);

			//add listeners
			addEventListener(Event.ENTER_FRAME, enterFrameEvent);
			addEventListener(Event.ENTER_FRAME, handleMovementEvent);
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
			
			if(x < m.player.x - Const.ARCHER_WIDTH_BORDER - Math.random() * Const.ARCHER_WIDTH_OFFSET) {
				x += getStats().movementSpeed;
			} 
			else if (x > m.player.x + Const.ARCHER_WIDTH_BORDER + Math.random() * Const.ARCHER_WIDTH_OFFSET) {
				x -= getStats().movementSpeed;
			}
			else {
				endMovementX = true;
			}

			if(y < m.player.y - Const.ARCHER_HEIGHT_BORDER - Math.random() * Const.ARCHER_HEIGHT_OFFSET) {
				y += getStats().movementSpeed;
			}
			else if(y > m.player.y + Const.ARCHER_HEIGHT_BORDER + Math.random() * Const.ARCHER_HEIGHT_OFFSET) {
				y -= getStats().movementSpeed;
			}
			else {
				endMovementY = true;
			}

			if(endMovementX && endMovementY) {
				this.I.gotoAndStop("stand");
				removeEventListener(Event.ENTER_FRAME, handleMovementEvent);
				combatInterval = setInterval(combat, getStats().getAttackSpeed());
			}

		}

		/*
			Called after 'attackSpeed', fires projectile to kill enemy
		*/
		override public function combat():void
		{
			I.gotoAndStop("attack");

			//delay for animation to shoot out projectile
			damageDelay = setTimeout(function()
			{
				//fire mage projectile toward enemy
				m.con.fireEnemyProjectile(Const.ARCHER_PROJECTILE, x, y, rotation, stats);

			}, Const.ARCHER_ATTACK_DELAY_TIMER);

			return;
		}

		


	}
	
}
