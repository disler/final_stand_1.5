﻿package {
	import flash.display.MovieClip;
	import flash.events.*;
	
	
	/*
		Contains all the possible attachable projectile movieclips
	*/
	public class Projectile extends MovieClip {
		public var m:MovieClip;
		public var speed:Number, damage:Number;
		
		public var contactedEnemy:MovieClip;
		public function Projectile() { 
			
		}
		/*
			Loads in, and sets enter frame.
		*/
		public function loadProjectile(X:Number, Y:Number, M:MovieClip, R:Number, _speed:Number, _damage:Number) { 
			x = X; y = Y; m = M; rotation = R; speed = _speed; damage = _damage;
			addEventListener(Event.ENTER_FRAME, projectileEFHandler);
			this.hitbox_mc.visible = M.HITBOXES_VISIBLE;
		}
		public function contactEnemy(_tar:MovieClip):void {
			contactedEnemy = _tar;
			_tar.recieveDamage(damage);
			
			// UNLOAD
			removeEventListener(Event.ENTER_FRAME, projectileEFHandler);
			m.arrows_mc.removeChild(this);
			return;
		}
		/*
			Handles hittesting and movement.
		*/
		public function projectileEFHandler(e:Event) { 
		// Enemy HitTest Handling
			for(var i:Number = 0; i < m.waveHandler.getEnemies().length; i++) {
				if(m.waveHandler.getEnemies()[i] != null && (m.waveHandler.getEnemies()[i]).s.alive) {
					if(contactedEnemy == null) {
						if((m.waveHandler.getEnemies()[i]).hitbox_mc.hitTestObject(this)) {
							contactEnemy(m.waveHandler.getEnemies()[i]);
						}
					}
				}
			}
		// Rotation Handling
			var ychange:Number, xchange:Number;
			// precondition: array of enemies exists to shuffle through
			// do: look for enemies to hittest.
			//y--;
			ychange = ( Math.cos ( (Math.PI/180) * rotation ) ) * speed; // learn: This is cool!
			xchange = ( Math.sin ( (Math.PI/180) * rotation ) ) * speed; // learn: This is cool!
			y = y - ychange;
			x = x + xchange;
		}
	}
}