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
        System.out.println("\nErrores léxicos: ");
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

//Contador para los tokens
%init{
    contador = 0;
    tokens = new ArrayList<Yytoken>();
    contadorErrores = 0;
    errores = new ArrayList<Yytoken>();
%init}

//Cuando se alcanza el fin del archivo de entrada
%eof{
    try{
        this.writeOutputFile();
        //this.imprimirErrores();
        //System.exit(0);
    }catch(IOException ioe){
        ioe.printStackTrace();
    }
%eof}

%line //Activar el contador de lineas, variable yyline
%column //Activar el contador de columna, variable yycolumn
//Fin de opciones
   

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
espacio =        {salto} | [ \t\f]

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
    // Números----------------------------------------------
    {entero} {
            //System.out.print(yytext()); 
            return symbol(sym.ENTERO, new Integer(yytext())); 
    }
    {real} {
            //imprimir
            return symbol(sym.REAL, new Double(yytext()));
    }
    // String---------------------------------------------
    "\"".*"\"" {
            return symbol(sym.STRING, new String(yytext()));
    }
    // Whitespace-------------------------------------------
    {espacio} { 
        //Ignorar 
    } 
    // Comentarios--------------------------------------------
    "//".*  {
        //Ignorar
    }
    [(][*][^*]*[*]+([^*/][^*]*[*]+)*[)] {
        //Ignorar
    }
    [(][*].* {
        contadorErrores++;
        Yytoken t = new Yytoken(contadorErrores, yytext(), 
            "ERROR - Comentario multilínea (* no terminado", yyline, yycolumn);
        errores.add(t);
        //return t;
    }
    "{".*"}" {
        //Ignorar
    }
    "{".* {
        contadorErrores++;
        Yytoken t = new Yytoken(contadorErrores, yytext(), 
            "ERROR - Comentario multilínea { no terminado", yyline, yycolumn);
        errores.add(t);
        //throw new Error("Caracter ilegal <"+yytext()+">");  return t;
    }

    // Tipos------------------------------------
    "ARRAY" {
            return symbol(sym.TIPO_ARRAY, yytext());
    }
    "BOOLEAN" {
            return symbol(sym.TIPO_BOOLEAN, yytext());
    }
    "BYTE" {
            return symbol(sym.TIPO_BYTE, yytext());
    }
    "CHAR" {
            return symbol(sym.TIPO_CHAR, yytext());
    }
    "CONST" {
            return symbol(sym.TIPO_CONST, yytext());
    }
    "INT" {
            return symbol(sym.TIPO_INT, yytext());
    }
    "LONGINT" {
            return symbol(sym.TIPO_LONGINT, yytext());
    }
    "NIL" {
            return symbol(sym.TIPO_NIL, yytext());
    }
    "REAL" {
            return symbol(sym.TIPO_REAL, yytext());
    }
    "SHORTINT" {
            return symbol(sym.TIPO_SHORTINT, yytext());
    }
    "STRING" {
            return symbol(sym.TIPO_STRING, yytext());
    }

    // Palabras reservadas-------------------------
    "BEGIN" {
            return symbol(sym.PR_BEGIN, yytext());
    }
    "CASE" {
            return symbol(sym.PR_CASE, yytext());
    }
    "DO" {
            return symbol(sym.PR_DO, yytext());
    }
    "DOWNTO" {
            return symbol(sym.PR_DOWNTO, yytext());
    }
    "ELSE" {
            return symbol(sym.PR_ELSE, yytext());
    }
    "END" {
            return symbol(sym.PR_END, yytext());
    }
    "FALSE" {
            return symbol(sym.PR_FALSE, yytext());
    }
    "FILE" {
            return symbol(sym.PR_FILE, yytext());
    }
    "FOR" {
            return symbol(sym.PR_FOR, yytext());
    }
    "FORWARD" {
            return symbol(sym.PR_FORWARD, yytext());
    }
    "FUNCTION" {
            return symbol(sym.PR_FUNCTION, yytext());
    }
    "GOTO" {
            return symbol(sym.PR_GOTO, yytext());
    }
    "IF" {
            return symbol(sym.PR_IF, yytext());
    }
    "IN" {
            return symbol(sym.PR_IN, yytext());
    }
    "INLINE" {
            return symbol(sym.PR_INLINE, yytext());
    }
    "LABEL" {
            return symbol(sym.PR_LABEL, yytext());
    }
    "OF" {
            return symbol(sym.PR_OF, yytext());
    }
    "PACKED" {
            return symbol(sym.PR_PACKED, yytext());
    }
    "PROCEDURE" {
            return symbol(sym.PR_PROCEDURE, yytext());
    }
    "THEN" {
            return symbol(sym.PR_THEN, yytext());
    }
    "PROGRAM" {
            return symbol(sym.PR_PROGRAM, yytext());
    }
    "READ" {
            return symbol(sym.PR_READ, yytext());
    }
    "RECORD" {
            return symbol(sym.PR_RECORD, yytext());
    }
    "REPEAT" {
            return symbol(sym.PR_REPEAT, yytext());
    }
    "SET" {
            return symbol(sym.PR_SET, yytext());
    }
    "TO" {
            return symbol(sym.PR_TO, yytext());
    }
    "TRUE" {
            return symbol(sym.PR_TRUE, yytext());
    }
    "TYPE" {
            return symbol(sym.PR_TYPE, yytext());
    }
    "UNTIL" {
            return symbol(sym.PR_UNTIL, yytext());
    }
    "VAR" {
            return symbol(sym.PR_VAR, yytext());
    }
    "WHILE" {
            return symbol(sym.PR_WHILE, yytext());
    }
    "WITH" {
            return symbol(sym.PR_WITH, yytext());
    }
    "WRITE" {
            return symbol(sym.PR_WRITE, yytext());
    }

    // Operadores-----------------------------------
    "AND" {
            return symbol(sym.OP_AND, yytext());
    }
    "DIV" {
            return symbol(sym.OP_DIV, yytext());
    }
    "NOT" {
            return symbol(sym.OP_NOT, yytext());
    }
    "MOD" {
            return symbol(sym.OP_MOD, yytext());
    }
    "OR" {
            return symbol(sym.OP_OR, yytext());
    }
    "XOR" {
            return symbol(sym.OP_XOR, yytext());
    }
    // Identificador -----------------------------------
    {identificador} {
        if (yylength() <= 127) {
            //Fijarse si ya está en la tabla de símbolos
            //Agregarlo sino
            /*if ( !tokens.contains(yytext().toLowerCase()) ) {
                contador++;
                Yytoken t = new Yytoken(contador,yytext().toLowerCase(),"Identificador",yyline,yycolumn);
                tokens.add(t);
                return t;
            }*/
            return symbol(sym.IDENTIFICADOR, yytext());    
        }
        else { //Si es mayor de 127 caracteres
            contadorErrores++;
            Yytoken t = new Yytoken(contadorErrores, yytext(), "ERROR - Nombre de variable muy grande", yyline, yycolumn);
            errores.add(t);
            //return symbol(sym.E)
            //return t;
        }
    }

    // Operadores (continuacion)------------------------
    "," {
            return symbol(sym.OP_COMA);
    }
    ";" { 
            return symbol(sym.SEMI); 
    }
    "++" {
            return symbol(sym.OP_SUMASUMA);
    }
    "--" {
            return symbol(sym.OP_MENOSMENOS);
    }
    ">=" {
            return symbol(sym.OP_MAYORIGUAL);
    }
    ">" {
            return symbol(sym.OP_MAYOR);
    }
    "<=" {
            return symbol(sym.OP_MENORIGUAL);
    }
    "<" {
            return symbol(sym.OP_MENOR);
    }
    "<>" {
            return symbol(sym.OP_MENORMAYOR);
    }
    "=" {
            return symbol(sym.OP_IGUAL);
    }
    "+" {
            return symbol(sym.OP_SUMA); 
    }
    "-" {
            return symbol(sym.OP_RESTA); 
    }
    "*" {  
            return symbol(sym.OP_MULT); 
    }
    "/" {
            return symbol(sym.OP_DIVISION);
    }
    "(" {
            return symbol(sym.PARENTIZQ); 
    }
    ")" { 
            return symbol(sym.PARENTDER); 
    }
    "[" {
            return symbol(sym.OP_BRACKETIZQ);
    }
    "]" {
            return symbol(sym.OP_BRACKETDER);
    }
    ":=" {
            return symbol(sym.OP_DOSPUNTOSIGUAL);
    }
    "." {
            return symbol(sym.OP_PUNTO);
    }
    ":" {
            return symbol(sym.OP_DOSPUNTOS);
    }
    "+=" {
            return symbol(sym.OP_MASIGUAL);
    }
    "-=" {
            return symbol(sym.OP_MENOSIGUAL);
    }
    "*=" {
            return symbol(sym.OP_MULTIGUAL);
    }
    "/=" {
            return symbol(sym.OP_DIVIGUAL);
    }
    ">>" {
            return symbol(sym.OP_MAYORMAYOR);
    }
    "<<" {
            return symbol(sym.OP_MENORMENOR);
    }
    "<<=" {
            return symbol(sym.OP_MENORMENORIGUAL);
    }
    ">>=" {
            return symbol(sym.OP_MAYORMAYORIGUAL);
    }
}

. {
    contadorErrores++;
    Yytoken t = new Yytoken(contadorErrores, yytext(), "ERROR - Caracter inválido", yyline, yycolumn);
    errores.add(t);
    //throw new Error("Caracter ilegal <"+yytext()+">"); 
    //return t;
}


/* Si el token contenido en la entrada no coincide con ninguna regla
    entonces se marca un token ilegal */
    [^] { 
            throw new Error("Caracter ilegal <"+yytext()+">"); 
        }
