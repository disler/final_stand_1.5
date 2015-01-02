package  {
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.utils.*;
	
	/*
		BossB class
	*/
	public class BossB extends Enemy {



		public function BossB() {}
		
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


			
			if(x < m.player.x - Const.BOSS_WIDTH_BORDER - Math.random() * Const.ARCHER_WIDTH_OFFSET) {
				x += getStats().movementSpeed;
			} 
			else if (x > m.player.x + Const.BOSS_WIDTH_BORDER + Math.random() * Const.ARCHER_WIDTH_OFFSET) {
				x -= getStats().movementSpeed;
			}
			else if (!endMovementX){
				endMovementX = true;
			}

			if(y < m.player.y - Const.BOSS_HEIGHT_BORDER - Math.random() * Const.ARCHER_HEIGHT_OFFSET) {
				y += getStats().movementSpeed;
			}
			else if(y > m.player.y + Const.BOSS_HEIGHT_BORDER + Math.random() * Const.ARCHER_HEIGHT_OFFSET) {
				y -= getStats().movementSpeed;
			}
			else if(!endMovementY) {
				endMovementY = true;
			}

			if(endMovementX && endMovementY) {
				this.I.gotoAndStop("stand");
				
				radius = Math.sqrt(
									Math.pow(m.player.x - this.x, 2) + Math.pow(m.player.y - this.y, 2)
									);


				//FIGURE OUT ORIGINAL ROTATIOn
				currentAngle = -(this.rotation / 360);


				addEventListener(Event.ENTER_FRAME, handleStrife);
				removeEventListener(Event.ENTER_FRAME, handleMovementEvent);
				combatInterval = setInterval(combat, getStats().getAttackSpeed());

				strifeTimeout = setTimeout(strifeToggle, Const.TOGGLE_STRIFE_BOSS+ Math.random() + 10000);
			
			}
		}	

		/*
			Toggle strife stage
		*/
		private function strifeToggle()
		{
			strifeBoolean = !strifeBoolean;

			strifeTimeout = setTimeout(strifeToggle, Const.TOGGLE_STRIFE_BOSS + Math.random() + 10000);

		}

		var currentAngle = 0;
		var angleStep = .002;
		var twoPI = 2 * Math.PI;
		var radius;
		var strifeBoolean:Boolean = true;
		private function handleStrife(e:Event) {
			
			if(strifeBoolean)
			{
				currentAngle += angleStep;
			}
			else
			{
				currentAngle -= angleStep;
			}
			
			this.x = m.player.x + Math.cos(currentAngle * twoPI) * radius;
			this.y = m.player.y + Math.sin(currentAngle * twoPI) * radius;

			if (currentAngle < -1 ) 
			{
				currentAngle = 0;

			}
		}	

		/*
			Called after 'attackSpeed', fires projectile to kill enemy
		*/
		override public function combat():void
		{

			I.gotoAndStop("attack");
			display();
			fadeTimer = new Timer(200, 10);

			fadeTimer.addEventListener(TimerEvent.TIMER,
			function()
			{
				alpha -= .10;	
				healthBar.alpha -= .10;
			});

			fadeTimer.addEventListener(TimerEvent.TIMER_COMPLETE,
			function()
			{
				fadeTimer.stop();
			});
			fadeTimer.start();

			//delay for animation to shoot out projectile
			damageDelay = setTimeout(function()
			{
				//fire mage projectile toward enemy
				m.con.fireEnemyProjectile(Const.ARCHER_PROJECTILE_DARK_DOUBLE, x, y, rotation, stats);

			}, Const.ARCHER_ATTACK_DELAY_TIMER);

			return;
		}

		/*
			Display this wave
		*/
		private function display():void
		{
			healthBar.alpha = 1;
			this.alpha = 1;
		}

	}
	
}
