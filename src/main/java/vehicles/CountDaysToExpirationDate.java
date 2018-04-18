package vehicles;

import com.mongodb.MongoClient;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoCursor;
import com.mongodb.client.MongoDatabase;
import com.mongodb.client.model.Projections;
import org.bson.Document;

import javax.swing.*;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;

import static javax.swing.JOptionPane.INFORMATION_MESSAGE;
import static javax.swing.JOptionPane.showMessageDialog;

public class CountDaysToExpirationDate {

    public static int countDaysToExpiration(Date d1, Date d2){
        int days =  (int)( (d2.getTime() - d1.getTime()) / (1000 * 60 * 60 * 24));
        return days+1;
    }

    public static void main(String[] args) {
        MongoClient mongo = new MongoClient("localhost", 27017);
        MongoDatabase db = mongo.getDatabase("test");
        MongoCollection<Document> collection = db.getCollection("vehicles");

        String licenseNumber = "1H45";

        if (args.length > 0){
            licenseNumber = args[0];
        }

        Document query = new Document("License Number",licenseNumber);

        if (collection.count(query) == 0){
            System.out.println("Niepoprawny numer licencji!");
            showMessageDialog(null, "Podano nieprawidłowy numer licencji!", "Niepoprawny numer licencji", JOptionPane.ERROR_MESSAGE);
        }else{
            MongoCursor<Document> dbItem = collection.find(query).projection(Projections.include("Expiration Date")).iterator();

            if (dbItem.hasNext()){
                DateFormat dateFormat = new SimpleDateFormat("MM/dd/yyyy");
                Date currentDate = new Date();
                String date = (String) dbItem.next().get("Expiration Date");
                try {
                    Date dateDb = dateFormat.parse(date);

                    Calendar cal1 = new GregorianCalendar();
                    Calendar cal2 = new GregorianCalendar();
                    cal1.setTime(currentDate);
                    cal2.setTime(dateDb);

                    System.out.println("Data wygasniecia licencji '"+licenseNumber+"': "+ dateFormat.format(dateDb));

                    if(dateDb.before(currentDate)){
                        System.out.println("Licencja o numerze '"+licenseNumber+"' wygasla!");
                        showMessageDialog(null, "Licencja o numerze '"+licenseNumber+"' wygasla!", "Uwaga", JOptionPane.WARNING_MESSAGE);
                    }else{
                        int days = countDaysToExpiration(currentDate, dateDb);
                        System.out.println("Ilosc dni do wygasniecia licencji '"+licenseNumber+"': "+days);
                        showMessageDialog(null, "Wygaśnięcie licencji '"+licenseNumber+"' nastąpi za "+days+" dni", "Ilość dni do wygaśnięcia", INFORMATION_MESSAGE);
                    }

                } catch (ParseException e) {
                    e.printStackTrace();
                }

            }
        }
    }
}
