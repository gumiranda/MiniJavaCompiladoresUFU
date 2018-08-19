import java.util.Scanner;
//import java.io.*;
public class Micro1 {
 public static void main (String [ ] args ) {
double cel, far;
System.out.println("Tabela de conversão: Celsius -> Fahrenheit");
System.out.println("Digite a temperatura em Celsius:");
    Scanner sc1 = new Scanner ( System.in ); 
    cel = sc1.nextDouble();
far = (9*cel+160)/5;
System.out.println("A nova temperatura é " + far + " F");
 }
 }

 