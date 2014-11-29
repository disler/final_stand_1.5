package  {
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	public class Utility {
	
		private var main:MovieClip;
		public function Utility(mc:MovieClip) { main = mc; }
		
		
		/*	
			displays number of children on a given movieclip
		*/
		public function countChildren(mc:MovieClip):Number
		{
			var count:Number = 0;
			
			for(var i:Number = 0; i < mc.numChildren; i++)
			{
				var child:DisplayObject = mc.getChildAt(i);
				if(child is DisplayObject)
				{
					count += 1;
				}
			}
			return count;
		}

	}
	
}
