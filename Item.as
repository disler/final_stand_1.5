package {
	public class Item {
		public function Item() {}
		public static function getObj(_obj:String):Object {
			var o:Object = new Object();
			o.name = "None";
			o.type = "none";
			o.nam = _obj;
			o.description = "It's nothing.";
			o.cost = 10;
			switch(_obj) {
				case "glyph of haste":
					o.name = "Glyph of Haste";
					o.description = "Increases the speed at which arrows travel through the air.";
					o.cost = 100;
					o.type = "artifact";
				break;
				case "glyph of power":
					o.name  = "Glyph of Power";
					o.description = "Increases the damage dealt per arrow.";
					o.cost = 160;
					o.type = "artifact";
				break;
				case "glyph of health":
					o.name  = "Glyph of Health";
					o.description = "Increases the maximum health of your tower unit.";
					o.cost = 300;
					o.type = "artifact";
				break;
			}
			return o;
		}
	}
}
