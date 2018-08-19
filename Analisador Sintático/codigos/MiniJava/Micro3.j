.class public micro3

 .super java/lang/Object


 .method public static main([Ljava/lang/String;)V

 ; limita pilha
 .limit stack 10
 ; limita variaveis locais
 .limit locals 10

 ; pega System.out
 getstatic java/lang/System/out Ljava/io/PrintStream;