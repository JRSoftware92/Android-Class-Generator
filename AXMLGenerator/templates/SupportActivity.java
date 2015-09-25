package com.suitepitch.activity;

import android.annotation.SuppressLint;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentActivity;
import android.support.v4.app.FragmentTransaction;
import android.support.v7.app.AppCompatActivity;
import android.view.Menu;
import android.view.MenuItem;

/**
 * Abstract Support Fragment Activity for safely implementing a fragment activity.
 * @author John Riley
 *
 */
public abstract class SupportActivity extends AppCompatActivity {

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(getLayoutId());
		
		Bundle args = getIntent().getExtras();
		if(args == null){
			initializeDefaultActivity();
		}
		else{
			initializeActivity(args);
		}
	}

	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		if(getMenuId() > -1){
			getMenuInflater().inflate(getMenuId(), menu);
		}
		return true;
	}

	@Override
	public boolean onOptionsItemSelected(MenuItem item) {
		return super.onOptionsItemSelected(item);
	}
	
	/**
	 * MUST be ended with a call to commit().
	 * @return An opened transaction from the support fragment manager.
	 */
	@SuppressLint("CommitTransaction") 
	protected final FragmentTransaction beginTransaction(){
		return getSupportFragmentManager().beginTransaction();
	}
	
	/**
	 * Adds a fragment through the support fragment manager to a given container by its id.
	 * @param containerId
	 * @param frag
	 */
	protected void addFragment(int containerId, Fragment frag){
		beginTransaction().add(containerId, frag).commit();
	}
	
	/**
	 * Replaces the contents of a provided container (by its id) with a provided fragment
	 * using the support fragment manager.
	 * @param containerId
	 * @param frag
	 */
	protected void replaceFragment(int containerId, Fragment frag){
		beginTransaction().replace(containerId, frag).commit();
	}
	
	/**
	 * Accessor for the layout id of the activity.
	 * @return
	 */
	protected abstract int getLayoutId();
	
	/**
	 * Accessor for the menu id of the activity.
	 * @return
	 */
	protected abstract int getMenuId();
	
	/**
	 * Initializes the activity using default values.
	 */
	protected abstract void initializeDefaultActivity();
	
	/**
	 * Initializes the activity using provided arguments.
	 * @param args
	 */
	protected abstract void initializeActivity(Bundle args);
}
