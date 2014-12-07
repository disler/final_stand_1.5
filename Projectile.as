package {
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
		public function loadProjectile(X:Number, Y:Number, M:MovieClip, R:Number, _heroStats:Object, _arrowSelected:ArrowType) { 
			x = X; y = Y; m = M; 



			rotation = R + _arrowSelected.getAdjustedAccuracy() + ArrowType.getAdjustedAccuracy(_heroStats.accuracy); 
			speed = _arrowSelected.getSpeed() + _heroStats.bowSpeed; 
			damage = _heroStats.damage + _arrowSelected.getDamage();
			gotoAndStop(_arrowSelected.getType());
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
				if(m.waveHandler.getEnemies()[i] != null && (m.waveHandler.getEnemies()[i]).getStats().isAlive()) {
					if(contactedEnemy == null) {
						if((m.waveHandler.getEnemies()[i]).hitbox_mc.hitTestObject(this)) {
							contactEnemy(m.waveHandler.getEnemies()[i]);
						}
					}
				}
			}

			//TODO: Add radius to arrows and add drop


			// Rotation Handling
			var ychange:Number, xchange:Number;
			ychange = ( Math.cos ( (Math.PI/180) * rotation ) ) * speed; // learn: This is cool!
			xchange = ( Math.sin ( (Math.PI/180) * rotation ) ) * speed; // learn: This is cool!
			y = y - ychange;
			x = x + xchange;
		}
	}
}
