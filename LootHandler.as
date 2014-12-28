package  {
	
	/*
		Handles and manages loot
	*/
	public class LootHandler {

		private static var lootTier:Array = 	[
													[
														new Loot("glyph of haste", Const.LOOT_ARTIFACT), new Loot("glyph of health", Const.LOOT_ARTIFACT), new Loot("glyph of bow speed", Const.LOOT_ARTIFACT),
														new Loot("steel arrow", Const.LOOT_ARROW), new Loot("wooden arrow", Const.LOOT_ARROW),
														new Loot("guardian bow", Const.LOOT_BOW), new Loot("absolute bow", Const.LOOT_BOW)
													], 
													[
														new Loot("glyph of power", Const.LOOT_ARTIFACT), new Loot("glyph of health regeneration", Const.LOOT_ARTIFACT), new Loot("glyph of accuracy", Const.LOOT_ARTIFACT),
														new Loot("mithril arrow", Const.LOOT_ARROW),
														new Loot("sonic bow", Const.LOOT_BOW)

													],
													[
														new Loot("glyph of multishot", Const.LOOT_ARTIFACT),
														new Loot("thunder arrow", Const.LOOT_ARROW),
														new Loot("agile bow", Const.LOOT_ARROW), 
													],
													[
														new Loot("glyph of penetration", Const.LOOT_ARTIFACT),
														new Loot("glyph of collision", Const.LOOT_ARTIFACT),
														new Loot("vicious bow", Const.LOOT_BOW)
													]
												];

		public function LootHandler() {}

		/*
			Returns random loot, given tier
		*/
		public static function getLoot(tier:Number, ownedLoot:Array):Loot
		{
			//removed currently owned bows an arrows
			var _reducedLootTier:Array = [[], [], [], []];
			for(var i:Number = 0; i < lootTier.length; i++)
			{
				for(var j:Number = 0; j < lootTier[i].length; j++)
				{
					//if we do not own this loot, add it to reduced loot tier
					if(ownedLoot.indexOf(lootTier[i][j].getTitle()) == -1)
					{
						_reducedLootTier[i].push(lootTier[i][j]);
					}
				}
			}

			var loot:Loot = _reducedLootTier[tier][Math.floor(Math.random() * _reducedLootTier[tier].length)];
			loot.setTier(tier);
			return loot;
		}

		//glyph - contains 'glyph'
		//

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
				case 0://tier 1 loot roll
					retObject.bool = Math.floor(Math.random() * 100) <= Const.TIER_0_ROLL ? true : false;
					retObject.tier = 0;
				break;
				case 1://tier 2 loot roll
					retObject.bool = Math.floor(Math.random() * 100) <= Const.TIER_1_ROLL ? true : false;
					retObject.tier = 1;
				break;
				case 2://tier 3 loot roll
					retObject.bool = Math.floor(Math.random() * 100) <= Const.TIER_2_ROLL ? true : false;
					retObject.tier = 2;
				break;
				case 3://tier 4 loot roll
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
			var gold:Gold = new Gold( Math.floor(Math.random() * (waveId * 25)) + 25); 
			gold.setTier(0);
			return gold;
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
