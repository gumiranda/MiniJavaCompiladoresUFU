import java.util.*;

public class Micro4 {
 public static void main (String [ ] args ) {
int x, num, intervalo;
intervalo = 0;
for ( x = 1; x <= 5; x++){
	System.out.println("Digite o número: ");
	Scanner sc = new Scanner(System.in); 
    num = sc.nextInt();
if ( num >= 10 ){
	if ( num <= 150 ){
intervalo = intervalo + 1;
}}
}
	System.out.println("Ao total, foram digitados " + intervalo + " números no intervalo entre 10 e 150");

 }
 }
