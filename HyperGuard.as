package  {

	import flash.display.MovieClip;
	import flash.events.*;
	import flash.utils.*;

	/*
		HyperGuard class
	*/
	public class HyperGuard extends Enemy {

		public var defaultFrameTimeout:uint;

		public function HyperGuard () {}

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

		/*
			handles recieving damage, blocks and reduces damage sometimes
		*/
		override public function recieveDamage(__amt:Number):void
		{
			var _amt:Number = __amt;

			var occ:Number = m.player.getStats().occurrence("glyph of penetration");
			var pierced:Boolean = m.player.getStats().pierceEnemy(occ);

			//block the attack and take reduced damage 100%
			var block:Number = Math.random() * 100;
			if(block < Const.HYPER_GUARD_BLOCK_CHANCE && !pierced)
			{

				//animation
				setPreviousFrame(this.I.currentLabel);
				this.I.gotoAndStop("block");
				defaultFrameTimeout = setTimeout(function()
				{
					if(stats.isAlive())
					{
						I.gotoAndStop(getPreviousFrame());
					}
					clearTimeout(defaultFrameTimeout);
				}, Const.HYPER_GUARD_BLOCK_TIME);

				//damage reduce
				_amt = Math.ceil(_amt * 0);
			}
			else//if not blocked
			{
				stats.reduceHealth(_amt);
				healthBar.setHealth(getStats().getHealth());
				if(stats.getHealth() <= 0 && stats.isAlive()) {
					stats.setAlive(false);
					getStats().setMovementSpeed(0);
					this.I.gotoAndStop("die");
					deathAnimationDurationTimer = 0;
				}

				this.blood_mc.gotoAndPlay("blood" + Main.random(4));
			}
			return;
		}

	}
	
}
