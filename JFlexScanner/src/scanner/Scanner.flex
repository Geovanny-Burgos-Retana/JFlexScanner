package scanner;
import static scanner.Token.*;

%%
%class Scanner
%type Token
%line
%column
%unicode
letra = [A-Za-z]
digito = [0-9]
alfanumerico = {letra}|{digito}
other_id_char = [_]
identificador = {letra}({alfanumerico}|{other_id_char})*
entero = {digito}*
real = {entero}\.{entero}
char = '.'
whitespace = [ \n\t]

%{
        public String lexeme;
%}
%%

{whitespace} {/*Ignore*/}
and {return AND;}
array {return ARRAY;}
begin {return BEGIN;}
boolean {return BOOLEAN;}
byte {return BYTE;}
case {return CASE;}
char {return CHAR;}
const {return CONST;}
div {return DIV;}
do {return DO;}
downto {return DOWNTO;}
else {return ELSE;}
end {return END;}
false {return FALSE;}
file {return FILE;}
for {return FOR;}
forward {return FORWARD;}
function {return FUNCTION;}
goto {return GOTO;}
if {return IF;}
in {return IN;}
inline {return INLINE;}
int {return INT;}
label {return LABEL;}
longint {return LONGINT;}
mod {return MOD;}
nil {return NIL;}
not {return NOT;}
of {return OF;}
or {return OR;}
packed {return PACKED;}
procedure { return PROCEDURE;}
program {return PROGRAM;}
read {return READ;}
real {return REAL;}
record {return RECORD;}
repeat {return REPEAT;}
set {return SET;}
shortint {return SHORTINT;}
string {return STRING;}
then {return THEN;}
to {return TO;}
true {return TRUE;}
type {return TYPE;}
until {return UNTIL;}
var {return VAR;}
while {return WHILE;}
with {return WITH;}
write {return WRITE;}
xor {return XOR;}

{letra}({letra}|{digito})* {lexeme=yytext(); 
                                return ID;}
("(-"{digito}+")")|{digito}+ {lexeme=yytext(); 
                                return INT;}
. {return ERROR;}