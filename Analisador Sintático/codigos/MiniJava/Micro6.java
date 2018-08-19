import java.util.*;

public class Micro6 {
 public static void main (String [ ] args ) {
int numero;
System.out.println("Digite um número de 1 a 5: ");
   Scanner sc = new Scanner ( System.in ); 
    numero = sc.nextInt();
	switch(numero){
case 1: System.out.println("Um"); break;
case 2: System.out.println("Dois"); break;
case 3: System.out.println("Três"); break;
case 4: System.out.println("Quatro"); break;
case 5: System.out.println("Cinco"); break;
default: System.out.println("Número Inválido!!!"); break;
}
 }
 }
