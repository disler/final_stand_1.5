package  {
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.utils.*;
	
	/*
		First boss class
	*/
	public class BossA extends Enemy {

		public function BossA() {}
		
		/*
			Loads information for this enemy class.
		*/
		override public function LOAD(MAIN:MovieClip, STATS:StatisticEnemy):void
		{
			//default load behavior
			defaultLoad(MAIN, STATS);

			isBoss = true;

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
			
			if(x < m.player.x - Const.BOSS_WIDTH_BORDER - Math.random() * Const.ARCHER_WIDTH_OFFSET) {
				x += getStats().movementSpeed;
			} 
			else if (x > m.player.x + Const.BOSS_WIDTH_BORDER + Math.random() * Const.ARCHER_WIDTH_OFFSET) {
				x -= getStats().movementSpeed;
			}
			else {
				endMovementX = true;
			}

			if(y < m.player.y - Const.BOSS_HEIGHT_BORDER - Math.random() * Const.ARCHER_HEIGHT_OFFSET) {
				y += getStats().movementSpeed;
			}
			else if(y > m.player.y + Const.BOSS_HEIGHT_BORDER + Math.random() * Const.ARCHER_HEIGHT_OFFSET) {
				y -= getStats().movementSpeed;
			}
			else {
				endMovementY = true;
			}

			if(endMovementX && endMovementY) {
				this.I.gotoAndStop("stand");
				removeEventListener(Event.ENTER_FRAME, handleMovementEvent);
				combatInterval = setInterval(combat, getStats().getAttackSpeed());
				teleportInterval = setInterval(teleport, Const.BOSS_A_TELEPORT_INTERVAL + Math.random() * 1000);
			}

		}

		/*
			After x time, teleport to new location, leave a clone behind
		*/
		var teleportCoord:Object = {
			0 : {"x" : 150, "y" : 150},
			1 : {"x" : 450, "y" : 115},
			2 : {"x" : 750, "y" : 115},
			3 : {"x" : 150, "y" : 330},
			4 : {"x" : 765, "y" : 300},
			5 : {"x" : 150, "y" : 540},
			6 : {"x" : 450, "y" : 550},
			7 : {"x" : 730, "y" : 530}
		};

		var randTele:Object;
		private function teleport():void
		{
			if(getStats().isAlive())
			{
				this.I.gotoAndStop("teleport");
				var tempTimeout:uint = setTimeout(function()
				{
					var cloneA:Cloner = new Cloner("bossA", (3000 + Math.random() * 3000), m, getStats(), healthBar);
					
					cloneA.x = x;
					cloneA.y = y;
					cloneA.rotation = rotation;
					cloneA.setHpBarPositioning();
					m.enemies_mc.addChild(cloneA);


					randTele = teleportCoord[Math.floor(Math.random() * 8)];
					x = randTele.x; 
					y = randTele.y; 
				}, 825);
			}
		}

		/*
			Called after 'attackSpeed', fires projectile to kill enemy
		*/
		override public function combat():void
		{
			if(I.currentLabel != "teleport" && getStats().isAlive())
			{
				I.gotoAndStop("attack");
			}

			//delay for animation to shoot out projectile
			damageDelay = setTimeout(function()
			{
				//fire mage projectile toward enemy
				m.con.fireEnemyProjectile(Const.ARCHER_PROJECTILE_DARK, x, y, rotation, stats);

			}, Const.ARCHER_ATTACK_DELAY_TIMER);

			return;
		}

		


	}
	
}
