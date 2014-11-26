package  {
	import flash.display.MovieClip;
	public class Hero extends MovieClip {
		public var m:MovieClip;
		public function Hero() {
			
		}
		/*
			Loads in the hero.
		*/
		public function loadHero(X:Number, Y:Number, M:MovieClip):void {
			x = X;
			y = Y;
			m = M;
			return;
		}
	}
	
}
