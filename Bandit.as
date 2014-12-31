package  {
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.utils.setInterval;
	
	/*
		Bandit class
	*/
	public class Bandit extends Enemy {

		public function Bandit() {}
		
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

		override public function enterFrameEvent(e:Event):void
		{
			handleDeath();
			setHpBarPositioning();
			handleRotation();
		}

		override public function handleMovementEvent(e:Event):void
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
				combatInterval = setInterval(combat, getStats().getAttackSpeed());
			}

		}

		


	}
	
}
