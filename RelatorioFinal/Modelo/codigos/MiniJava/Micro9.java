import java.util.*;

public class Micro9 {
 public static void main (String [ ] args ) {
double preco, venda, novo_preco;
novo_preco = 0;
    Scanner sc = new Scanner ( System.in ); 
System.out.println("Digite o preco: ");
    preco = sc.nextDouble();
System.out.println("Digite a venda: ");
    venda = sc.nextDouble();
 if ( (venda < 500) || ( preco < 30 ) )
 novo_preco = preco + 10/100 * preco;
   else if ( (venda >= 500 && venda < 1200) || (preco >= 30 && preco < 80) )
   novo_preco = preco + 15/100 * preco;
      else if ( venda >= 1200 || preco >= 80 )
      novo_preco = preco - 20/100 * preco;
      System.out.println("O novo preco e " + novo_preco);
 }
 }
