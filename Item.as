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
					o.description = Const.ITEM_DESCRIPTION[_obj];
					o.cost = 100;
					o.type = "artifact";
				break;
				case "glyph of power":
					o.name  = "Glyph of Power";
					o.description = Const.ITEM_DESCRIPTION[_obj];
					o.cost = 100;
					o.type = "artifact";
				break;
				case "glyph of health regeneration":
					o.name  = "Glyph of Health Regeneration";
					o.description = Const.ITEM_DESCRIPTION[_obj];
					o.cost = 100;
					o.type = "artifact";
				break;
				case "glyph of bow speed":
					o.name  = "Glyph of Bow Speed";
					o.description = Const.ITEM_DESCRIPTION[_obj];
					o.cost = 100;
					o.type = "artifact";
				break;
				case "glyph of accuracy":
					o.name  = "Glyph of Accuracy";
					o.description = Const.ITEM_DESCRIPTION[_obj];
					o.cost = 100;
					o.type = "artifact";
				break;
				case "glyph of health":
					o.name  = "Glyph of Health";
					o.description = Const.ITEM_DESCRIPTION[_obj];
					o.cost = 100;
					o.type = "artifact";
				break;
			}
			return o;
		}
	}
}
