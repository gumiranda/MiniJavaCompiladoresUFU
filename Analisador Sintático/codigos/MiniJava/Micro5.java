import java.util.*;

public class Micro5 {
 public static void main (String [ ] args ) {
String nome;
    Scanner sc = new Scanner ( System.in ); 
char sexo;
int x,h,m;
h=0;
m=0;
m = 0;
for ( x = 1; x <= 5; x++){
System.out.println("Digite o nome: ");
nome =  sc.nextLine();
System.out.println("Digite o sexo: ");
sexo = sc.nextLine().charAt(0);
switch (sexo){
case 'H': h = h + 1; break;
case 'M': m = m + 1; break;
default: System.out.println("Sexo só pode ser H ou M!");
break;
}
}
System.out.println("Foram inseridos " + h + " Homens");
System.out.println("Foram inseridos " + m + " Mulheres");
 }
 }