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
import java.util.logging.Level;
import java.util.logging.Logger;

public class Main {

    public static void main(String[] args) {
        int opcion = 0;
        boolean salir = false;
        java.util.Scanner entrada = new java.util.Scanner(System.in);
        while (!salir){
            System.out.println("Menú principal:");
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
                    archivoLex = entrada.next();
                    String path = "C:/Users/Gaby/Desktop/JFlexScanner/JFlexScanner/src/scanner/";
                    File file = new File(path + archivoLex);
                    jflex.Main.generate(file); //Generar el archivo
                    /*File arch = new File("Scanner.java");
                    if(arch.exists()){
                        System.out.println("" + arch);
                        Path currentRelativePath = Paths.get("");
                        String nuevoDir = currentRelativePath.toAbsolutePath().toString()
                                + File.separator + "src" + File.separator 
                                + "scanner" + File.separator + arch.getName();
                        File archViejo = new File(nuevoDir);
                        archViejo.delete();
                        if(arch.renameTo(new File(nuevoDir))){
                            System.out.println("\nGenerado.");
                            System.exit(0);
                        }else{
                            System.out.println("\nError generando.");
                        }
                    }else{
                        System.out.println("\nArchivo no existe.");
                    }*/
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
                        do {
                            token = scanner.nextToken();
                            System.out.println(token);
                        } while (token != null);
                    } catch (Exception ex) {
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
