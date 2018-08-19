import java.util.*;

public class Micro8 {
 public static void main (String [ ] args ) {
int numero;
numero = 1;
while ( numero != 0 ) {
System.out.println("Digite um número: ");
Scanner sc = new Scanner(System.in); 
    numero = sc.nextInt();
if ( numero > 10 ){
System.out.println("O número " + numero + " é maior que 10"); 
}
else{
System.out.println("O número " + numero + " é menor que 10"); 
}
 }
 }
}