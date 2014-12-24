package {
	public class Const {
		public const FPS:Number = 30.00;
		public const CENTER_X:Number = 320;
		public const CENTER_Y:Number = 430;
		
		public static const CASTLE_WIDTH_BORDER:Number = 100;
		public static const CASTLE_HEIGHT_BORDER:Number = 100;

		public static const MAGE_WIDTH_BORDER:Number = 225;
		public static const MAGE_HEIGHT_BORDER:Number = 225;
		
		public static const MAGE_HEIGHT_OFFSET:Number = 50;
		public static const MAGE_WIDTH_OFFSET:Number = 50;
		
		public static const STAGE_WIDTH:Number = 860;
		public static const STAGE_HEIGHT:Number = 640;
		public static const OFF_SCREEN_OFF_SET:Number = 25;
		
		public static const FPS:Number = 30.00;

		public static const BANDIT:Number = 1;
		public static const GUARD:Number = 2;
		public static const MAGE:Number = 3;
		public static const HYPER_GUARD:Number = 4;
		
		public static const ACTION_MOVEMENT:Number = 0;
		public static const ACTION_ATTACk:Number = 1;

		public static const BANDIT_ATTACK_TIME_DELAY:Number = 650;
		public static const MAGE_ATTACK_TIME_DELAY:Number = 200;

		public static const GUARD_BLOCK_TIME:Number = 1000;
		public static const GUARD_BLOCK_CHANCE:Number = 35;


		public static const HYPER_GUARD_BLOCK_TIME:Number = 1000;
		public static const HYPER_GUARD_BLOCK_CHANCE:Number = 40;

		//enemy projectiles
		public static const MAGE_PROJECTILE:String = "mage bomb";

		public static const WARNING_MESSAGE_SPAM_TIMER:Number = 5000;


		public static const MAX_LEVEL:Number = 30;

		public static const TIER_0_ROLL:Number = 10;
		public static const TIER_1_ROLL:Number = 8;
		public static const TIER_2_ROLL:Number = 7;
		public static const TIER_3_ROLL:Number = 5;

		public static const LOOT_ARTIFACT:Number = 0;
		public static const LOOT_BOW:Number = 1;
		public static const LOOT_ARROW:Number = 2;
		public static const LOOT_GOLD:Number = 3;


		public static const LOOT_MESSAGE_DEFAULT:Number = 0;
		public static const LOOT_MESSAGE_ARROW:Number = 1;
		public static const LOOT_MESSAGE_BOW:Number = 2;
		public static const LOOT_MESSAGE_ARTIFACT:Number = 3;

		public static const HEALTH_REGENERATION_INTERVAL:Number = 5000;

		public static const ARROW_SPEED_REDUCER:Number = .1;

		public static const GOLD_ROLL:Number = 15;

		public static const ARTIFACT_SLOT_LEVELS:Array = [	2, 	4, 	6, 	8,
															10, 12, 14, 15,
															17, 18, 20, 22,
															24, 26, 28, 30];

		public static const ARROW_TICK_INTERVAL:Number = 100;

		public static const ITEM_DESCRIPTION:Object = {
			//glyph
			"glyph of haste" : "Descrease time it takes to fire arrows",
			"glyph of power" : "Increase damage done to enemies",
			"glyph of health" : "Increase maximum castle health",
			"glyph of health regeneration" : "Increase health returned every five seconds",
			"glyph of bow speed" : "Increase speed of arrows",
			"glyph of accuracy" : "Increase accuracy of arrows",


			//bow
			"oak bow" : "Study bow made from oak, offers increased accuracy",
			"guardian bow" : "Bow forged from the essence of protectors, greatly increase maximum castle heatlh and castle regeneration"
		};
		
		public function Const() {}
	}
}
