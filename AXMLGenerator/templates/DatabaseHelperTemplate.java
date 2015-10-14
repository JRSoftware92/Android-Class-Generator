

import android.content.Context;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;
import android.util.Log;

/**
 * 
 * Generic abstract Database Helper class designed for use with DatabaseAdapter.
 * 
 */
public abstract class ~#~CLASS_NAME~#~ extends SQLiteOpenHelper {

	private static final String DB_NAME = "~#~DATABASE_NAME~#~";
	private static final int DB_VERSION = ~#~DATABASE_VERSION~#~;
	
	private Context context = null;
	
	/**
	 * Initializes the Database Helper class.
	 * @param context - Context of the application.
	 * @param dbName - Name of the database.
	 * @param dbVersion - Current version of the database.
	 */
	public DatabaseHelper(Context context) {
		super(context, DB_NAME, null, DB_VERSION);
		this.context = context;
		Log.d("~#~CLASS_NAME~#~", "Db name: " + DB_NAME + " and version " + DB_VERSION);
	}
	
	@Override
    public void onCreate(SQLiteDatabase db) {
        if(context != null){
			String[] create_statements = context.getStringArray(R.id.array_queries_table_create);
			for(String table : create_statements){
				db.execSQL(table);
			}
		}
    }

	@Override
	public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {
		Log.w("~#~CLASS_NAME~#~", "Upgrading database from version " + oldVersion + " to "
						+ newVersion + ", which will destroy all old data");
    
		onCreate(db);
	}
}
