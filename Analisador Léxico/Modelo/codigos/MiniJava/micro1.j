.class public micro1

 .super java/lang/Object


 .method public static main([Ljava/lang/String;)V

 ; limita pilha
 .limit stack 10
 ; limita variaveis locais
 .limit locals 10

 ; pega System.out
 getstatic java/lang/System/out Ljava/io/PrintStream;
 ldc " Tabela de conversão: Celsius -> Fahrenheit "
 ; chama System.out.println(String)
 invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V

 ; pega System.out
 getstatic java/lang/System/out Ljava/io/PrintStream;
 ; coloca string "Digite a temperatura em Celsius: " na pilha
 ldc "Digite a temperatura em Celsius: "
 ; chama System.out.print(String)
 invokevirtual java/io/PrintStream/print(Ljava/lang/String;)V
26
27 ; novo Scanner
28 new java/util/Scanner
29 ; duplica o Scanner na pilha
30 dup
31 ; pega System.in
32 getstatic java/lang/System/in Ljava/io/InputStream;
33 ; chama a funcao de criacao do Scanner
34 invokespecial java/util/Scanner/<init>(Ljava/io/InputStream;)V
35 ; guarda o Scanner na variavel 1
36 astore_1
37
38 ; carrega o scanner
39 aload_1
40 ; chama Scanner.nextFloat()
41 invokevirtual java/util/Scanner/nextFloat()F
42
43 ; converte o que esta no topo da pilha de float para double
44 f2d
45 ; guarda este double na variavel 2
46 dstore_2
47
48 ; carrega o valor 9.0 para a pilha
49 ldc2_w 9.0
50 ; coloca a variavel 2 no topo da pilha
51 dload_2
52 ; multiplica os 2 doubles no topo da pilha
53 dmul
54
55 ; carrega o valor 160.0 para a pilha
56 ldc2_w 160.0
57 ; soma os 2 doubles no topo da pilha
58 dadd
59
60 ; carrega o valor 5.0 para a pilha
61 ldc2_w 5.0
62 ; divide os 2 doubles no topo da pilha
63 ddiv
64 ; guarda o resultado dessa sequencia de operacoes na variavel 4
65 dstore 4
66
67 ; pega System.out
68 getstatic java/lang/System/out Ljava/io/PrintStream;
69 ; chama System.out.println()
70 invokevirtual java/io/PrintStream/println()V
71
72 ; pega System.out
73 getstatic java/lang/System/out Ljava/io/PrintStream;