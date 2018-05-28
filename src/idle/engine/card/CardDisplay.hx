package idle.engine.card;

import idle.engine.card.effects.CardEffect;
import idle.engine.card.effects.ResourceEffect;
import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.BlendMode;
import openfl.display.Sprite;
import openfl.text.TextField;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFormat;

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
		nameTextField.setTextFormat(new TextFormat(null, 8));
		nameTextField.text = m_cardData.name;
		nameTextField.height = 12;
		nameTextField.width = 50;
		nameTextField.x = 5;
		nameTextField.y = 3;
		cardContainer.addChild(nameTextField);
		
		var cardArt : Bitmap = new Bitmap(Assets.getBitmapData(cardData.imgFile));
		cardArt.x = (cardBackground.width - cardArt.width) * 0.5;
		cardArt.y = 20;
		cardContainer.addChild(cardArt);
		
		var effectsBackground : Bitmap = new Bitmap(Assets.getBitmapData("assets/img/effects_background.png"));
		effectsBackground.x = (cardBackground.width - effectsBackground.width) * 0.5;
		effectsBackground.y = 52;
		cardContainer.addChild(effectsBackground);
		
		Lambda.iter(cardData.getCardEffects(), function(cardEffect : CardEffect) {
			var castedEffect : ResourceEffect = try cast(cardEffect, ResourceEffect) catch (e : Dynamic) null;
			if (castedEffect != null && castedEffect.resource == "energy") {
				var resourceIcon : Bitmap = new Bitmap(Assets.getBitmapData("assets/img/" + castedEffect.resource + "_icon.png"));
				resourceIcon.x = effectsBackground.x + (effectsBackground.width - resourceIcon.width) * 0.5;
				resourceIcon.y = effectsBackground.y + (effectsBackground.height - resourceIcon.height) * 0.5;
				cardContainer.addChild(resourceIcon);
				
				var resourceTextField : TextField = new TextField();
				resourceTextField.selectable = false;
				resourceTextField.autoSize = TextFieldAutoSize.CENTER;
				resourceTextField.setTextFormat(new TextFormat(null, 16, null, true));
				resourceTextField.text = Std.string(castedEffect.amount);
				resourceTextField.x = (cardBackground.width - resourceTextField.textWidth) * 0.5;
				resourceTextField.y = resourceIcon.y + (resourceIcon.height - resourceTextField.textHeight) * 0.5;
				cardContainer.addChild(resourceTextField);
			}
		});
		
		cardContainer.scaleX = cardContainer.scaleY = 2.0;
		
		var cardBitmapData : BitmapData = new BitmapData(Std.int(cardContainer.width), Std.int(cardContainer.height), true, 0x00FFFFFF);
		cardBitmapData.draw(cardContainer);
		addChild(new Bitmap(cardBitmapData));
	}
	
	function get_cardData() : Card {
		return m_cardData;
	}
}