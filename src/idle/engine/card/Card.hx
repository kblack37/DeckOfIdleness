package idle.engine.card;
import common.data.ISerializable;
import common.engine.IGameEngine;
import idle.engine.card.effects.CardEffect;
import idle.engine.card.effects.ResourceEffect;

/**
 * 
 * @author kristen autumn blackburn
 */
class Card implements ISerializable {
	
	public var uid(get, never) : String;
	public var name(get, never) : String;
	public var color(get, never) : String;
	public var imgFile(get, never) : String;
	
	private static var g_nextUid : Int = 0;
	
	private var m_uid : String;
	
	private var m_name : String;
	private var m_color : String;
	private var m_imgFile : String;
	private var m_effects : Array<CardEffect>;
	
	public function new() {
		m_uid = Std.string(g_nextUid++);
		
		m_effects = new Array<CardEffect>();
	}
	
	public function addCardEffect(effect : CardEffect) {
		m_effects.push(effect);
	}
	
	public function getCardEffects() : Array<CardEffect> {
		return m_effects.copy();
	}
	
	/** INTERFACE METHODS **/
	
	public function serialize() : Dynamic {
		return null;
	}
	
	public function deserialize(object : Dynamic) {
		m_name = object.name;
		m_color = object.color;
		m_imgFile = object.img;
	}
	
	function get_uid() : String {
		return m_uid;
	}
	
	function get_name() : String {
		return m_name;
	}
	
	function get_color() : String {
		return m_color;
	}
	
	function get_imgFile() : String {
		return m_imgFile;
	}
}