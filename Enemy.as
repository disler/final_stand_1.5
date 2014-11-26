package  {
	import flash.display.MovieClip;
	
	/*
		Base class for all enemies
	*/
	public class Enemy extends MovieClip {
		
		public var id:Number;

		public function Enemy() {
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

	}
	
}
