package idle.systems;

import common.engine.BaseEvent;
import common.engine.IGameEngine;
import common.engine.component.BaseComponent;
import common.engine.component.HighlightComponent;
import common.engine.component.IComponentManager;
import common.engine.scripting.ScriptStatus;
import common.engine.systems.BaseSystem;
import common.engine.type.EntityId;
import common.engine.type.Number;
import idle.engine.card.CardRarity;
import idle.engine.component.AmountComponent;
import idle.engine.component.EffectsComponent;
import idle.engine.component.RarityComponent;
import idle.engine.component.UpgradeComponent;
import idle.engine.events.CardEvent;
import idle.engine.events.ResourceEvent;
import idle.engine.events.UpgradeEvent;

/**
 * ...
 * @author kristen autumn blackburn
 */
class CardUpgradeSystem extends BaseSystem {
	
	private static var RARITY_TO_COST_MULTIPLIER : Map<CardRarity, Float> = [CardRarity.COMMON => 1.15, CardRarity.UNCOMMON => 1.2, CardRarity.RARE => 1.25];

	public function new(gameEngine : IGameEngine, id : String = null, isActive : Bool = true) {
		super(gameEngine, id, isActive);
		
		m_gameEngine.addEventListener(ResourceEvent.RESOURCE_CHANGED, onResourceChanged);
		m_gameEngine.addEventListener(UpgradeEvent.UPGRADE_REQUESTED, onUpgradeRequested);
	}
	
	private function onResourceChanged(e : Dynamic) {
		var componentManager : IComponentManager = m_gameEngine.getComponentManager();
		var baseComponents : Array<BaseComponent> = componentManager.getComponentsOfType(UpgradeComponent.TYPE_ID);
		for (baseComponent in baseComponents) {
			var entityId : EntityId = baseComponent.id;
			var totalCostMult : Float = getCostMultiplier(entityId);
			
			var upgradeComponent : UpgradeComponent = try cast(baseComponent, UpgradeComponent) catch (e : Dynamic) null;
			var highlight : HighlightComponent = try cast(componentManager.getComponentByIdAndType(entityId, HighlightComponent.TYPE_ID), HighlightComponent) catch (e : Dynamic) null;
			highlight.active = canPurchase(upgradeComponent.cost, totalCostMult);
		}
	}
	
	private function onUpgradeRequested(e : BaseEvent) {
		var entityId : EntityId = e.data;
		var componentManager : IComponentManager = m_gameEngine.getComponentManager();
		var highlight : HighlightComponent = try cast(componentManager.getComponentByIdAndType(entityId, HighlightComponent.TYPE_ID), HighlightComponent) catch (e : Dynamic) null;
		
		if (highlight.active) {
			var upgradeComponent : UpgradeComponent = try cast(componentManager.getComponentByIdAndType(entityId, UpgradeComponent.TYPE_ID), UpgradeComponent) catch (e : Dynamic) null;
			var totalCostMult : Float = getCostMultiplier(entityId);
			subtractResources(upgradeComponent.cost, totalCostMult);
			upgradeComponent.level = upgradeComponent.level + 1;
			for (upgradeEffect in upgradeComponent.effects) {
				var type : String = Reflect.field(upgradeEffect, "type");
				if (type == "resource") {
					var effectsComponent : EffectsComponent = try cast(componentManager.getComponentByIdAndType(entityId, EffectsComponent.TYPE_ID), EffectsComponent) catch (e : Dynamic) null;
					var resourceEffect : Dynamic = Lambda.find(effectsComponent.effects, function(effectData : Dynamic) : Bool {
						return effectData.type == type && effectData.r == upgradeEffect.r;
					});
					Reflect.setField(resourceEffect, "a", Reflect.field(resourceEffect, "a") + upgradeEffect.a);
				}
			}
			m_gameEngine.dispatchEvent(new CardEvent(CardEvent.CARD_UPGRADED, entityId));
		}
	}
	
	private function getCostMultiplier(entityId : EntityId) : Float {
		var componentManager : IComponentManager = m_gameEngine.getComponentManager();
		var upgradeComponent : UpgradeComponent = try cast(componentManager.getComponentByIdAndType(entityId, UpgradeComponent.TYPE_ID), UpgradeComponent) catch (e : Dynamic) null;
		var rarityComponent : RarityComponent = try cast(componentManager.getComponentByIdAndType(entityId, RarityComponent.TYPE_ID), RarityComponent) catch (e : Dynamic) null;
		return Math.pow(RARITY_TO_COST_MULTIPLIER[rarityComponent.rarity], upgradeComponent.level - 1);
	}
	
	private function canPurchase(cost : Map<EntityId, Number>, totalCostMult : Float) : Bool {
		for (resourceName in cost.keys()) {
			var amountComponent : AmountComponent =
				try cast(m_gameEngine.getComponentManager().getComponentByIdAndType(resourceName, AmountComponent.TYPE_ID), AmountComponent) catch (e : Dynamic) null;
			var resourceCost : Number = Math.fceil(cost.get(resourceName) * totalCostMult);
			if (resourceCost > amountComponent.amount) {
				return false;
			}
		}
		return true;
	}
	
	private function subtractResources(cost : Map<EntityId, Number>, totalCostMult : Float) {
		for (resourceName in cost.keys()) {
			m_gameEngine.dispatchEvent(new ResourceEvent(ResourceEvent.RESOURCE_LOST, {resource: resourceName, amount: Math.fceil(cost[resourceName] * totalCostMult)}));
		}
	}
}