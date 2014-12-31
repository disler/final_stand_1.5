package {
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.utils.*;
	
	
	/*
		Contains all the possible attachable projectile movieclips
	*/
	public class Projectile extends MovieClip {
		public var m:MovieClip;
		public var speed:Number, damage:Number;
		private var arrowType:ArrowType;
		public static var AOECount:Number = 0;
		private var distanceTimeout:uint;
		
		public var contactedEnemy:MovieClip;
		public function Projectile() { 
			
		}
		/*
			Loads in, and sets enter frame.
		*/
		public function loadProjectile(X:Number, Y:Number, M:MovieClip, R:Number, _heroStats:Object, _arrowSelected:ArrowType) { 
			x = X; y = Y; m = M; 

			arrowType = _arrowSelected;

			rotation = R + _arrowSelected.getAdjustedAccuracy() + ArrowType.getAdjustedAccuracy(_heroStats.accuracy); 
			speed = _arrowSelected.getSpeed() + _heroStats.bowSpeed; 
			damage = _heroStats.damage + _arrowSelected.getDamage();
			gotoAndStop(_arrowSelected.getType());
			addEventListener(Event.ENTER_FRAME, projectileEFHandler);
			this.hitbox_mc.visible = M.HITBOXES_VISIBLE;

			distanceTimeout = setTimeout(kill, Const.ARROW_DISTANCE_TIMEOUT);
		}


		/*
			Handles hit testing enemy
		*/
		public function contactEnemy(_tar:MovieClip):void {
			contactedEnemy = _tar;
			var dealDamage:Number = damage;

			var occ:Number = m.player.getStats().occurrence("glyph of death");
			if(occ > 0)
			{
				if(m.player.getStats().instantDeath(occ))
				{
					dealDamage = (_tar as Enemy).getStats().getHealthMax();
				}
			}

			_tar.recieveDamage(dealDamage);

			//area of effect
			if(arrowType.doesHaveEffect(Const.SOME_AOE_EFFECT))
			{
				var aoe:AOE = new AOE(m, arrowType.getType(), damage, _tar);
				aoe.x = this.x;
				aoe.y = this.y;
				aoe.name = "aoe" + AOECount;
				AOECount++;

				m.arrows_mc.addChild(aoe);
				if(arrowType.getType() == "earth arrow") aoe.rotation = this.rotation;
			}

			//if this arrow does not pierces through enemies, remove it, otherwise it will damage all enemies
			if(!arrowType.doesHaveEffect(Const.PIERCE_EFFECT))
			{
				// UNLOAD
				removeEventListener(Event.ENTER_FRAME, projectileEFHandler);
				m.arrows_mc.removeChild(this);
				clearTimeout(distanceTimeout);
			}
			else
			{
				//reset contacted enemy so more can be hit
				contactedEnemy = null;
			}

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

			// Rotation Handling
			var ychange:Number, xchange:Number;
			ychange = ( Math.cos ( (Math.PI/180) * rotation ) ) * speed; // learn: This is cool!
			xchange = ( Math.sin ( (Math.PI/180) * rotation ) ) * speed; // learn: This is cool!
			y = y - ychange;
			x = x + xchange;
		}

		public function getArrowType():ArrowType
		{
			return arrowType;
		}


		/*
			Length timeout
		*/
		public function kill():void
		{
			removeEventListener(Event.ENTER_FRAME, projectileEFHandler);
			m.arrows_mc.removeChild(m.arrows_mc.getChildByName(name));
			clearTimeout(distanceTimeout);
		}

	}
}
