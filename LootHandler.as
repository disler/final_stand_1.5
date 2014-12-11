package  {
	
	/*
		Handles and manages loot
	*/
	public class LootHandler {

		private static var lootTier:Array = 	[
													["glyph of haste", "glyph of health", "glyph of bow speed",
													"steel_arrow", "wooden_arrow"],
													["glyph of power", "glyph of health regeneration", "glyph of accuracy"],
													[],
													[]
												];

		public function LootHandler() {}

		/*
			Returns random loot, given tier
		*/
		public static function getLoot(tier:Number):Loot
		{
			var lootName:String = lootTier[tier][Math.floor(Math.random() * lootTier[tier].length)];
			return new Loot(lootName);
		}

		/*
			Determines of a kill will grant loot
		*/
		public static function lootRoll(tier:Number):Object
		{
			var retObject:Object = {
				bool: false, 
				tier : 0
			}

			switch(tier)
			{
				case 0:
					retObject.bool = Math.floor(Math.random() * 100) <= Const.TIER_0_ROLL ? true : false;
					retObject.tier = 0;
				break;
				case 1:
					retObject.bool = Math.floor(Math.random() * 100) <= Const.TIER_1_ROLL ? true : false;
					retObject.tier = 1;
				break;
				case 2:
					retObject.bool = Math.floor(Math.random() * 100) <= Const.TIER_2_ROLL ? true : false;
					retObject.tier = 2;
				break;
				case 3:
					retObject.bool = Math.floor(Math.random() * 100) <= Const.TIER_3_ROLL ? true : false;
					retObject.tier = 3;
				break;
			}
			return retObject;
		}

		/*
			Returns gold given waveId
		*/
		public static function getGold(waveId:Number):Gold
		{
			return new Gold( Math.floor(Math.random() * (waveId * 25)) + 25);
		}

		/*
			Determines of a kill will grant gold
		*/
		public static function goldRoll():Boolean
		{
			var bool:Boolean = Math.floor(Math.random() * 100) <= Const.GOLD_ROLL ? true : false;
			return bool;
		}
	}
	
}
