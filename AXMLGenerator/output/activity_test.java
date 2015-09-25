import android.view.TextView;
import android.view.ProgressBar;
import android.view.ToggleButton;
import android.view.Button;


public class Activity extends SupportActivity {

	TextView textViewA = null;
	TextView textViewB = null;
	TextView textViewC = null;
	ProgressBar spinnerA = null;
	ToggleButton toggleButtonA = null;
	Button buttonA = null;


	@Override
	public int getLayoutId(){
		return R.layout.test;
	}

	@Override
	public int getMenuId(){
		return R.menu.menu_test;
	}

	@Override
	public void initializeDefaultActivity(){
		textViewA = (TextView) findViewById(R.id.textViewA);
		textViewB = (TextView) findViewById(R.id.textViewB);
		textViewC = (TextView) findViewById(R.id.textViewC);
		spinnerA = (ProgressBar) findViewById(R.id.spinnerA);
		toggleButtonA = (ToggleButton) findViewById(R.id.toggleButtonA);
		buttonA = (Button) findViewById(R.id.buttonA);

	}

	@Override
	public void initializeActivity(Bundle args){
		/* TODO */
	}
	
	public void testClickMethod(View v){
		/* TODO */
	}

}
