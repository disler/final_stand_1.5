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


				/*__________________________GLYPH__________________________*/
				case "glyph of haste":
					o.name = "Glyph of Haste";
					o.description = Const.ITEM_DESCRIPTION[_obj];
					o.cost = 150;
					o.type = "artifact";
				break;
				case "glyph of power":
					o.name  = "Glyph of Power";
					o.description = Const.ITEM_DESCRIPTION[_obj];
					o.cost = 300;
					o.type = "artifact";
				break;
				case "glyph of health regeneration":
					o.name  = "Glyph of Health Regeneration";
					o.description = Const.ITEM_DESCRIPTION[_obj];
					o.cost = 300;
					o.type = "artifact";
				break;
				case "glyph of bow speed":
					o.name  = "Glyph of Bow Speed";
					o.description = Const.ITEM_DESCRIPTION[_obj];
					o.cost = 200;
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
				case "glyph of multishot":
					o.name  = "Glyph of Multishot";
					o.description = Const.ITEM_DESCRIPTION[_obj];
					o.cost = 500;
					o.type = "artifact";
				break;
				case "glyph of penetration":
					o.name  = "Glyph of Penetration";
					o.description = Const.ITEM_DESCRIPTION[_obj];
					o.cost = 750;
					o.type = "artifact";
				break;
				case "glyph of collision":
					o.name  = "Glyph of Collision";
					o.description = Const.ITEM_DESCRIPTION[_obj];
					o.cost = 750;
					o.type = "artifact";
				break;
				/*__________________________ARROWS__________________________*/


				case "wooden arrow":
					o.name  = "Wooden Arrow";
					o.description = Const.ITEM_DESCRIPTION[_obj];
					o.cost = 100;
					o.type = "arrow";
				break;
				case "steel arrow":
					o.name  = "Steel Arrow";
					o.description = Const.ITEM_DESCRIPTION[_obj];
					o.cost = 100;
					o.type = "arrow";
				break;
				case "mithril arrow":
					o.name  = "Mithril Arrow";
					o.description = Const.ITEM_DESCRIPTION[_obj];
					o.cost = 100;
					o.type = "arrow";
				break;
				case "ice arrow":
					o.name  = "Ice Arrow";
					o.description = Const.ITEM_DESCRIPTION[_obj];
					o.cost = 100;
					o.type = "arrow";
				break;
				case "fire arrow":
					o.name  = "Fire Arrow";
					o.description = Const.ITEM_DESCRIPTION[_obj];
					o.cost = 100;
					o.type = "arrow";
				break;
				case "earth arrow":
					o.name  = "Earth Arrow";
					o.description = Const.ITEM_DESCRIPTION[_obj];
					o.cost = 100;
					o.type = "arrow";
				break;
				case "thunder arrow":
					o.name  = "Thunder Arrow";
					o.description = Const.ITEM_DESCRIPTION[_obj];
					o.cost = 100;
					o.type = "arrow";
				break;



				/*__________________________BOWS__________________________*/
			
				case "guardian bow":
					o.name  = "Guardian bow";
					o.description = Const.ITEM_DESCRIPTION[_obj];
					o.cost = 100;
					o.type = "bow";
				break;
				case "vicious bow":
					o.name  = "Vicious bow";
					o.description = Const.ITEM_DESCRIPTION[_obj];
					o.cost = 100;
					o.type = "bow";
				break;
				case "agile bow":
					o.name  = "Agile bow";
					o.description = Const.ITEM_DESCRIPTION[_obj];
					o.cost = 100;
					o.type = "bow";
				break;
				case "absolute bow":
					o.name  = "Absolute bow";
					o.description = Const.ITEM_DESCRIPTION[_obj];
					o.cost = 100;
					o.type = "bow";
				break;
				case "sonic bow":
					o.name  = "Sonic bow";
					o.description = Const.ITEM_DESCRIPTION[_obj];
					o.cost = 100;
					o.type = "bow";
				break;
			}
			return o;
		}
	}
}
