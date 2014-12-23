package  {
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	


	public class Utility {
	
		public function Utility() {}
		
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
		// DO IT HERE DUDE CHRIS
		public function upperCaseFirst(str:String):String 
		{
			var firstChar:String = str.substr(0, 1); 
			var restOfString:String = str.substr(1, str.length); 
			return firstChar.toUpperCase()+restOfString.toLowerCase(); 
		}


		/*
			COmment
		*/
		public function upperCaseFirstWord():String
		{
			return null;
		}
	}
}
