﻿package  {
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	import flash.utils.setInterval;

	/*
		Base class for all enemies
	*/
	public class Enemy extends MovieClip {
		
		public var enemyType:String;
		public var id:Number;
		public var stats:StatisticEnemy, m:MovieClip, healthBar:MovieClip;
		
		public var deathAnimatoinDuration:Number = 40
		public var deathAnimationDurationTimer:Number = 0;
		
		public var currentAction:Number;
		var endMovementX:Boolean = false;
		var endMovementY:Boolean = false;

		protected var combatInterval:uint;
		protected var damageDelay:uint;

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
				this.gotoAndStop("die");
				deathAnimationDurationTimer = 0;
			}
			this.blood_mc.gotoAndPlay("blood" + Main.random(4));
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
			clearEvents();
			return;
		}


		/*
			When the 'LOAD' function is called by children, this is shared behavior
		*/
		protected function defaultLoad(MAIN:MovieClip, STATS:StatisticEnemy)
		{
			m = MAIN;
			stats = STATS;
			healthBar = new HealthBar(); 
			healthBar.loadBar(stats.getHealthMax(), stats.getHealth()); // SET CLASS TYPE VARIABLES HERE
			m.healths_mc.addChild(healthBar);
			this.hitbox_mc.visible = m.HITBOXES_VISIBLE;
		}


		/*____________________________________________ EVENTS ____________________________________________*/



		
		/*____________________________________________ TO OVERRIDE ____________________________________________*/
		
		/*
			Called after 'attackSpeed', deal damage to hero after displaying attack animation
		*/
		protected function combat():void
		{
			damageDelay = setTimeout(function()
			{
				var animationDelay:uint = setTimeout(function()
				{
					gotoAndStop("attack");
					m.player.getStats().takeDamage(getStats().getDamage());
					clearTimeout(animationDelay);
				}, 1000);
			}, Const.BANDIT_ATTACK_TIME_DELAY);
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


		
		/* EVENT HANDLER HANDLER */
		private var arrListeners:Array = [];
		override public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void
		{
			super.addEventListener(type, listener, useCapture, priority, useWeakReference);
			arrListeners.push({type:type, listener:listener});
		}

		private function clearEvents():void
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
