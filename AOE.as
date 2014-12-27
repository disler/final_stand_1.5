package  {
	
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.utils.*;

	/*
		Represents area of effect 
	*/
	public class AOE extends MovieClip{

		var killTime:uint;
		var main:MovieClip;
		var type:String;
		var damage:Number;
		var target:MovieClip;

		public function AOE(main:MovieClip, type:String, damage:Number, target:MovieClip) {

			this.target = target;
			this.main = main;
			this.type = type;
			this.damage = damage;

			this.gotoAndStop(type);

			//hit test, and visual effect
			addEventListener(Event.ENTER_FRAME, handleHitTest);

			//determine kill time
			switch(type)
			{
				case "thunder arrow":
					//animation
					addEventListener(Event.ENTER_FRAME, thunderFrames);

					//timeout
					killTime = setTimeout(function()
					{
						removeEventListener(Event.ENTER_FRAME, thunderFrames);
						removeEventListener(Event.ENTER_FRAME, handleHitTest);
						main.arrows_mc.removeChild(main.arrows_mc.getChildByName(name));
					}, 1000);
				break;
			}


		}




		/*EVENTS*/


		/*
			Handles thunder animation
		*/
		private function thunderFrames(e:Event)
		{
			this.rotation += 30;
		}






		/*
			Handle hit test
		*/
		private function handleHitTest(e:Event)
		{
			var enemies:Array = main.waveHandler.getEnemies();
			for(var i:Number = 0; i < enemies.length; i++)
			{
				if(enemies[i] != null && this.hitTestObject(enemies[i]))
				{
					enemies[i].addStatusEffect(Const.AOE_THUNDER, damage, enemies[i] == target ? true : false);
				}
			}
		}
	}
	
}
