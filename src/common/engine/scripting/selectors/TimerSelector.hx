package common.engine.scripting.selectors;

import common.engine.Time;
import common.engine.scripting.ScriptNode;
import common.engine.scripting.ScriptStatus;

/**
 * ...
 * @author kristen autumn blackburn
 */
class TimerSelector extends ScriptNode {

	public var timerMs(get, set) : Int;
	
	private var m_time : Time;
	private var m_timerMs : Int;
	private var m_elapsedMs : Int;
	
	public function new(time : Time, timerMs : Int, id : String = null, isActive : Bool = true) {
		super(id, isActive);
		
		m_time = time;
		m_timerMs = timerMs;
	}
	
	override public function visit() : ScriptStatus {
		m_elapsedMs += m_time.deltaMs;
		if (m_elapsedMs >= m_timerMs) {
			m_elapsedMs -= m_timerMs;
			
			for (child in m_children) {
				child.visit();
			}
		}
		return ScriptStatus.RUNNING;
	}
	
	function get_timerMs() : Int {
		return m_timerMs;
	}
	
	function set_timerMs(value : Int) : Int {
		// Maintain the current proportion of time left
		var proportion : Float = cast(m_elapsedMs, Float) / cast(m_timerMs, Float);
		if (proportion > 1.0) proportion = 1.0;
		m_elapsedMs = Std.int(proportion * value);
		
		return m_timerMs = value;
	}
}