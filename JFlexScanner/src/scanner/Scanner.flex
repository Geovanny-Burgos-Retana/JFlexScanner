package scanner;

import java_cup.runtime.*;
import java.io.Reader;
import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;

class Yytoken {
    public int numToken;
    public String token;
    public String tipo;
    public int linea;
    public int columna;

    Yytoken (int numToken, String token, String tipo, int linea, int columna) {
        //Contador para el número de tokens reconocidos
        this.numToken = numToken;
        //String del token reconocido
        this.token = new String(token);
        //Tipo de componente léxico encontrado
        this.tipo = tipo;
        //Número de linea
        this.linea = linea;
        //Columna donde empieza el primer carácter del token
        this.columna = columna;
    }   
    //Metodo que devuelve los datos necesarios que escribiremos en un archive de salida
    public String toString() {
        return "#" + numToken + ": " + token + " \tTipo: " + tipo + " ["+linea
        + "," +columna + "]";
    }

    public String getTipo() {
        return this.tipo;
    }

    public String getToken() {
        return this.token;
    }
}
      
%%
%public
%class Scanner
%unicode //Soporte para Unicode
%caseless
%ignorecase
%cup //Compatibilidad con CUP
   
%{
    private int contador;
    private ArrayList<Yytoken> tokens;
    private int contadorErrores;
    private ArrayList<Yytoken> errores;

    private void writeOutputFile() throws IOException {
        String filename = "file.out";
        BufferedWriter out = new BufferedWriter(
            new FileWriter(filename));
        //System.out.println("\nTokens guardados en archivo\n");
        for(Yytoken t: this.tokens){
            //System.out.println(t);
            out.write(t + "\n");
        }
        out.close();
    }

        public ArrayList<Yytoken> getErrores(){
            return errores;
        }

        public ArrayList<Yytoken> getTokens(){
            return tokens;
        }

        public void imprimirErrores() {
            for (Yytoken error : errores) {
                System.out.println(error);
            }
        }

    /*  Generamos un java_cup.Symbol para guardar el tipo de token encontrado */
    private Symbol symbol(int type) {
        return new Symbol(type, yyline, yycolumn);
    }
    
    /* Generamos un Symbol para el tipo de token encontrado junto con su valor */
    private Symbol symbol(int type, Object value) {
        return new Symbol(type, yyline, yycolumn, value);
    }
%}
   

//Declaraciones-----------------------------------------------------

letra =         [A-Za-z]
digito =        [0-9]
alfanumerico =  {letra}|{digito}
other_id_char = [_]
identificador = ({letra}|{other_id_char})({alfanumerico}|{other_id_char})*
entero =        0 | [1-9][0-9]*
parteDecimal =  ({digito})+
enteroNegativo = \-{entero}
real =          {entero}\.{parteDecimal}
realNegativo =  \-{real}
salto =         \n|\r|\r\n
whitespace =    [ \n\t]
espacio=        {salto} | [ \t\f]

%% //fin de opciones


// Reglas léxicas---------------------------------------------------
   
/*
   Esta seccion contiene expresiones regulares y acciones. 
   Las acciones son código en Java que se ejecutara cuando se
   encuentre una entrada valida para la expresion regular correspondiente */
   
   /* YYINITIAL es el estado inicial del analizador lexico al escanear.
      Las expresiones regulares solo serán comparadas si se encuentra
      en ese estado inicial. Es decir, cada vez que se encuentra una 
      coincidencia el scanner vuelve al estado inicial. Por lo cual se ignoran
      estados intermedios.*/
   
<YYINITIAL> {
   
    ";" { 
            return symbol(sym.SEMI); 
        }
    "+" {
            System.out.print(" + ");
            return symbol(sym.OP_SUMA); 
        }
    "-" {
            System.out.print(" - ");
            return symbol(sym.OP_RESTA); 
        }
    "*" {  
            System.out.print(" * ");
            return symbol(sym.OP_MULT); 
        }
    "(" {
            System.out.print(" ( ");
            return symbol(sym.PARENIZQ); 
        }
    ")" { 
            System.out.print(" ) ");
            return symbol(sym.PARENDER); 
        }
    {entero} {
            System.out.print(yytext()); 
            return symbol(sym.ENTERO, new Integer(yytext())); 
        }
    {espacio} { 
        //Ignorar 
    } 
}


/* Si el token contenido en la entrada no coincide con ninguna regla
    entonces se marca un token ilegal */
    [^] { 
            throw new Error("Caracter ilegal <"+yytext()+">"); 
        }
