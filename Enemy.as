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
		public var s:StatisticEnemy, m:MovieClip;
		
		public var deathAnimatoinDuration:Number = 40, DADT:Number = 0;
		public function Enemy() {
			
		}
		/*
			Obtains array container index id
		*/
		public function recieveDamage(_amt:Number):void
		{
			s.health -= _amt;
			if(s.health <= 0 && s.alive) {
				s.alive = false;
				this.gotoAndStop("die");
				DADT = 0;
			}
			this.blood_mc.gotoAndPlay("blood" + Main.random(4));
			return;
		}
		/*
			Handles fading as the enemy death animation is playing and has stopped.
		*/
		public function enterFrameHandler(e:Event):void
		{
		// Movement Handling
			var ttt:Number = 150;
			if(x < m.player.x - ttt) x += s.movementSpeed;
			if(x > m.player.x + ttt) x -= s.movementSpeed;
			if(y < m.player.y - ttt) y += s.movementSpeed;
			if(y > m.player.y + ttt) y -= s.movementSpeed;
			this.rotation = (Math.atan2(m.player.y - this.y, m.player.x - this.x) * (180 / Math.PI)) + 90;
		// Death Handling
			if(!s.alive) {
				if(++DADT > 25) {
					this.alpha -= 0.02;
					if(this.alpha < 0.01) {
						UNLOAD();
					}
				}
			}
			return;
		}
		/*
			UNLOADS
		*/
		public function UNLOAD():void
		{
			m.waveHandler.killEnemy(this);
			removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
			return;
		}
		/*
			Obtains array container index id
		*/
		public function getId()
		{
			return id;
		}
		
		/*
			Set enemy index
		*/
		public function setId(n:Number)
		{
			id = n;
		}
		/*
			Loads information for this enemy class.
		*/
		public function LOAD():void
		{
			this.hitbox_mc.visible = m.HITBOXES_VISIBLE;
			addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}

	}
	
}