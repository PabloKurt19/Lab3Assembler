//**** main
//** maina

 .text
 .balign 4
 .global main
 
main:
	
	@@utilizando la biblioteca GPIO (gpio0_2.s)
	@bl GetGpioAddress 
	
	

	ldr r0,=reachWidth
	ldr r0,[r0]
	ldr r1,=reachHeight
	ldr r1,[r1]
	ldr r2,=reach
	
	bl draw
	
	
	
	ldr r0,=masterWidth
	ldr r0,[r0]
	ldr r1,=masterHeight
	ldr r1,[r1]
	ldr r2,=master
	
	bl draw
	
	ldr r0,=mensaje
	bl puts
	
	
	ldr r0,=reachWidth
	ldr r0,[r0]
	ldr r1,=reachHeight
	ldr r1,[r1]
	ldr r2,=reach
	
	bl draw
	
	ldr r10,=x_checkpoint
	mov r11,#300
	str r11,[r10]
	
	ldr r0,=masterWidth
	ldr r0,[r0]
	ldr r1,=masterHeight
	ldr r1,[r1]
	ldr r2,=master
	
	bl draw

	@@GPIO para lectura puerto 7
	@mov r0,#7
	@mov r1,#0
	@bl SetGpioFunction
		
	
	#exit syscall
	mov r7,#1
    swi 0


	
/*
* Esta subrutina dibuja una imagen en 8 bits
* PARAMETROS: r0 = Width x, r1 = Height y, r2 = direccion de la matriz de pixeles a dibujar 
*/

draw:
        push {lr}
        push {r4-r9}    /* Standard ABI */  

        /* Se mueven los parametros a nuevos registros */
        mov r4, r0 
        mov r5, r1  
        mov r6, r2       
        
        /*       Reset Y      */
        ldr r2, =y
        mov r7, #0
        str r7, [r2]
        

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
        pop {r4-r9}     /* Standard ABI */
        pop {pc}

/************************************************************************
*/

drawCursor:
        push {lr}
        push {r4-r9}    /* Standrad ABI */  

        /* Se mueven los parametros a nuevos registros */
        mov r4, r0 
        mov r5, r1  
        mov r6, r2  
		mov r11, r3
		ldr r10,=y_cursor
		str r11,[r10]
		ldr r10,=cursorPos
		str r11,[r10]
        
        /********* Reset Y **********/
        ldr r2, =y
        mov r7, #0
        str r7, [r2]
       

        /* Se obtiene la direccion de pantalla */
        bl getScreenAddr
        ldr r1,=pixelAddr
        str r0,[r1]
                   
        mov r9, #0      /* Contador */

loopy_cursor:
        /******** Reset X ********/
        mov r8, #0
        ldr r7, =x_checkpoint2
        ldr r7, [r7]
        ldr r1, =x_cursor
        str r7, [r1]
      
        cmp r9, r5
		ldrgt r0,=cursorPos
        bgt end
        loopx_cursor:  
                ldr r0,=pixelAddr
                ldr r0,[r0]

                ldr r1,=x_cursor
                ldr r1,[r1]
                
                ldr r2,=y_cursor
                ldr r2,[r2]

                
                ldr r3, [r6], #4

                cmp r3, #240    /* Se dibuja solo si el pixel no es rosado magenta */
                blne pixel

                /* Barrido en X */
                ldr r1,=x_cursor
                ldr r7,[r1]
                add r7,#1
                str r7,[r1]

                add r8, #1
                cmp r8, r4
                blt loopx_cursor

        /* Barrido en Y */
        ldr r2, =y_cursor
        ldr r7, [r2]
        add r7, #1
        str r7, [r2]
        add r9, #1
       	b loopy_cursor
		
/************************************/
wait:
	push {lr}
	ldr r0, =constante
	ldr r0, [r0]
	delay:
	subs r0, #1
	bne delay
	pop {pc}




.data
.balign 4
/**************************************/
.global myloc
.global cursorPos
.global y1
.global y2
.global y3
.global posY

der:
	.word 0
myloc:
	.word 0x3F200000
posY:
	.word 504

cursorPos:
	.word 0
y1:
	.word 504
y2:
	.word 590
y3: 
	.word 643

/* Variables */
pixelAddr: 
	.word 0
x: 
	.word 0
x_checkpoint:
	.word 0
y: 
	.word 0
y_sprite: 
	.word 400
y_cursor:  
	.word 0
x_cursor:
	.word 340
x_checkpoint2:
	.word 340
mensaje:
	.asciz "Soy un boton que sirve"
constante: .word 598000000
