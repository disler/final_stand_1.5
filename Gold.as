package  {
	
	/*
		Represents gold
	*/		
	public class Gold extends Loot {
		
		private var amount:Number = 0;

		public function Gold(amount:Number) {
			super("gold");
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
