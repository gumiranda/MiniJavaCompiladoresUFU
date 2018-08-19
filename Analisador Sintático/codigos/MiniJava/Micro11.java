import java.util.*;

public class Micro11 {
	public static int verifica(int n){
int res;
if ( n > 0 )
res = 1;
else if ( n < 0)
res = -1;
else
res = 0;
return res;
}

 public static void main (String [ ] args ) {
int numero, x;
System.out.println("Digite um número: ");
Scanner sc = new Scanner(System.in); 
    numero = sc.nextInt();x = verifica(numero);
if ( x == 1 )
System.out.println("Numero positivo");
else if ( x == 0)
System.out.println("Zero");
else System.out.println("Numero negativo");

 }
 }
