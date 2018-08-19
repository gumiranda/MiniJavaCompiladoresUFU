class teste {
int fat;
 static int fatorial(int n){
   if(n <= 0){
    return 1 ;
   } else {
    return n * fatorial(n - 1) ;
     }

} 

public static void main(String[] args) {
System.out.println("Digite o numero : ");
 fat = s.next();
fat = fatorial(fat);
System.out.println("o fatorial do número é : ");
System.out.println(fat);
}



 }

