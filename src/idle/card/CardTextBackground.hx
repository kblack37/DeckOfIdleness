package idle.card;

import common.display.NineSliceImage;
import openfl.Assets;
import openfl.display.Sprite;
import openfl.geom.Rectangle;

/**
 * ...
 * @author kristen autumn blackburn
 */
class CardTextBackground extends Sprite {

	public function new(width : Float, height : Float) {
		super();
		
		var nineSliceRect : Rectangle = new Rectangle(3, 3, 40, 24);
		var nineSliceImage : NineSliceImage = new NineSliceImage(Assets.getBitmapData("assets/img/effects_background.png"), nineSliceRect);
		nineSliceImage.width = width;
		nineSliceImage.height = height;
		addChild(nineSliceImage);
	}
	
}