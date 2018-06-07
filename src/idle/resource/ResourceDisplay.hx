package idle.resource;

import common.engine.IGameEngine;
import common.engine.type.EntityId;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Sprite;
import openfl.filters.BlurFilter;
import openfl.filters.DropShadowFilter;
import openfl.text.TextField;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFormat;

/**
 * ...
 * @author kristen autumn blackburn
 */
class ResourceDisplay extends Sprite {
	
	public var amount (never, set) : Float;
	
	private var m_amountText : TextField;

	public function new(gameEngine : IGameEngine, resourceId : EntityId) {
		super();
		
		var padding : Float = 5;
		
		var resourceName : String = cast(resourceId, String);
		var resourceIcon : Bitmap = new Bitmap(new BitmapData(38, 22, true, 0xFF000000));
		resourceIcon.scaleX = resourceIcon.scaleY = 1.50;
		
		var resourceText : TextField = new TextField();
		resourceText.selectable = false;
		resourceText.autoSize = TextFieldAutoSize.LEFT;
		resourceText.setTextFormat(new TextFormat(null, 18, 0xFFFFFF, true));
		resourceText.filters = [new DropShadowFilter(4, 30, 0, 0.9, 3, 3)];
		resourceText.text = resourceName.substr(0, 1).toUpperCase() + resourceName.substr(1) + ":";
		resourceText.x = resourceIcon.width + padding;
		resourceText.y = (resourceIcon.height - resourceText.height) * 0.5;
		
		m_amountText = new TextField();
		m_amountText.selectable = false;
		m_amountText.autoSize = TextFieldAutoSize.LEFT;
		m_amountText.setTextFormat(new TextFormat(null, 18, 0xFFFFFF, true));
		m_amountText.x = resourceText.x + resourceText.width + padding;
		m_amountText.y = resourceText.y + (resourceText.height - m_amountText.height) * 0.5;
		
		amount = 0;
		
		addChild(resourceIcon);
		addChild(resourceText);
		addChild(m_amountText);
	}
	
	function set_amount(value : Float) : Float {
		m_amountText.text = Std.string(value);
		m_amountText.filters = [new DropShadowFilter(4, 30, 0, 0.9, 3, 3)];
		return value;
	}
}