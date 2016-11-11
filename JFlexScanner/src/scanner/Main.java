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
import java.util.Scanner;

public class Main {

    public static void main(String[] args) {
        int opcion = 0;
        boolean salir = false;
        java.util.Scanner entrada = new java.util.Scanner(System.in);
        while (!salir){
            System.out.println("\nMenú principal:");
            System.out.println("1. Generar Scanner y Parser");
            System.out.println("2. Escanear y parsear archivo");
            System.out.println("3. Cerrar");
            System.out.print("Seleccione una opción: ");
            opcion = entrada.nextInt();
        	switch(opcion) {
        		case 1: { //Generar scanner y parser
                    String archivoLexico = "Scanner.flex";
                    String archivoSintactico = "Parser.cup";
                    String path = "C:/Users/Gaby/Desktop/JFlexScanner/JFlexScanner/src/scanner/";
                    String[] alexico = {path + archivoLexico};
                    String[] asintactico = {"-parser", "Parser", path + archivoSintactico};
                    //jflex.Main.generate(new File(path + archivoLexico)); //Generar el archivo
                    jflex.Main.main(alexico);
                    try {
                        java_cup.Main.main(asintactico);
                    } catch (Exception ex) {
                        Logger.getLogger(Main.class.getName()).log(Level.SEVERE, null, ex);
                    }
                    //Mover archivos generados al paquete
                    boolean mvAS = moverArch("Parser.java");
                    boolean mvSym= moverArch("sym.java");
                    if(mvAS && mvSym){
                        System.out.println("Generado!");
                        System.exit(0);
                    }
                    break;
                }
                case 2: { //Ejecutar
                    String[] archivoPrueba = {"test.txt"};
                    //Parser.main(archivoPrueba);
                    System.out.println("Ejecutado!");
                    break;
                }
                case 3: { //Salir
                    salir = true;
                    System.out.println("Gurbai!");
                    break;
                }
                default: {
                    System.out.println("Opción inválida.");
                    break;
                }
            }
        }
    }

    public static boolean moverArch(String archNombre) {
        boolean efectuado = false;
        File arch = new File(archNombre);
        if (arch.exists()) {
            System.out.println("Moviendo " + arch);
            Path currentRelativePath = Paths.get("");
            String nuevoDir = currentRelativePath.toAbsolutePath().toString()
                    + File.separator + "src" + File.separator
                    + "scanner" + File.separator + arch.getName();
            File archViejo = new File(nuevoDir);
            archViejo.delete();
            if (arch.renameTo(new File(nuevoDir))) {
                System.out.println("Generado " + archNombre);
                efectuado = true;
            } else {
                System.out.println("No movido " + archNombre);
            }

        } else {
            System.out.println(archNombre + " no existente");
        }
        return efectuado;
    }
    
    /*case 2: { //Ejecutar
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
}*/
    
}
