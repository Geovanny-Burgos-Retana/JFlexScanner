/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package scanner;

import java.io.File;


/**
 *
 * @author Gaby
 */
public class Main {

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        String path = "C:/Users/Gaby/Desktop/JFlexScanner/JFlexScanner/src/scanner/Scanner.flex";
        File file = new File(path);
        jflex.Main.generate(file);
    }
    
}
