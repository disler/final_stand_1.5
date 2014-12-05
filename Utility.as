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

		/*
			Capitalizes first letter
		*/	
		public function upperCaseFirst(str:String):String 
		{
			var firstChar:String = str.substr(0, 1); 
			var restOfString:String = str.substr(1, str.length); 
			return firstChar.toUpperCase()+restOfString.toLowerCase(); 
		}

	}
	
}
