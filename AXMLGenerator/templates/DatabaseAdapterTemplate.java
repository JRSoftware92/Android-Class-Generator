

import java.util.HashMap;
import java.util.Stack;

import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.database.SQLException;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteQueryBuilder;

import com.dev.database.model.SuiteColumn;
import com.dev.database.model.SuiteTable;

/**
 * 
 * Generic database adapter class meant for implementation with the ISQLObject class.
 * @author John Riley
 * 
 */
public abstract class ~#~CLASS_NAME~#~ {
	
	protected SQLiteDatabase mDb;
	protected ~#~HELPER_CLASS_NAME~#~ mDbHelper;
	
	/**
	 * Context constructor.
	 * @param context - Context of the application.
	 */
	public DatabaseAdapter(Context context){}
	
	/**
	 * Opens the database adapter.
	 * @throws SQLException
	 */
	public void open() throws SQLException { mDb = mDbHelper.getWritableDatabase(); }
	  
	/**
	 * Closes the database adapter.
	 */
	public void close() { mDbHelper.close(); }

	~#~QUERY_METHODS~#~
}
