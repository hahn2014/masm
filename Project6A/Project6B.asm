TITLE Program 6A		(Project6A.asm)

; Author: Bryce Hahn
; Course/Project ID: CS 271 Project 6A
; Date: 3/12/2019
; Description:
;	

INCLUDE Irvine32.inc

;-----------------------;
;    Var Declaration    ;
;-----------------------;
.data

project			BYTE	"-	 Low Level IO    --   Bryce Hahn  -", 0
intro_1			BYTE	"The program will ask for 10 unsigned integers, receive input until 10 proper ", 0	; Intro 1
intro_2			BYTE	"inputs have been made. The inputted integers need to be within 32-bit size.  ", 0	; Intro 2
intro_3			BYTE	"I will then display the array of inputted integers,then I will add them up ", 0	; Intro 3
intro_4			BYTE	"and display the sum and average.", 0												; Intro 4
EC_intro_1		BYTE	"EC: I keep track of how many problems the user gets right vs. wrong",0				; EC 1
EC_intro_2		BYTE	"EC: I utalise the floating point operators and registers for calculations", 0		; EC 2

prompt_1		BYTE	"Please enter an unsigned integer: ", 0												; Prompt for user solution
failed_input_1	BYTE	"Invalid Responce! The input was not an integer or was outside the 32 value.", 0	; The user didn't input a number in for the solution

input_1			BYTE	"You Inputed: ", 0

outro_1			BYTE	"The sum of the inputs is: ", 0
outro_2			BYTE	"The average of the inputs is:  ", 0
finished		BYTE	"Thank you for using my program! Goodbye.", 0										; Thank the user and say goodbye by name input

MIN				= 0
LO				= 30h
HI				= 39h
MAX_SIZE		= 10
request         DWORD    10 DUP(0)
requestCount	DWORD    ?
list            DWORD    MAX_SIZE DUP(?)
strResult       db       16 dup (0)
currentNumber   DWORD    1


; ====================================================================================================================
;             Macro: getString
;       Description: Prompt the user for input and store input as string.
;          Receives:  instruction: instruction string message
;                         request: input buffer
;                    requestCount: number of digits entered
;                    currentIndex: current input number
;           Returns: none
; Registers Changed: edx
; ====================================================================================================================
getString MACRO instruction, request, requestCount, currentIndex
    push       edx
    push       ecx
    push       eax
    push       ebx

    mov        eax, currentIndex
    call       WriteDec

    mov        edx, OFFSET prompt_1
    call       WriteString
    mov        edx, OFFSET request
    mov        ecx, SIZEOF    request
    call       ReadString
    mov        requestCount, 00000000h
    mov        requestCount, eax

    pop        ebx
    pop        eax
    pop        ecx
    pop        edx

ENDM


; ====================================================================================================================
;             Macro: displayString
;       Description: Prints the given message
;          Receives: message: message string
;           Returns: none
; Registers Changed: edx
; ====================================================================================================================
displayString MACRO message
    push       edx
    mov        edx, message
    call       WriteString
    pop        edx

ENDM

;---------------------------------------------------------------;
;	Macro mPrintString replaces having to move a byte to edx	;
;	and call writeString with only one line. also allows for	;
;	pretty lazy debuging which is a plus.						;
;	THIS METHOD ONLY WORKS WITH VARAIBLES						;
;---------------------------------------------------------------;
mWriteString	MACRO	buffer:REQ
	push	edx
	mov		edx, OFFSET buffer
	call	WriteString
	pop		edx
ENDM

;---------------------------------------------------------------;
;	Macro mWriteStringLn is the same as mWriteString but adds	;
;	a new line after the printed text so you don't have to write;
;	a new line call in the main functions.						;
;---------------------------------------------------------------;
mWriteStringLn	MACRO	buffer:REQ
	mWriteString	buffer
	call	CrLf
ENDM

mWriteDec		MACRO	decimal
	push	eax
	mov		eax, decimal
	call	WriteDec
	pop		eax
ENDM

;---------------------------------------------------------------;
;	Macro mWrite lets you write a string to the output without	;
;	pre-emptively defining it, I.E in quotes you can write		;
;	anything to the output.										;
;---------------------------------------------------------------;
mWrite		MACRO	text
	LOCAL	string
	.data
	string	BYTE	text, 0

	.code
	push	edx
	mov		edx, OFFSET string
	call	WriteString
	pop		edx
ENDM

;---------------------------------------------------------------;
;	Macro mWriteLn is the same as mWrite but adds a new line	;
;	call at the end so you don't have to write on in the code	;
;	section of the functions.									;
;---------------------------------------------------------------;
mWriteLn	MACRO	text
	mWrite	text
	call	CrLf
ENDM

;------------------------;
;    Code Declaration    ;
; This section is where	 ;
; the bulk of the program;
; is going to be writen  ;
;------------------------;
.code
; ====================================================================================================================
;         Procedure: main
;       Description: Calls other procedures to drive the program.
;          Receives: none
;           Returns: none
; Registers Changed: edx
; ====================================================================================================================
 main PROC
    call       introduction

    push       OFFSET list				; +16
    push       OFFSET request			; +12
    push       OFFSET requestCount		; +8
    call       readVal
    call       CrLf

    push       OFFSET outro_2			; +16
    push       OFFSET outro_1			; +12
    push       OFFSET list				; +8
    call       displayAve
    call       CrLf

    push       edx						; +12
    mov        edx, OFFSET input_1		; +8
    call       WriteString
    pop        edx

    push       OFFSET strResult			; +12
    push       OFFSET list				; +8
    call       writeVal
    call       CrLf

    push       OFFSET finished			; + 8
    call       farewell

    exit
main ENDP


; ====================================================================================================================
;         Procedure: introduction
;       Description: Prints program instructions and introduction.
;          Receives: none
;           Returns: none
; Registers Changed: none
; ====================================================================================================================
introduction PROC
	mov		eax, cyan + (black * 16)			; color varaibles consist of: black, white, brown, yellow, blue, green, cyan, red, magenta, gray, lightBlue, lightGreen, lightCyan, lightRed, lightMagenta, and lightGray.
	call	setTextColor						; EXTRA CREDIT: change background and foreground colors

	mWriteStringLn	project
    mWriteStringLn	intro_1
    mWriteStringLn	intro_2
    mWriteStringLn	intro_3
    mWriteStringLn	intro_4
    mWriteStringLn	EC_intro_1
    mWriteStringLn	EC_intro_2
    ret
introduction ENDP


; ====================================================================================================================
;         Procedure: readVal
;       Description: Receives and validates integers from the user and
;                    transforms decimal values into strings.
;          Receives: an array to store values in, a buffer to read the input
;           Returns: puts user's integers into an array of strings
; Registers Changed: edx, eax, ecx, ebx
; ====================================================================================================================
readVal PROC
    push       ebp
    mov        ebp, esp
    mov        ecx, 10
    mov        edi, [ebp + 16]

    getInput:
	getString	prompt_1, request, requestCount, ecx

    push       ecx
    mov        esi, [ebp + 12]
    mov        ecx, [ebp + 8]
    mov        ecx, [ecx]
    cld
    mov        eax, 00000000
    mov        ebx, 00000000

    convertToInt:
    lodsb

    cmp        eax, LO
    jb         inputError
    cmp        eax, HI
    ja         inputError

    sub        eax, LO
    push       eax
    mov        eax, ebx
    mov        ebx, MAX_SIZE
    mul        ebx
    mov        ebx, eax
    pop        eax
    add        ebx, eax
    mov        eax, ebx

    mov        eax, 00000000
    loop       convertToInt

    mov        eax, ebx
    stosd

    add        esi, 4
    pop        ecx
    loop       getInput
    jmp        readValEnd

    inputError:
    pop        ecx
    mov        edx, OFFSET failed_input_1
    call       WriteString
    call       CrLf
    jmp        getInput

    readValEnd:
    pop ebp

    ret 12
readVal ENDP


; ====================================================================================================================
;         Procedure: writeVal
;       Description: Utilizes 'displayString' macro to convert strings to ASCII
;                    and print to console.
;          Receives:    list: @array
;                    request: number of array elements
;           Returns: none
; Registers Changed: eax, ecx, ebx, edx
; ====================================================================================================================
writeVal PROC
    push		ebp
    mov			ebp, esp
    mov			edi, [ebp + 8]
    mov			ecx, 10

    outerLoop:
    push		ecx
    mov			eax, [edi]
    mov			ecx, 10
    xor			bx, bx

    divide:
    xor			edx, edx
    div			ecx
    push		dx
    inc			bx
    test		eax, eax
    jnz			divide

    mov			cx, bx
    lea			esi, strResult
    nextDigit:
    pop			ax
    add			ax, '0'
    mov			[esi], ax

    displayString OFFSET strResult

    loop		nextDigit

    pop			ecx
    mWrite		", "
    mov			edx, 0
    mov			ebx, 0
    add			edi, 4
    loop		outerLoop

    pop			ebp

    ret			8
writeVal ENDP


; ====================================================================================================================
;         Procedure: displayAve
;       Description: Calculates the average and sum of a given array of numbers
;          Receives: list: @array
;           Returns: none
; Registers Changed: eax, ebx, ecx, edx
; ====================================================================================================================
displayAve PROC
    push       ebp
    mov        ebp, esp
    mov        esi, [ebp + 8]
    mov        eax, 10
    mov        edx, 0
    mov        ebx, 0
    mov        ecx, eax

    medianLoop:
    mov        eax, [esi]
    add        ebx, eax
    add        esi, 4
    loop       medianLoop

    endMedianLoop:
    mov        edx, 0
    mov        eax, ebx
    mov        edx, [ebp + 12]
    call       WriteString
    call       WriteDec
    call       CrLf
    mov        edx, 0
    mov        ebx, 10
    div        ebx
    mov        edx, [ebp + 16]
    call       WriteString
    call       WriteDec
    call       CrLf

    endDisplayMedian:
    pop        ebp

    ret        12
displayAve ENDP


; ====================================================================================================================
;         Procedure: farewell
;       Description: Prints farewell message.
;          Receives: message: string message
;           Returns: none
; Registers Changed: edx
; ====================================================================================================================
farewell PROC
    push       ebp
    mov        ebp, esp
    mov        edx, [ebp + 8]

    call       CrLf
    call       WriteString
    call       CrLf
    pop        ebp

    ret        4
farewell ENDP

END main