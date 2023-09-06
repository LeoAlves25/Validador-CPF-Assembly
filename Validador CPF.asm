org 100h

include 'emu8086.inc' ;Possibilitar o print na tela 

mov dx,offset file
mov al, 00h
mov ah, 3dh ;Codigo para a abertura do arquivo
int 21h  ;Interrupcao

mov bx, ax  ;File handle (argumento INT)
mov cx, 0000h
mov ds, cx  
mov dx, 0008h ;Local onde o primeiro valor dor arquivo sera posicionado
mov cx, 11  ;Informando a quantidade de numero que serao lidos
mov ah, 3fh ;Codigo para a leitura do arquivo
int 21h

;Arrumando os numeros subtraindo cada valor 
;pelo caracter '0', cujo valor na tabela ASCII eh 30

sub [0008h],'0'
sub [0008h+1],'0'
sub [0008h+2],'0'
sub [0008h+3],'0'
sub [0008h+4],'0'
sub [0008h+5],'0'
sub [0008h+6],'0'
sub [0008h+7],'0'
sub [0008h+8],'0'
sub [0008h+9],'0'
sub [0008h+10],'0'  


;Primeiro digito

mov cx, 0
mov al, 10 ;Atribuindo ao AL o valor de 10 para depois ir subtraindo
mul [0008h] ;Multiplicando o AL pelo valor que esta atribuido ao endereco
add cx, ax  ;Adicionando o valor obtido para o CX

mov al, 9
mul [0008h+1] ;Soma o endereco com mais um para que seja coletado o proximo valor
add cx, ax

mov al, 8
mul [0008h+2]
add cx, ax

mov al, 7
mul [0008h+3]
add cx, ax

mov al, 6
mul [0008h+4]
add cx, ax

mov al, 5
mul [0008h+5]
add cx, ax

mov al, 4
mul [0008h+6]
add cx, ax

mov al, 3
mul [0008h+7]
add cx, ax

mov al, 2
mul [0008h+8]
add cx, ax

mov ax, cx ;Passa o valor acumulado de CX para o AX para preparar a divisao
mov bl, 11 ;Atribui o valor de 11 ao BL para funcionar como divisor
div bl

cmp ah, 2 ;Comparacao entre o resto da divisao, que esta no AH, com o numero 2
jc divisaoZero1 ;Caso o resto da divisao seja menor que 2 ira para 'divisaoZero1'

mov dl, 11 ;Do contrario, ira diminuir 11 pelo valor do resto da divisao
sub dl, ah
jmp compDigito1

divisaoZero1:
mov dl, 0 ;Caso AH seja menor que 2, sera atribuido 0 ao valor do digito 1

compDigito1:
cmp dl, [0008h+9] ;Comparacao entre o valor obtido com o primeiro digito registrado
jz segundoDigito  ;Caso seja igual, ira para o passo 'segundoDigito'
jmp cpfInvalido   ;Do contrario ira encerrar o codigo na label 'cpfInvalido'
                
                
;Segundo digito
segundoDigito:
mov al, 11 ;Sera feito o mesmo passo a passo do digito 1, mas agora comecando do 11
mul [0008h]
mov cx, 0
add cx, ax  

mov al, 10
mul [0008h+1]
add cx, ax   

mov al, 9
mul [0008h+2]
add cx, ax

mov al, 8
mul [0008h+3]
add cx, ax

mov al, 7
mul [0008h+4]
add cx, ax

mov al, 6
mul [0008h+5]
add cx, ax

mov al, 5
mul [0008h+6]
add cx, ax

mov al, 4
mul [0008h+7]
add cx, ax

mov al, 3
mul [0008h+8]
add cx, ax

mov al, 2
mul [0008h+9] ;Eh adicionado para conta o digito 1 registrado
add cx, ax

mov ax, cx
mov bl, 11
div bl

cmp ah, 2
jc divisaoZero2

mov dl, 11
sub dl, ah
jmp compDigito2

divisaoZero2:
mov dl, 0

compDigito2:
cmp dl, [0008h+10]
jz cpfValido
jmp cpfInvalido

;Resultado
cpfValido: ;Se tudo estiver ok
PRINT 'C.P.F valido'
jmp fim


cpfInvalido: ;Caso um dos digitos nao esteja igual
PRINT 'C.P.F invalido'

fim:
ret

file db "cpf.txt", 0