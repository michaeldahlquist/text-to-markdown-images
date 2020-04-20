/************************************************************************************************
 * Names: Michael Dahlquist & Kristen Qako
 * Class: csci324 - spring2020
 * File:  unsplash.java
 * Date:  April 21st, 2020
 * 
 * Purpose:
 *      This function takes in a one or two String argument(s).
 *      If one argument is given:
 *          - It must contain either one word, or multiple words separated by comma(s)
 *          - The image will be saved as args[0].jpg
 *      If two arguments are given:
 *          - The first arg must contain either one word, or multiple words separated by comma(s)
 *          - The second arg must contain the saved file name (.jpg will be added by the program)
 * 
 * This code was inspired by:
 * https://stackoverflow.com/questions/10292792/getting-image-from-url-java
 ***********************************************************************************************/
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.URL;

public class unsplash {
    public static void main(String[] args) throws Exception {
        String imageUrl = "https://source.unsplash.com/400x300/?";  
        String destinationFile = "";
        if (args.length == 1) {
            imageUrl += args[0];
            destinationFile += "unsplash_"+args[0]+".jpg";
        } else if (args.length == 2) {
            imageUrl += args[0];
            destinationFile += args[1];
        } else {
            System.out.println("This program requires one or two args. See file description.");
            System.exit(0);
        }
        saveImage(imageUrl, destinationFile);
    }

    public static void saveImage(String imageUrl, String destinationFile) throws IOException {
        URL url = new URL(imageUrl);
        InputStream is = url.openStream();
        OutputStream os = new FileOutputStream(destinationFile);
        byte[] b = new byte[2048];
        int length;
        while ((length = is.read(b)) != -1) os.write(b, 0, length);
        is.close();
        os.close();
    }

}