import android.view.TextView;
import android.view.ProgressBar;
import android.view.ToggleButton;
import android.view.Button;


public class Activity extends SupportActivity {

	TextView recordingTimeStamp = null;
	TextView transcriptTextView = null;
	TextView resultsTextView = null;
	ProgressBar loadingSpinner = null;
	ToggleButton recordButton = null;
	Button analyzeButton = null;


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
		recordingTimeStamp = (TextView) findViewById(R.id.recordingTimeStamp);
		transcriptTextView = (TextView) findViewById(R.id.transcriptTextView);
		resultsTextView = (TextView) findViewById(R.id.resultsTextView);
		loadingSpinner = (ProgressBar) findViewById(R.id.loadingSpinner);
		recordButton = (ToggleButton) findViewById(R.id.recordButton);
		analyzeButton = (Button) findViewById(R.id.analyzeButton);

	}

	@Override
	public void initializeActivity(Bundle args){
		/* TODO */
	}
	

}
