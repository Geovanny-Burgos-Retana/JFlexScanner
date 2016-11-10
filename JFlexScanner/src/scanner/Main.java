/*
 * Main.java - Main del programa. Elegir si generar el Scanner o ejecutar un archivo
 */
package scanner;

import java.io.File;
import java.io.FileReader;
import java.io.BufferedReader;
import java.io.IOException;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;

public class Main {

    public static void main(String[] args) {
        int opcion = 0;
        boolean salir = false;
        java.util.Scanner entrada = new java.util.Scanner(System.in);
        while (!salir){
            System.out.println("\nMenú principal:");
            System.out.println("1. Generar Scanner");
            System.out.println("2. Generar Parser");
            System.out.println("3. Escanear archivo");
            System.out.println("4. Parsear archivo");
            System.out.println("5. Cerrar");
            System.out.print("Seleccione una opción: ");
            opcion = entrada.nextInt();
        	switch(opcion) {
        		case 1: { //Generar scanner
                    String archivoLex = "scanner.flex";
                    System.out.print("\nIndique el nombre del archivo: ");
                    //archivoLex = entrada.next();
                    String path = "C:/Users/Gaby/Desktop/JFlexScanner/JFlexScanner/src/scanner/";
                    File file = new File(path + archivoLex);
                    jflex.Main.generate(file); //Generar el archivo
                    break;
        		}
        		case 2: { //Generar parser
        		
        			break;
        		}
        		case 3: { //Escanear archivo
        			String archivo = "prueba.txt";
                    System.out.print("\nIndique el nombre del archivo de prueba: ");
                    archivo = entrada.next();
                    String path = "C:/Users/Gaby/Desktop/JFlexScanner/JFlexScanner/src/scanner/";
                    BufferedReader bufferedReader = null;
                    try {
                        bufferedReader = new BufferedReader(new FileReader(archivo));
                        Scanner scanner = new Scanner(bufferedReader);
                        Yytoken token = null;
                        //Imprimir token por token
                        token = scanner.nextToken();
                        while (token != null) {
                            //if ()
                            if (!token.getTipo().contains("ERROR")) {
                                System.out.println(token);
                            }
                            token = scanner.nextToken();
                        }
                        System.out.println("\nErrores\n");
                        //Imprimir el array de errores
                        scanner.imprimirErrores();
                    } catch (Exception ex) {
                        System.out.println("Error");
                        Logger.getLogger(Main.class.getName()).log(Level.SEVERE, null, ex);
                    } finally {
                        try {
                            bufferedReader.close();
                        } catch (IOException ex) {
                            Logger.getLogger(Main.class.getName()).log(Level.SEVERE, null, ex);
                        }
                    }
                    System.out.println("\nEjecución finalizada.\n");
        			break;
        		}
        		case 4: { //Parsear archivo
        			
        			break;
        		}
        		case 5: { //Salir
        			salir = true;
        			break;
        		}
        		default: {
        			System.out.println("Opción inválida.");
        			break;
        		}
        	}
        }
    }
    
}
