package {
	import flash.display.MovieClip;
	import flash.events.*;
	
	
	/*
		Contains all the possible attachable projectile movieclips
	*/
	public class Projectile extends MovieClip {
		public var m:MovieClip;
		public var speed:Number;
		public function Projectile() { 
			
		}
		/*
			Loads in, and sets enter frame.
		*/
		public function loadProjectile(X:Number, Y:Number, M:MovieClip, R:Number, _speed:Number) { 
			x = X; y = Y; m = M; rotation = R; speed = _speed;
			addEventListener(Event.ENTER_FRAME, projectileEFHandler);
		}
		/*
			Handles hittesting and movement.
		*/
		public function projectileEFHandler(e:Event) { 
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
