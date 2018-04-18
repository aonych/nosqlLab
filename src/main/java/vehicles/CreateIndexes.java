package vehicles;

import com.mongodb.MongoClient;
import com.mongodb.client.MongoDatabase;
import com.mongodb.client.MongoCollection;
import org.bson.Document;


import com.mongodb.client.model.Indexes;

public class CreateIndexes {
	
	public static void main(String[] args){
		MongoClient mongo = new MongoClient( "localhost" , 27017 );
		MongoDatabase db = mongo.getDatabase("test");
		MongoCollection<Document> collection = db.getCollection("vehicles");
		
		collection.createIndex(Indexes.text("License Number"));
		for (Document index : collection.listIndexes()) {
		    System.out.println(index.toJson());
		}
	}
}
