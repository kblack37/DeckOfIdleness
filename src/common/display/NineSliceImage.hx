package common.display;

import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.DisplayObject;
import openfl.display.Sprite;
import openfl.geom.Point;
import openfl.geom.Rectangle;

/**
 * ...
 * @author 
 */
class NineSliceImage extends Sprite {

	private var m_nineSliceRect : Rectangle;
	
	/**
	 * The dimensions of the original bitmap data are necessary for calculating the
	 * correct scale factor when the width or height is set
	 */
	private var m_originalWidth : Float;
	private var m_originalHeight : Float;
	
	private var m_height : Float;
	private var m_width : Float;
	
	private var m_center : Bitmap;
	
	private var m_left : Bitmap;
	private var m_right : Bitmap;
	
	private var m_top : Bitmap;
	private var m_bottom : Bitmap;
	
	private var m_topLeft : Bitmap;
	private var m_topRight : Bitmap;
	private var m_bottomLeft : Bitmap;
	private var m_bottomRight : Bitmap;
	
	/**
	 * If the rectangle passed in is meant to be a scale3, this is not null
	 * and is set to either "horizontal" or "vertical"
	 */
	private var m_threeSliceMode : String = null;
	
	public function new(bitmapData : BitmapData, nineSliceRect : Rectangle) {
		super();
		
		m_nineSliceRect = new Rectangle();
		m_nineSliceRect.copyFrom(nineSliceRect);
		
		m_width = m_originalWidth = bitmapData.width;
		m_height = m_originalHeight = bitmapData.height;
		
		// We're always copying pixels into the origin of the new bitmap data
		var origin = new Point(0, 0);
		
		var left = Std.int(nineSliceRect.left);
		var top = Std.int(nineSliceRect.top);
		var right = Std.int(nineSliceRect.right);
		var bottom = Std.int(nineSliceRect.bottom);
		
		// If the left or top property is 0, that singles that this is just a scale3Grid
		// and we can do some optimizing
		if (left == 0 || top == 0) {
			// If the y of the rectangle is 0, we have a horizontal scale3; horizontal otherwise
			m_threeSliceMode = top == 0 ? "horizontal" : "vertical";
		}
		
		var centerBitmapData = new BitmapData(right - left, bottom - top);
		centerBitmapData.copyPixels(bitmapData, nineSliceRect, origin);
		m_center = new Bitmap(centerBitmapData);
		addChild(m_center);
		
		// We only need the corners if this is a true scale9
		if (m_threeSliceMode == null) {
			var topLeftBitmapData = new BitmapData(left, top);
			topLeftBitmapData.copyPixels(bitmapData, new Rectangle(0, 0, left, top), origin);
			m_topLeft = new Bitmap(topLeftBitmapData);
			addChild(m_topLeft);
			
			var topRightBitmapData = new BitmapData(bitmapData.width - right, top);
			topRightBitmapData.copyPixels(bitmapData, new Rectangle(right, 0, bitmapData.width - right, top), origin); 
			m_topRight = new Bitmap(topRightBitmapData);
			addChild(m_topRight);
			
			var bottomLeftBitmapData = new BitmapData(left, bitmapData.height - bottom);
			bottomLeftBitmapData.copyPixels(bitmapData, new Rectangle(0, bottom, left, bitmapData.height - bottom), origin); 
			m_bottomLeft = new Bitmap(bottomLeftBitmapData);
			addChild(m_bottomLeft);
			
			var bottomRightBitmapData = new BitmapData(bitmapData.width - right, bitmapData.height - bottom);
			bottomRightBitmapData.copyPixels(bitmapData, new Rectangle(right, bottom, bitmapData.width - right, bitmapData.height - bottom), origin);
			m_bottomRight = new Bitmap(bottomRightBitmapData);
			addChild(m_bottomRight);
		}
		
		// We only need the left & right edges if this is a scale9 or a horizontal scale3
		if (m_threeSliceMode == null || m_threeSliceMode == "horizontal") {
			var leftBitmapData = new BitmapData(left, bottom - top);
			leftBitmapData.copyPixels(bitmapData, new Rectangle(0, top, left, bottom - top), origin); 
			m_left = new Bitmap(leftBitmapData);
			addChild(m_left);
			
			var rightBitmapData = new BitmapData(bitmapData.width - right, bottom - top);
			rightBitmapData.copyPixels(bitmapData, new Rectangle(right, top, bitmapData.width - right, bottom - top), origin);
			m_right = new Bitmap(rightBitmapData);
			addChild(m_right);
		}
		
		// We only need the top & bottom edges if this is a scale9 or a vertical scale3
		if (m_threeSliceMode == null || m_threeSliceMode == "vertical") {
			var topBitmapData = new BitmapData(right - left, top);
			topBitmapData.copyPixels(bitmapData, new Rectangle(left, 0, right - left, top), origin); 
			m_top = new Bitmap(topBitmapData);
			addChild(m_top);
			
			var bottomBitmapData = new BitmapData(right - left, bitmapData.height - bottom);
			bottomBitmapData.copyPixels(bitmapData, new Rectangle(left, bottom, right - left, bitmapData.height - bottom), origin);
			m_bottom = new Bitmap(bottomBitmapData);
			addChild(m_bottom);
		}
		
		applyNineSlice();
	}
	
	/**
	 * Adjusts both the size & position of the contained elements
	 */
	private function applyNineSlice() {
		var horizAddFactor = (m_originalWidth - m_nineSliceRect.width) * scaleX;
		var vertAddFactor = (m_originalHeight - m_nineSliceRect.height) * scaleY;
		
		m_center.x = m_nineSliceRect.left;
		m_center.y = m_nineSliceRect.top;
		m_center.width = m_width - horizAddFactor;
		m_center.height = m_height - vertAddFactor;
		
		if (m_threeSliceMode == null) {
			m_topRight.x = m_nineSliceRect.left + m_center.width;
			
			m_bottomLeft.y = m_nineSliceRect.top + m_center.height;
			
			m_bottomRight.x = m_topRight.x;
			m_bottomRight.y = m_bottomLeft.y;
		}
		
		if (m_threeSliceMode == null || m_threeSliceMode == "horizontal") {
			m_left.y = m_nineSliceRect.top;
			m_left.height = m_center.height;
			
			m_right.x = m_nineSliceRect.left + m_center.width;
			m_right.y = m_left.y;
			m_right.height = m_left.height;
		}
		
		if (m_threeSliceMode == null || m_threeSliceMode == "vertical") {
			m_top.x = m_nineSliceRect.left;
			m_top.width = m_center.width;
			
			m_bottom.x = m_top.x;
			m_bottom.y = m_nineSliceRect.top + m_center.height;
			m_bottom.width = m_top.width;
		}
	}
	
	public function dispose() {
		// Get rid of all the custom bitmap data we created
		m_center.bitmapData.dispose();
		
		if (m_threeSliceMode == null) {
			m_topLeft.bitmapData.dispose();
			m_topRight.bitmapData.dispose();
			m_bottomLeft.bitmapData.dispose();
			m_bottomRight.bitmapData.dispose();
		}
		
		if (m_threeSliceMode == null || m_threeSliceMode == "horizontal") {
			m_left.bitmapData.dispose();
			m_right.bitmapData.dispose();
		}
		
		if (m_threeSliceMode == null || m_threeSliceMode == "vertical") {
			m_top.bitmapData.dispose();
			m_bottom.bitmapData.dispose();
		}
	}
	
	public function getNineSliceRect() : Rectangle {
		var returnRect = new Rectangle();
		returnRect.copyFrom(m_nineSliceRect);
		return returnRect;
	}
	
	override function set_width(width : Float) : Float {
		if (m_width != width) {
			m_width = width;
			applyNineSlice();
		}
		return m_width;
	}
	
	override function get_width() : Float {
		return m_width;
	}
	
	override function set_height(height : Float) : Float {
		if (m_height != height) {
			m_height = height;
			applyNineSlice();
		}
		return m_height;
	}
	
	override function get_height() : Float {
		return m_height;
	}
}