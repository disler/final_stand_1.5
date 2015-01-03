package  {
	
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.utils.*;

	/*
		Represents area of effect 
	*/
	public class AOE extends MovieClip{

		var fireTimer:Number = 0, earthTimer:Number = 0;
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
				SoundHandler.playSound("thunderClap");
				break;
				case "ice arrow":
					//animation
					//addEventListener(Event.ENTER_FRAME, thunderFrames);

					//timeout
					killTime = setTimeout(function()
					{
						//removeEventListener(Event.ENTER_FRAME, thunderFrames);
						removeEventListener(Event.ENTER_FRAME, handleHitTest);
						main.arrows_mc.removeChild(main.arrows_mc.getChildByName(name));
					}, 1000);
				SoundHandler.playSound("ice" + (1 + Main.random(2)));
				break;
				case "fire arrow":
					//animation
					addEventListener(Event.ENTER_FRAME, fireFrames);

					//timeout
					killTime = setTimeout(function()
					{
						//removeEventListener(Event.ENTER_FRAME, thunderFrames);
						removeEventListener(Event.ENTER_FRAME, handleHitTest);
						main.arrows_mc.removeChild(main.arrows_mc.getChildByName(name));
					}, 5200);
				break;
				case "earth arrow":
					//animation
					addEventListener(Event.ENTER_FRAME, earthFrames);

					//timeout
					killTime = setTimeout(function()
					{
						//removeEventListener(Event.ENTER_FRAME, thunderFrames);
						removeEventListener(Event.ENTER_FRAME, handleHitTest);
						main.arrows_mc.removeChild(main.arrows_mc.getChildByName(name));
					}, 5200);
				SoundHandler.playSound("wallCrumble1");
				break;
				default:
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
		public function fireFrames(e:Event)
		{
			if(fireTimer-- < 0) {
				var enemies:Array = main.waveHandler.getEnemies();
			for(var i = 0; i < enemies.length; i++)
				{
					if(enemies[i] != null && this.hitTestObject(enemies[i]))
					{
						//enemies[i].addStatusEffect(Const.AOE_ICE, damage, enemies[i] == target ? true : false);
						enemies[i].recieveDamage(Math.ceil(damage * 0.5));
					}
				}
				fireTimer = 30;
			}
		}
		public function earthFrames(e:Event)
		{
			earthTimer++;
				var enemies:Array = main.waveHandler.getEnemies(); 
		for(var i = 0; i < enemies.length; i++)
			{
				if(enemies[i] != null && enemies[i].stats.health > 0 && enemies[i].hitTestObject(this))
				{
					var ee:MovieClip = enemies[i];
					if(ee.x > main.player.x) {
						ee.x += 170;
					} else if(ee.x < main.player.x) {
						ee.x -= 170;
					}if(ee.y > main.player.y) {
						ee.y += 170;
					} else if(ee.y < main.player.y) {
						ee.y -= 170;
					}
				}
			}
		}






		/*
			Handle hit test
		*/
		private function handleHitTest(e:Event)
		{
			if(this.type == "thunder arrow") {
				var enemies:Array = main.waveHandler.getEnemies();
				for(var i:Number = 0; i < enemies.length; i++)
				{
					if(enemies[i] != null && this.hitTestObject(enemies[i]))
					{
						enemies[i].addStatusEffect(Const.AOE_THUNDER, damage, enemies[i] == target ? true : false);
					}
				}
			} else if(this.type == "ice arrow") {
				enemies = main.waveHandler.getEnemies();
				for(i = 0; i < enemies.length; i++)
				{
					if(enemies[i] != null && this.hitTestObject(enemies[i]))
					{
						enemies[i].addStatusEffect(Const.AOE_ICE, damage, enemies[i] == target ? true : false);
					}
				}
			}
		}
	}
	
}
