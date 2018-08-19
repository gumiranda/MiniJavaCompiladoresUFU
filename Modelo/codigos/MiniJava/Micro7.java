import java.util.*;

public class Micro7 {
 public static void main (String [ ] args ) {
int programa, numero;
char opc;
programa = 1;
while ( programa == 1 ){
System.out.println("Digite um número: ");
Scanner sc = new Scanner(System.in); 
    numero = sc.nextInt();
	if ( numero > 0 ){
System.out.println("Positivo");
	}else {
if ( numero == 0 ){
System.out.println("O número é igual a 0"); }
if ( numero < 0 ) {
System.out.println("Negativo"); }
}
System.out.println("Desja finalizar? (S/N) ");
opc = sc.nextLine().charAt(0);
if ( opc == 'S' ){
programa = 0;
}
}
 }
 }
