package idle.resource;

import common.engine.IGameEngine;
import common.engine.type.EntityId;
import common.engine.widget.BaseWidget;
import common.util.ColorUtil;
import haxe.CallStack;
import idle.engine.component.AmountComponent;
import idle.engine.events.ResourceEvent;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.DisplayObject;
import openfl.events.Event;
import openfl.geom.Rectangle;

/**
 * ...
 * @author ...
 */
class ResourceDisplayWidget extends BaseWidget {
	private var m_background : DisplayObject;
	private var m_resourceNameToDisplay : Map<EntityId, ResourceDisplay>;
	
	public function new(gameEngine : IGameEngine) {
		super(gameEngine);
		
		m_resourceNameToDisplay = new Map<EntityId, ResourceDisplay>();
		
		addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
	}
	
	override public function dispose() {
		m_gameEngine.removeEventListener(ResourceEvent.RESOURCE_CHANGED, onResourceChanged);
	}
	
	private function onAddedToStage(e : Dynamic) {
		removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		
		var backgroundWidth : Int = Std.int(stage.stageWidth - m_gameEngine.getWidget("hand").width);
		var backgroundHeight : Int = Std.int(stage.stageHeight - m_gameEngine.getWidget("hand").height);
		var backgroundBitmapData : BitmapData = new BitmapData(backgroundWidth, backgroundHeight, false);
		ColorUtil.createGradientLR(backgroundBitmapData, new Rectangle(0, 0, backgroundWidth * 0.5, backgroundHeight), 0x222222, 0x666666);
		ColorUtil.createGradientLR(backgroundBitmapData, new Rectangle(backgroundWidth * 0.5, 0, backgroundWidth * 0.5, backgroundHeight), 0x666666, 0x222222);
		m_background = new Bitmap(backgroundBitmapData);
		addChild(m_background);
		
		var resourceNames : Array<EntityId> = m_gameEngine.getEntitiesWithTag("resource");
		var padding : Float = 15;
		var yOffset : Float = 25;
		for (resourceName in resourceNames) {
			var resourceDisplay : ResourceDisplay = new ResourceDisplay(m_gameEngine, resourceName);
			resourceDisplay.x = padding;
			resourceDisplay.y = yOffset;
			yOffset += resourceDisplay.height + padding;
			
			addChild(resourceDisplay);
			m_resourceNameToDisplay.set(resourceName, resourceDisplay);
		}
		
		m_gameEngine.addEventListener(ResourceEvent.RESOURCE_CHANGED, onResourceChanged);
	}
	
	private function onResourceChanged(e : ResourceEvent) {
		var resourceId : EntityId = e.data;
		
		var amountComponent : AmountComponent = 
			try cast(m_gameEngine.getComponentManager().getComponentByIdAndType(resourceId, AmountComponent.TYPE_ID), AmountComponent) catch (e : Dynamic) null;
		m_resourceNameToDisplay[resourceId].amount = amountComponent.amount;
	}
}