package  {
	
	/*
		Represents gold
	*/		
	public class Gold extends Loot {
		
		private var amount:Number = 0;

		public function Gold(amount:Number) {
			super("gold", Const.LOOT_GOLD);
			this.amount = amount;
		}

		/*
			Gets amount of gold
		*/
		public function getAmount():Number
		{
			return amount;
		}
	}
	
}
