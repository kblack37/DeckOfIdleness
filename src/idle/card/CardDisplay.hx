package idle.card;

import common.engine.IGameEngine;
import common.engine.component.IComponentManager;
import idle.engine.card.Card;
import idle.engine.card.CardColor;
import idle.engine.card.effects.CardEffect;
import idle.engine.card.effects.ResourceEffect;
import idle.engine.component.ColorComponent;
import idle.engine.component.EffectsComponent;
import idle.engine.component.NameComponent;
import idle.engine.component.UpgradeComponent;
import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.DisplayObject;
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
	
	public var cardId(get, never) : Card;

	private var m_componentManager : IComponentManager;
	
	private var m_cardId : Card;
	private var m_flattenedBitmap : Bitmap;
	
	public function new(gameEngine : IGameEngine, cardId : Card) {
		super();
		
		m_componentManager = gameEngine.getComponentManager();
		
		m_cardId = cardId;
	}
	
	public function refreshFromData() {
		if (m_flattenedBitmap != null) {
			removeChild(m_flattenedBitmap);
			m_flattenedBitmap.bitmapData.dispose();
			m_flattenedBitmap = null;
		}
		
		var cardContainer : Sprite = new Sprite();
		
		var cardBackground : DisplayObject = createBackground();
		cardContainer.addChild(cardBackground);
		
		var nameTextField : TextField = createNameTextField();
		var nameTextBackground : CardTextBackground = new CardTextBackground(nameTextField.textWidth + 7, nameTextField.textHeight + 4);
		nameTextBackground.x = 4;
		nameTextBackground.y = 2;
		nameTextField.x = 2 + (nameTextBackground.width - nameTextField.textWidth) * 0.5;
		nameTextField.y = (nameTextBackground.height - nameTextField.textHeight) * 0.5;
		
		cardContainer.addChild(nameTextBackground);
		cardContainer.addChild(nameTextField);
		
		var cardArt : DisplayObject = createCardArt();
		cardArt.x = (cardBackground.width - cardArt.width) * 0.5;
		cardArt.y = 20;
		cardContainer.addChild(cardArt);
		
		var effectsBox : DisplayObject = createEffectsBox();
		effectsBox.x = (cardBackground.width - effectsBox.width) * 0.5;
		effectsBox.y = 52;
		
		cardContainer.addChild(effectsBox);
		
		cardContainer.scaleX = cardContainer.scaleY = 2.0;
		
		var cardBitmapData : BitmapData = new BitmapData(120, 180, true, 0x00FFFFFF);
		cardBitmapData.draw(cardContainer);
		m_flattenedBitmap = new Bitmap(cardBitmapData);
		addChild(m_flattenedBitmap);
	}
	
	private function createBackground() : DisplayObject {
		var colorComponent : ColorComponent = try cast(m_componentManager.getComponentByIdAndType(m_cardId, ColorComponent.TYPE_ID), ColorComponent) catch (e : Dynamic) null;
		var cardColor : String = switch(colorComponent.cardColor) {
			case CardColor.GREY: "grey";
			case CardColor.RED: "red";
			case CardColor.YELLOW: "yellow";
			case CardColor.BLUE: "blue";
			case CardColor.GREEN: "green";
			case _: "grey";
		}
		var cardBackground : Bitmap = new Bitmap(Assets.getBitmapData("assets/img/" + cardColor + "_card.png"));
		return cardBackground;
	}
	
	private function createNameTextField() : TextField {
		var nameComponent : NameComponent = try cast(m_componentManager.getComponentByIdAndType(m_cardId, NameComponent.TYPE_ID), NameComponent) catch (e : Dynamic) null;
		var nameText : String = nameComponent.cardName;
		if (m_componentManager.entityHasComponent(m_cardId, UpgradeComponent.TYPE_ID)) {
			var upgradeComponent : UpgradeComponent = try cast(m_componentManager.getComponentByIdAndType(m_cardId, UpgradeComponent.TYPE_ID), UpgradeComponent) catch (e : Dynamic) null;
			if (upgradeComponent.level > 0) nameText += " +" + Std.string(upgradeComponent.level);
		}
		
		var nameTextField : TextField = new TextField();
		nameTextField.selectable = false;
		nameTextField.setTextFormat(new TextFormat(null, 8, null, true, null, null, null, null, TextFormatAlign.LEFT));
		nameTextField.text = nameText;
		nameTextField.height = 12;
		nameTextField.width = 50;
		return nameTextField;
	}
	
	private function createCardArt() : DisplayObject {
		return new Bitmap(Assets.getBitmapData("assets/img/ph.png"));
	}
	
	private function createEffectsBox() : DisplayObject {
		var effectsBox : Sprite = new Sprite();
		var effectsBackground : CardTextBackground = new CardTextBackground(46, 30);
		effectsBox.addChild(effectsBackground);
		
		var effectsComponent : EffectsComponent = try cast(m_componentManager.getComponentByIdAndType(m_cardId, EffectsComponent.TYPE_ID), EffectsComponent) catch (e : Dynamic) null;
		if (effectsComponent.effects.length == 1 && Reflect.field(effectsComponent.effects[0], "type") == "resource") {
			var resourceName : String = Reflect.field(effectsComponent.effects[0], "r");
			var resourceIcon : Bitmap = new Bitmap(Assets.getBitmapData("assets/img/" + resourceName + "_icon.png"));
			resourceIcon.x = effectsBackground.x + (effectsBackground.width - resourceIcon.width) * 0.5;
			resourceIcon.y = effectsBackground.y + (effectsBackground.height - resourceIcon.height) * 0.5;
			resourceIcon.alpha = 0.6;
			effectsBox.addChild(resourceIcon);
			
			var resourceTextField : TextField = new TextField();
			resourceTextField.selectable = false;
			resourceTextField.autoSize = TextFieldAutoSize.CENTER;
			resourceTextField.setTextFormat(new TextFormat(null, 16, null, true));
			resourceTextField.text = Std.string(Reflect.field(effectsComponent.effects[0], "a"));
			resourceTextField.filters = [new GlowFilter(0xFFFFFF, 0.8, 3, 3)];
			resourceTextField.x = resourceIcon.x + (resourceIcon.width - resourceTextField.textWidth) * 0.5;
			resourceTextField.y = resourceIcon.y + (resourceIcon.height - resourceTextField.textHeight) * 0.5;
			effectsBox.addChild(resourceTextField);
		}
		
		return effectsBox;
	}
	
	/** GETTERS / SETTERS **/
	
	function get_cardId() : Card {
		return m_cardId;
	}
}