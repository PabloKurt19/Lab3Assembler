/*
	Universidad del Valle de Guatemala
	Pedro Antonio García, 15409
	Pablo Alejandro Ortiz, 15533
	Laboratorio 3
*/

.text
.balign 4
.global main

main:

mov r6,#0
mov r4,#250
mov r3,#200
mov r5,#0

@@utilizando la biblioteca GPIO (gpio0_2.s)
bl GetGpioAddress 

@@GPIO para lectura puerto 5
mov r0,#5
mov r1,#0
bl SetGpioFunction

@@GPIO para lectura puerto 6
mov r0,#6
mov r1,#0
bl SetGpioFunction

@@GPIO para lectura puerto 13
mov r0,#13
mov r1,#0
bl SetGpioFunction

@@GPIO para lectura puerto 19
mov r0,#19
mov r1,#0
bl SetGpioFunction

@@GPIO para lectura puerto 26
mov r0,#26
mov r1,#0
bl SetGpioFunction

villanos1:

	mov r10,#0
	ldr r9,=x_checkpoint
	str r10,[r9]
	
	mov r10,#0
	ldr r9,=y_checkpoint
	str r10,[r9]
	
	ldr r0,=reachWidth
	ldr r0,[r0]
	ldr r1,=reachHeight
	ldr r1,[r1]
	ldr r2,=reach
	
	bl draw
	
	mov r10,#150
	ldr r9,=x_checkpoint
	str r10,[r9]
	
	ldr r9,=y_checkpoint
	str r6,[r9]
	
	ldr r0,=inquisidorWidth
	ldr r0,[r0]
	ldr r1,=inquisidorHeight
	ldr r1,[r1]
	ldr r2,=inquisidor
	
	bl draw

	
	ldr r10,=x_flood
	ldr r10,[r10]
	ldr r9,=x_checkpoint
	str r10,[r9]
	
	ldr r9,=y_checkpoint
	str r3,[r9]
	
	ldr r0,=floodWidth
	ldr r0,[r0]
	ldr r1,=floodHeight
	ldr r1,[r1]
	ldr r2,=flood
	
	bl draw
	
	ldr r10,=x_prometeo
	ldr r10,[r10]
	ldr r9,=x_checkpoint
	str r10,[r9]
	
	ldr r9,=y_checkpoint
	str r4,[r9]
	
	ldr r0,=prometeoWidth
	ldr r0,[r0]
	ldr r1,=prometeoHeight
	ldr r1,[r1]
	ldr r2,=prometeo
	
	bl draw
	
	ldr r0,=delayReg
	ldr r0,[r0]
	bl delay
	
	mov r0,#5	@puerto de entrada
	bl GetGpio
	
	mov r0,#6	@puerto de entrada
	bl GetGpio
	
	mov r0,#13	@puerto de entrada
	bl GetGpio
	
	mov r0,#19	@puerto de entrada
	bl GetGpio
	
	mov r0,#26	@puerto de entrada
	bl GetGpio
	
	add r5,#1
	add r6,r6,#30
	add r3,r3,#15
	add r4,r4,#50
	cmp r5,#25
	blt villanos1
	
	
	fin2:
	#exit syscall
	mov r7,#1
    swi 0


/*
* Esta subrutina dibuja una imagen en 8 bits
* PARAMETROS: r0 = Width x, r1 = Height y, r2 = direccion de la matriz de pixeles a dibujar 
*/

draw:
        push {lr}
        push {r3-r9}    /* Standard ABI */  

        /* Se mueven los parametros a nuevos registros */
        mov r4, r0 
        mov r5, r1  
        mov r6, r2       
        
        /*       Reset Y      */
        ldr r7, =y_checkpoint    
        ldr r7, [r7]
        ldr r1, =y
        str r7, [r1]
        

        /* Se obtiene la direccion de pantalla */
        bl getScreenAddr
        ldr r1,=pixelAddr
        str r0,[r1]      
        mov r9, #0      /* Contador */
		

loopy:
        /* Reset X */
        mov r8, #0
		ldr r7, =x_checkpoint    
        ldr r7, [r7]
        ldr r1, =x
        str r7, [r1]
      
        cmp r9, r5
        bgt fin
        loopx:  
                ldr r0,=pixelAddr
                ldr r0,[r0]

                ldr r1,=x
                ldr r1,[r1]
                
                ldr r2,=y
                ldr r2,[r2]

                
                ldr r3, [r6], #4
          
                cmp r3, #255    /* Se dibuja solo si el pixel no es blanco */
                blne pixel

                /* Barrido en X */
                ldr r1,=x
                ldr r7,[r1]
                add r7,#1
                str r7,[r1]

                add r8, #1
                cmp r8, r4
                blt loopx

        /* Barrido en Y */
        ldr r2, =y
        ldr r7, [r2]
        add r7, #1
        str r7, [r2]
        add r9, #1
        b loopy
		
		fin:    
        pop {r3-r9}     /* Standard ABI */
        pop {pc}
		
@ ---------------------------
@ Delay function
@ Input: r0 delay counter val
@ ---------------------------
delay:
    mov r7,#0

    b compare
loop:
    add r7,#1     //r7++
compare:
    cmp r7,r0     //test r7 == r0
    bne loop

    mov pc,lr
		
.data
.balign 4
/**************************************/
.global myloc
.global pixelAddr
myloc: .word 0
delayReg: .word 80000000
delayReg2: .word 70500000
pixelAddr: 
	.word 0
x_flood:
	.word 600
x_prometeo:
	.word 1000
x:
	.word 0
x_checkpoint:
	.word 0
y_flood:
	.word 200
y_checkpoint:
	.word 0
y:
	.word 0
mensaje:
	.asciz "Llego hasta aqui"
	