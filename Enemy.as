package  {
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.utils.*;

	/*
		Base class for all enemies
	*/
	public class Enemy extends MovieClip {
		
		public var eTimer:Number = 0;

		public var id:Number;
		public var stats:StatisticEnemy, m:MovieClip, healthBar:MovieClip;
		public var earthRealm:uint;

		public var deathAnimatoinDuration:Number = 40
		public var deathAnimationDurationTimer:Number = 0;
		
		public var currentAction:Number;
		var endMovementX:Boolean = false;
		var endMovementY:Boolean = false;

		protected var combatInterval:uint;
		protected var damageDelay:uint;
		protected var animationDelay:uint
		protected var teleportInterval:uint;
		protected var strifeTimeout:uint;

		protected var fadeTimer:Timer;

		public var previousFrame:String;

		public var slowPercent:Number = 0.00;
		public var thunderActive:Boolean = false;
		public var earthActive:Boolean = false;
		var iceTimeout:uint;
		var thunderTimeout:uint;

		protected var isBoss:Boolean = false;

		public function Enemy() {}
		
		/*
			Handles recieving damage
		*/
		public function recieveDamage(_amt:Number):void
		{
			
			stats.reduceHealth(_amt);
			healthBar.setHealth(getStats().getHealth());
			if(stats.getHealth() <= 0 && stats.isAlive()) {
				stats.alive = false;
				getStats().setMovementSpeed(0);
				this.I.gotoAndStop("die");
				deathAnimationDurationTimer = 0;
				SoundHandler.playSound("hit" + (1 + Main.random(6)));
			}
			this.blood_mc.gotoAndPlay("blood" + Main.random(4));
			SoundHandler.playSound("flesh" + (1 + Main.random(3)));
			return;
		}


		/*
			UNLOADS
		*/
		public function UNLOAD():void
		{
			m.player.getStats().gainExp(getStats().getExpGiven());
			m.healths_mc.removeChild(healthBar);
			m.waveHandler.killEnemy(this);
			clearClocks();
			clearEvents();
			return;
		}

		/*
			unload enemy when dead
		*/
		public function unloadByDeath():void
		{
			m.healths_mc.removeChild(healthBar);
			removeEventListener(Event.ENTER_FRAME, enterFrameEvent);
			removeEventListener(Event.ENTER_FRAME, handleMovementEvent);
			clearEvents();
			clearClocks();
			m.waveHandler.removeEnemy(this);
		}


		/*
			Clears all timers
		*/
		public function clearClocks():void
		{
			clearTimeout(damageDelay);
			clearTimeout(strifeTimeout);
			clearTimeout(animationDelay);
			clearTimeout(earthRealm);
			clearInterval(combatInterval);
			clearInterval(teleportInterval);
			if(fadeTimer)
			{
				fadeTimer.stop();
			}
			if(slideBackTimer)
			{
				slideBackTimer.stop();
			}
		}


		/*
			When the 'LOAD' function is called by children, this is shared behavior
			set enemy class visual, make them start walking
		*/
		protected function defaultLoad(MAIN:MovieClip, STATS:StatisticEnemy)
		{
			m = MAIN;
			stats = STATS;
			healthBar = new HealthBar(); 
			healthBar.loadBar(stats.getHealthMax(), stats.getHealth()); // SET CLASS TYPE VARIABLES HERE
			m.healths_mc.addChild(healthBar);
			this.hitbox_mc.visible = m.HITBOXES_VISIBLE;
			this.gotoAndStop(stats.getType());
			this.I.gotoAndStop("walk");
		}

		/*
			Adds status effect
		*/
		var oldSpeed:Number;
		var prevvFrame:String;
		public function addStatusEffect(type:Number, damage:Number, originalTarget:Boolean, ... args:Array)
		{
			switch(type)
			{
				case Const.AOE_THUNDER:
					if(!thunderActive)
					{
						oldSpeed = stats.getMovementSpeed();
						prevvFrame = this.I.currentLabel;
						stats.setMovementSpeed(0);

						this.I.gotoAndStop("stand");

						if(!originalTarget)
						{
							recieveDamage(damage);
						}

						thunderActive = true;

						if(stats.isAlive())
						{
							thunderTimeout = setTimeout(function()
							{
								thunderActive = false;
								stats.setMovementSpeed(oldSpeed);
								I.gotoAndStop(prevvFrame);
								clearTimeout(thunderTimeout);
							}, 3000);
						}
					}
				break;
				case Const.AOE_ICE:
					if(slowPercent <= 0.00)
					{
						oldSpeed = stats.getMovementSpeed();
						prevvFrame = this.I.currentLabel;
						slowPercent = 0.5;
						if(args[0] != null)
						{
							slowPercent = args[0];
						}
						stats.setMovementSpeed(Math.round(oldSpeed * slowPercent));
						if(stats.isAlive())
						{
							iceTimeout = setTimeout(function()
							{
								stats.setMovementSpeed(oldSpeed);
								I.gotoAndStop(prevvFrame);
								clearTimeout(iceTimeout);
							}, 3000);
						}
					}
				break;
				case Const.AOE_EARTH:
					
				break;



			}
		}

		/*
			slide back enemy in small intervals (earth arrow)
		*/
		protected var slideBackTimer:Timer;
		public function slideBack(xDir:String, yDir:String):void
		{

			earthActive = true;
			var xPush:Number = 0;
			var yPush:Number = 0;

			if(xDir == "left")
			{
				xPush = -5;
			} else
			{
				xPush = 5;
			}

			if(yDir == "up")
			{
				yPush = 5;
			} else
			{
				yPush = -5;
			}

			slideBackTimer = new Timer(50, 34);
			
			var prevMovementSpeed:Number = stats.getMovementSpeed();
			stats.setMovementSpeed(0);
			
			slideBackTimer.addEventListener(TimerEvent.TIMER, function()
			{
				x += xPush;
				y += yPush;
			});

			slideBackTimer.addEventListener(TimerEvent.TIMER_COMPLETE, function()
			{
				stats.setMovementSpeed(prevMovementSpeed);
				
				if(endMovementX || endMovementY)
				{
					endMovementY = false;
					endMovementX = false;
					addEventListener(Event.ENTER_FRAME, handleMovementEvent);
				}

				earthActive = false;
				slideBackTimer.stop();
			});

			slideBackTimer.start();

		}


		public function isEarthActive():Boolean
		{
			return earthActive
		}
		

		/*____________________________________________ EVENTS ____________________________________________*/



		
		/*____________________________________________ TO OVERRIDE ____________________________________________*/
		

		public function enterFrameEvent(e:Event):void{}
		public function handleMovementEvent(e:Event):void{}

		/*
			Called after 'attackSpeed', deal damage to hero after displaying attack animation
		*/
		public function combat():void
		{
			I.gotoAndStop("attack");
			damageDelay = setTimeout(function()
			{
				m.player.getStats().takeDamage(getStats().getDamage());
			}, Const.BANDIT_ATTACK_TIME_DELAY);
			return;
		}

		/*
			Set hp bar position
		*/
		protected function setHpBarPositioning():void
		{
			healthBar.x = x;
			healthBar.y = y - 35;
		}
		
		
		/*
			Handles player movement every frame
		*/
		public function handleMovement() {}

		/*
			Handles enemy rotation
		*/
		protected function handleRotation() {
			this.rotation = (Math.atan2(m.player.y - this.y, m.player.x - this.x) * (180 / Math.PI)) + 90;
		}
		
		/*
			Handle death
		*/
		protected function handleDeath() {
			if(!stats.alive) {
				clearTimeout(damageDelay);
				clearInterval(combatInterval);
				if(++deathAnimationDurationTimer > 25) {
					this.alpha -= 0.02;
					healthBar.alpha -= 0.02;
					if(this.alpha < 0.01) {
						UNLOAD();
					}
				}
			}
		}

		/*
			Loads information for this enemy class.
		*/
		public function LOAD(MAIN:MovieClip, STATS:StatisticEnemy):void{}

















		/*____________________________________________GETTERS - SETTERS____________________________________________*/




		public function getIsBoss():Boolean
		{
			return isBoss;
		}





		protected function getPreviousFrame():String
		{
			return previousFrame;
		}

		public function setPreviousFrame(frame:String):void
		{
			previousFrame = frame;
		}


		public function getStats():StatisticEnemy
		{
			return stats;
		}

		/*
			Obtains array container index id
		*/
		public function getId():Number
		{
			return id;
		}
		
		/*
			Set enemy index
		*/
		public function setId(n:Number):void
		{
			id = n;
		}


		public function setIsBoss(b:Boolean):void
		{
			isBoss = b;
		}

		
		/*____________________________________________ EVENT HANDLER HANDLER ____________________________________________ */
		private var arrListeners:Array = [];
		override public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void
		{
			super.addEventListener(type, listener, useCapture, priority, useWeakReference);
			arrListeners.push({type:type, listener:listener});
		}

		public function clearEvents():void
		{
		   for(var i:Number = 0; i<arrListeners.length; i++){
		      if(this.hasEventListener(arrListeners[i].type)){
		         this.removeEventListener(arrListeners[i].type, arrListeners[i].listener);
		      }
		   }
		   arrListeners = null
		}


	}
	
}
