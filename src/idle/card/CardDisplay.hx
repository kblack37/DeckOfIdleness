package idle.card;

import idle.engine.card.Card;
import idle.engine.card.effects.CardEffect;
import idle.engine.card.effects.ResourceEffect;
import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Sprite;
import openfl.filters.DropShadowFilter;
import openfl.filters.GlowFilter;
import openfl.text.TextField;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;

/**
 * ...
 * @author kristen autumn blackburn
 */
class CardDisplay extends Sprite {
	
	public var cardData(get, never) : Card;

	private var m_cardData : Card;
	
	public function new(cardData : Card) {
		super();
		
		m_cardData = cardData;
		
		var cardContainer : Sprite = new Sprite();
		
		var cardBackground : Bitmap = new Bitmap(Assets.getBitmapData("assets/img/" + m_cardData.color + "_card.png"));
		cardContainer.addChild(cardBackground);
		
		var nameTextField : TextField = new TextField();
		nameTextField.selectable = false;
		nameTextField.setTextFormat(new TextFormat(null, 8, null, true, null, null, null, null, TextFormatAlign.LEFT));
		nameTextField.text = m_cardData.name;
		nameTextField.height = 12;
		nameTextField.width = 50;
		
		var nameTextBackground : CardTextBackground = new CardTextBackground(nameTextField.textWidth + 7, nameTextField.textHeight + 4);
		nameTextBackground.x = 4;
		nameTextBackground.y = 2;
		nameTextField.x = 2 + (nameTextBackground.width - nameTextField.textWidth) * 0.5;
		nameTextField.y = (nameTextBackground.height - nameTextField.textHeight) * 0.5;
		
		cardContainer.addChild(nameTextBackground);
		cardContainer.addChild(nameTextField);
		
		var cardArt : Bitmap = new Bitmap(Assets.getBitmapData(cardData.imgFile));
		cardArt.x = (cardBackground.width - cardArt.width) * 0.5;
		cardArt.y = 20;
		cardContainer.addChild(cardArt);
		
		var effectsBackground : CardTextBackground = new CardTextBackground(46, 30);
		effectsBackground.x = (cardBackground.width - effectsBackground.width) * 0.5;
		effectsBackground.y = 52;
		cardContainer.addChild(effectsBackground);
		
		Lambda.iter(cardData.getCardEffects(), function(cardEffect : CardEffect) {
			var castedEffect : ResourceEffect = try cast(cardEffect, ResourceEffect) catch (e : Dynamic) null;
			if (castedEffect != null && castedEffect.resource == "energy") {
				var resourceIcon : Bitmap = new Bitmap(Assets.getBitmapData("assets/img/" + castedEffect.resource + "_icon.png"));
				resourceIcon.x = effectsBackground.x + (effectsBackground.width - resourceIcon.width) * 0.5;
				resourceIcon.y = effectsBackground.y + (effectsBackground.height - resourceIcon.height) * 0.5;
				resourceIcon.alpha = 0.8;
				cardContainer.addChild(resourceIcon);
				
				var resourceTextField : TextField = new TextField();
				resourceTextField.selectable = false;
				resourceTextField.autoSize = TextFieldAutoSize.CENTER;
				resourceTextField.setTextFormat(new TextFormat(null, 16, null, true));
				resourceTextField.text = Std.string(castedEffect.amount);
				resourceTextField.filters = [new GlowFilter(0xFFFFFF, 0.8, 3, 3)];
				resourceTextField.x = (cardBackground.width - resourceTextField.textWidth) * 0.5;
				resourceTextField.y = resourceIcon.y + (resourceIcon.height - resourceTextField.textHeight) * 0.5;
				cardContainer.addChild(resourceTextField);
			}
		});
		
		cardContainer.scaleX = cardContainer.scaleY = 2.0;
		
		var cardBitmapData : BitmapData = new BitmapData(120, 180, true, 0x00FFFFFF);
		cardBitmapData.draw(cardContainer);
		addChild(new Bitmap(cardBitmapData));
	}
	
	function get_cardData() : Card {
		return m_cardData;
	}
}