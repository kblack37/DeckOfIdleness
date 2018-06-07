package common.util;
import openfl.display.BitmapData;
import openfl.geom.Rectangle;

/**
 * ...
 * @author kristen autumn blackburn
 */
class ColorUtil {
	
	public static function extractBlue(color : Int) : Int {
		return color & 0xFF;
	}
	
	public static function extractGreen(color : Int) : Int {
		return color >> 8 & 0xFF;
	}
	
	public static function extractRed(color : Int) : Int {
		return color >> 16 & 0xFF;
	}
	
	public static function interpolateColors(startColor : Int, endColor : Int, proportion : Float) : Int {
		var color : Int = 0;
		if (proportion < 0.0) {
			color = startColor;
		} else if (proportion > 1.0) {
			color = endColor;
		} else {
			var blue : Int = Math.round(extractBlue(startColor) + (extractBlue(endColor) - extractBlue(startColor)) * proportion);
			var green : Int = Math.round(extractGreen(startColor) + (extractGreen(endColor) - extractGreen(startColor)) * proportion) << 8;
			var red : Int = Math.round(extractRed(startColor) + (extractRed(endColor) - extractRed(startColor)) * proportion) << 16;
			color = blue + green + red;
		}
		return color;
	}
	
	public static function createGradientLR(bitmapData : BitmapData, rect : Rectangle, startColor : Int, endColor : Int) {
		var fillRect : Rectangle = new Rectangle(rect.left, rect.y, 1, rect.height);
		while (fillRect.x < rect.right) {
			var proportion : Float = 1 - ((rect.right - fillRect.x) / rect.width);
			bitmapData.fillRect(fillRect, interpolateColors(startColor, endColor, proportion));
			fillRect.x = fillRect.x + 1.0;
		}
	}
	
	public static function createGradientTB(bitmapData : BitmapData, rect : Rectangle, startColor : Int, endColor : Int) {
		
	}
}