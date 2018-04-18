package vehicles;

import java.awt.BorderLayout;
import java.awt.Component;
import java.awt.Graphics2D;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.util.Iterator;

import javax.imageio.ImageIO;
import javax.swing.JFrame;
import javax.swing.JScrollPane;
import javax.swing.JTable;

import org.bson.Document;
import org.json.JSONObject;

import com.mongodb.MongoClient;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;

public class CollectionInfoToFile {

	public static void main(String[] args){
		MongoClient mongo = new MongoClient( "localhost" , 27017 );
		MongoDatabase db = mongo.getDatabase("test");
		MongoCollection<Document> collection = db.getCollection("vehicles");
		
		String databaseName = collection.getNamespace().toString().split("\\.")[0];
		String collectionName = collection.getNamespace().toString().split("\\.")[1];
		
	    Document myDoc = collection.find().first();
	    JSONObject json_array = new JSONObject(myDoc.toJson());
		
		try {
			PrintWriter writer = new PrintWriter("collectionInfo.txt", "UTF-8");
			writer.println("Nazwa bazy danych: "+ databaseName);
			writer.println("Nazwa kolekcji: "+ collectionName);
			writer.println("Wielkosc kolekcji: "+ collection.count());
			writer.println("Nazwy kolumn: ");
			 Iterator<?> keys = json_array.keys();
			    while( keys.hasNext() ) {
			    	writer.println("		 "+ (String) keys.next());
			    }
			writer.close();
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		

	}
}
