import java.util.*;

public class Micro10 {
	public static int fatorial (int n){
if ( n <= 0)
return 1;
else
return n * fatorial(n-1);
}
 public static void main (String [ ] args ) {
int numero, fat;
System.out.println("Digite um número: ");
Scanner sc = new Scanner (System.in); 
    numero = sc.nextInt();
fat = fatorial(numero);
System.out.println("O fatorial de ");
System.out.println(numero);
System.out.println(" é ");
System.out.println(fat);

 }
 }
