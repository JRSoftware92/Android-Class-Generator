import android.view.LinearLayout;
import android.view.TextView;
import android.view.Button;


public class Activity extends SupportActivity {

	LinearLayout layoutId = null;
	TextView dateText = null;
	Button button = null;


	@Override
	public int getLayoutId(){
		return R.layout.test2;
	}

	@Override
	public int getMenuId(){
		return R.menu.menu_test2;
	}

	@Override
	public void initializeDefaultActivity(){
		layoutId = (LinearLayout) findViewById(R.id.layoutId);
		dateText = (TextView) findViewById(R.id.dateText);
		button = (Button) findViewById(R.id.button);

	}

	@Override
	public void initializeActivity(Bundle args){
		/* TODO */
	}
	
	public void showNewDate(View v){
		/* TODO */
	}

}
