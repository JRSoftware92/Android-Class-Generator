/////begin: HEADER<ELEMENTS>
import android.view.~!~ELEMENT_TYPE~!~;
/////end: HEADER<ELEMENTS>

/////begin: CLASS_HEADER<LAYOUT_DATA>
public class ~#~ CLASS_NAME ~#~ extends SupportActivity {
/////end: CLASS_HEADER<LAYOUT_DATA>

/////begin: VARIABLES<ELEMENTS>
~!~ELEMENT_TYPE~!~ ~!~ELEMENT_NAME~!~ = null;
/////end: VARIABLES<ELEMENTS>

/////begin: LAYOUT_METHODS<LAYOUT_DATA>
	@Override
	public int getLayoutId(){
		return R.layout.~#~ LAYOUT_NAME ~#~;
	}

	@Override
	public int getMenuId(){
		return R.menu.menu_~#~ LAYOUT_NAME ~#~;
	}
/////end: LAYOUT_METHODS<LAYOUT_DATA>

	@Override
	public void initializeDefaultActivity(){
		/////begin: INITIALIZATION<ELEMENTS>
		~!~ELEMENT_NAME~!~ = (~!~ELEMENT_TYPE~!~) findViewById(R.isd.~!~ELEMENT_ID~!~);
		/////end: INITIALIZATION<ELEMENTS>
	}

	@Override
	public void initializeActivity(Bundle args){
		/* TODO */
	}
	
	/////begin: EVENT_METHODS<ELEMENTS>
	public void ~!~EVENT_NAME~!~(View v){
		/* TODO */
	}
	/////end: EVENT_METHODS<ELEMENTS>
}
