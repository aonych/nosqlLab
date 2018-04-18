package vehicles;

import org.jfree.chart.ChartUtilities;

import java.io.File;
import java.util.ArrayList;
import java.util.List;

import org.bson.Document;
import org.jfree.chart.ChartFactory;
import org.jfree.chart.JFreeChart;
import org.jfree.data.general.DefaultPieDataset;

import com.mongodb.MongoClient;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoCursor;
import com.mongodb.client.MongoDatabase;

public class VehicleTypesPieChartImage {
	 public static void main( String[ ] args ) throws Exception {
	      DefaultPieDataset dataset = new DefaultPieDataset( );
	      MongoClient mongo = new MongoClient( "localhost" , 27017 );
			MongoDatabase db = mongo.getDatabase("test");
			MongoCollection<Document> collection = db.getCollection("vehicles");
			
			List<String> vehicleTypes = new ArrayList<String>();		
			MongoCursor<String> licenseNumbers = collection.distinct("Vehicle Type", String.class).iterator();
			
			while(licenseNumbers.hasNext()){
				vehicleTypes.add(licenseNumbers.next());
			}
			
			for(String type : vehicleTypes){
				Document query = new Document("Vehicle Type",type);
				long count = collection.count(query);
				System.out.println(type+" "+count);
				if(type.isEmpty()){
					dataset.setValue( "OTHERS ("+count+")" , count ); 
				}else{
					dataset.setValue( type+" ("+count+")" , count ); 
				}
			}

	      JFreeChart chart = ChartFactory.createPieChart(
	         "Vehicle Types",   // chart title
	         dataset,          // data
	         true,             // include legend
	         true,
	         false);
	         
	      int width = 640;   /* Width of the image */
	      int height = 480;  /* Height of the image */ 
	      File pieChart = new File( "PieChart.jpeg" ); 
	      ChartUtilities.saveChartAsJPEG( pieChart , chart , width , height );
	   }
}
