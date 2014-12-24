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

		/*
			Uppercases first letter.
		*/
		public function upperCaseFirst(str:String):String 
		{
			var firstChar:String = str.substr(0, 1); 
			var restOfString:String = str.substr(1, str.length); 
			return firstChar.toUpperCase()+restOfString.toLowerCase(); 
		}

		/*
			Uppercases every first letter of every word.
		*/
		function upperCaseFirstWord(str:String):String
		{ 
		    var strCap:String = str.charAt(0).toUpperCase() + str.substr(1 , str.length);
		    for(var i:Number = 0; i < strCap.length; i++)
		    {
		        if(strCap.charAt(i) == " ") strCap.charAt(i+1).toUpperCase();
		    }
		    return strCap;
		}    
	}
}
