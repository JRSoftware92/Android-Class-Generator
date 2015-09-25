~#~ HEADER ~#~

public class ~#~ CLASS_NAME ~#~ extends SupportActivity {

~#~ VARIABLES ~#~

	@Override
	public int getLayoutId(){
		return R.layout.~#~ LAYOUT_NAME ~#~;
	}

	@Override
	public int getMenuId(){
		return R.menu.menu_~#~ LAYOUT_NAME ~#~;
	}

	@Override
	public void initializeDefaultActivity(){
~#~ INITIALIZATION ~#~
	}

	@Override
	public void initializeActivity(Bundle args){
		/* TODO */
	}
	
~#~ EVENT_METHODS ~#~
}
