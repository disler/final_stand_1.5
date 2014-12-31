package  {
	import flash.display.MovieClip;
	public class Hero extends MovieClip {
		public var m:MovieClip;
		private var stats:Statistic;
		public function Hero() {
			
		}
		/*
			Loads in the hero.
		*/
		public function loadHero(M:MovieClip, STATS:Statistic):void {
			m = M;
			stats = STATS;
			return;
		}


		/*
			Obtains hero statistics
		*/
		public function getStats():Statistic
		{
			return stats;
		}

		public function bowVisualFromHero():void
		{
			this["I"]["bow_mc"].gotoAndStop(stats.getBowName());
		}
	}
	
}
