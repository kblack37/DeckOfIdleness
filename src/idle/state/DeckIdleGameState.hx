package idle.state;

import common.engine.IGameEngine;
import common.engine.scripting.selectors.AllSelector;
import common.engine.scripting.selectors.TimerSelector;
import common.engine.systems.FreeTransformSystem;
import common.engine.systems.HighlightSystem;
import common.state.BaseState;
import common.state.IState;
import haxe.Json;
import idle.deck.DeckWidget;
import idle.discard.DiscardWidget;
import idle.engine.GameEngine;
import idle.engine.card.Card;
import idle.engine.card.CardFactory;
import idle.engine.resource.ResourceParser;
import idle.hand.HandWidget;
import idle.resource.ResourceDisplayWidget;
import idle.systems.CardClickUpgradeSystem;
import idle.systems.CardDisplaySystem;
import idle.systems.CardDrawSystem;
import idle.systems.CardEffectSystem;
import idle.systems.CardUpgradeSystem;
import idle.systems.EmptyDeckDiscardPlaySystem;
import idle.systems.FullHandPlaySystem;
import idle.systems.ResourceChangeSystem;
import idle.systems.ShuffleDiscardToDeckSystem;
import openfl.Assets;
import openfl.events.MouseEvent;

/**
 * ...
 * @author kristen autumn blackburn
 */
class DeckIdleGameState extends BaseState {

	public function new(gameEngine : IGameEngine) {
		super(gameEngine);
		
	}
	
	override public function enter(from : IState, params : Dynamic) {
		// See if there is any saved data about resources; if not, load up the defaults
		var resourceObject : Dynamic = null;
		if (Reflect.hasField(params, "resources")) {
			resourceObject = params.resources;
		} else {
			resourceObject = Json.parse(Assets.getText("assets/resource/default_resources.json"));
		}
		var resourceParser : ResourceParser = new ResourceParser(m_gameEngine);
		resourceParser.parseFromJsonObject(resourceObject);
		
		var castedEngine : GameEngine = try cast(m_gameEngine, GameEngine) catch (e : Dynamic) null;
		
		// First off, add some default systems
		m_scriptRoot.addChild(new FreeTransformSystem(m_gameEngine));
		m_scriptRoot.addChild(new HighlightSystem(m_gameEngine));
		m_scriptRoot.addChild(new CardDisplaySystem(m_gameEngine, "cardDisplaySystem"));
		
		// some testing parameters
		var card_factory : CardFactory = new CardFactory(m_gameEngine);
		var test_deck : Array<Card> = new Array<Card>();
		for (i in 0...18) {
			test_deck.push(card_factory.createCard(i % 9));
		}
		
		// Initialize the deck widget
		var deckWidget : DeckWidget = new DeckWidget(m_gameEngine, test_deck);
		m_gameEngine.addWidget("deck", deckWidget);
		castedEngine.addCardLibrary("deck", deckWidget);
		deckWidget.shuffle();
		
		// Initialize the hand widget
		var handWidget : HandWidget = new HandWidget(m_gameEngine);
		handWidget.x = stage.stageWidth - handWidget.width;
		handWidget.y = stage.stageHeight - handWidget.height;
		addChild(handWidget);
		m_gameEngine.addWidget("hand", handWidget);
		castedEngine.addCardLibrary("hand", handWidget);
		
		// Initialize the discard widget
		var discardWidget : DiscardWidget = new DiscardWidget(m_gameEngine, []);
		m_gameEngine.addWidget("discard", discardWidget);
		castedEngine.addCardLibrary("discard", discardWidget);
		
		// Initialize the resource display
		var resourceDisplay : ResourceDisplayWidget = new ResourceDisplayWidget(m_gameEngine);
		addChild(resourceDisplay);
		m_gameEngine.addWidget("resourceDisplay", resourceDisplay);
		
		// Add the resource systems
		var resourceSystems : AllSelector = new AllSelector("resourceSystems");
		resourceSystems.addChild(new ResourceChangeSystem(m_gameEngine, "resourceChangeSystem"));
		m_scriptRoot.addChild(resourceSystems);
		
		// Add the upgrade systems
		var upgradeSystems : AllSelector = new AllSelector("upgradeSystems");
		upgradeSystems.addChild(new CardClickUpgradeSystem(m_gameEngine, "cardClickUpgradeSystem"));
		upgradeSystems.addChild(new CardUpgradeSystem(m_gameEngine, "cardUpgradeSystem"));
		m_scriptRoot.addChild(upgradeSystems);
		
		// Add the card drawing systems
		var cardDrawTimer : TimerSelector = new TimerSelector(m_gameEngine.getTime(), 1500, "cardDrawTimer");
		cardDrawTimer.addChild(new CardDrawSystem(m_gameEngine, "cardDrawSystem"));
		m_scriptRoot.addChild(cardDrawTimer);
		
		// Add the deck refill systems
		var deckRefillSystems : AllSelector = new AllSelector("deckRefillSystems");
		deckRefillSystems.addChild(new ShuffleDiscardToDeckSystem(m_gameEngine, "shuffleDiscardToDeckSystem"));
		m_scriptRoot.addChild(deckRefillSystems);
		
		// Add the card playing systems
		var cardPlaySystems : AllSelector = new AllSelector("cardPlaySystems");
		cardPlaySystems.addChild(new FullHandPlaySystem(m_gameEngine, "fullHandPlaySystem"));
		cardPlaySystems.addChild(new EmptyDeckDiscardPlaySystem(m_gameEngine, "emptyDeckDiscardPlaySystem"));
		cardPlaySystems.addChild(new CardEffectSystem(m_gameEngine, "cardEffectSystem"));
		m_scriptRoot.addChild(cardPlaySystems);
	}
}