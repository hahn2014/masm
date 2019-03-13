TITLE Project 7 - RedBlackTree		(RedBlackTree.asm)

; Author: Bryce Hahn
; Project ID: Project 7
; Date: 3/13/2019
; Description:
;	Red Black Tree, options to read in values from
;	a given file, auto generated within a given
;	number of values, or through user input. Prints
;	sorted tree to the console.

INCLUDE Irvine32.inc

.data
MAXNUM			=		1																					; The min number of nodes that can be written
MINNUM			=		500																					; The max number of nodes that can be written

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
;---------------------------------------------------------------;
;	Macro mWriteDec prints out an Integer to the screen, this	;
;	can be either a whole integer or a decimal					;
;---------------------------------------------------------------;
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
mWrite			MACRO	text
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
mWriteLn		MACRO	text
	mWrite	text
	call	CrLf
ENDM

.code
;---------------------------------------------------------------;
;	main PROC will be called once the program is run, this		;
;	is where we can call other processes so that we aren't		;
;	crowded into the main function like this (GROSS), so we		;
;	will implement this into further projects.					;
;---------------------------------------------------------------;
main	PROC
		call		Randomize																				; set the time seed for the randomize functions in order to keep the generator psuedo-random
		call		Intro																					; Introduce the user to the program
		call		GetUserRunOption																		; Get the user desired run option
		call		ExecuteRunOption																		; Start the tree construction based on user option
	exit																									; close program, return to OS
main	ENDP																								; the main PROC is finished, this symbolyses that we are done with the proc

;---------------------------------------------------------------;
;	The intro procedure will be called right off the bat, sort	;
;	of like before using procedures. This will allow to keep	;
;	the main function clean and organized, making debugging		;
;	easier! This function litterally just calls all intro		;
;	scripts.													;
;																;
;	Parameters:		n/a											;
;	Returns:		n/a											;
;	Pre-Conditions:	called varaibles must be real strings		;
;	Changed Regs:	eax, edx									;
;---------------------------------------------------------------;
Intro	PROC
	mov				eax, cyan + (black * 16)																; color varaibles consist of: black, white, brown, yellow, blue, green, cyan, red, magenta, gray, 
	call			setTextColor																			;							  lightBlue, lightGreen, lightCyan, lightRed, lightMagenta, and lightGray.

	mWriteLn		"Welcome to Red-Black Tree Sorting! Please select one of the following:"
	mWriteLn		"[1] Read values from input.txt"
	mWriteLn		"[2] Auto-Generate a given number of values"
	mWriteLn		"[3] Input each individual values"
	call			CrLf
	ret
intro	ENDP

;---------------------------------------------------------------;
;	The GetUserRunOption procedure takes in the user input to	;
;	decide which option the program will go with. The procedure	;
;	actively validates inputs to ensure proper options.			;
;																;
;	Parameters:		n/a											;
;	Returns:		n/a											;
;	Pre-Conditions:	n/a											;
;	Changed Regs:	eax, edx									;
;---------------------------------------------------------------;
GetUserRunOption PROC
	startUserInput:
		mWrite		"Please choose and option [1-3]: "
		xor			eax, eax																				; Completly clear eax register
		call		ReadDec																					; get user input

	verifyUserInput:
		cmp			eax, 1																					; make sure the user inputed something within 1-3 range
		jl			invalidInput																			; too low of an input value
		cmp			eax, 3
		jg			invalidInput																			; too high of an input value
		ret

	invalidInput:
		mWriteLn	"The entered value was not within the given option range."
		jmp			startUserInput

GetUserRunOption ENDP

;---------------------------------------------------------------;
;	The ExecuteRunOption process calls the given user inputted	;
;	option for the program to continue.							;
;																;
;	Parameters:		option in eax								;
;	Returns:		n/a											;
;	Pre-Conditions:	eax contains 1-3 range options				;
;	Changed Regs:	eax, edx									;
;---------------------------------------------------------------;
ExecuteRunOption PROC
	cmp				eax, 1
	je				fileOption																				; User will run file load tree builder
	cmp				eax, 2
	je				generateOption																			; User will run auto-generated tree builder
	cmp				eax, 3
	je				inputOption																				; User will run self-inputed tree builder
	jmp				invalidOption																			; User somehow got past the int validater, end

	fileOption:
		call		LoadFileOption
		ret

	generateOption:
		call		GenerateValuesOption
		ret

	inputOption:
		call		InputValuesOption
		ret

	invalidOption:
		mWriteLn	"Invalid Input! This error is a rare case where the invalid user input passed input checks..."
		ret

ExecuteRunOption ENDP

;---------------------------------------------------------------;
;	The LoadFileOption procedure is called when the user chose	;
;	to load the RBT with values off a file, specifically from	;
;	input.txt. If the file doesn't exist, we will warn the user	;
;	then quit.													;
;																;
;	Parameters:		n/a											;
;	Returns:		n/a											;
;	Pre-Conditions:	file.txt exists								;
;	Changed Regs:	
;---------------------------------------------------------------;
LoadFileOption PROC
	
	ret
LoadFileOption ENDP

;---------------------------------------------------------------;
;	The GenerateValuesOption procedure is called when the user	;
;	chose to load the RBT with auto-generated values by the		;
;	program. The user specifies how many values to generate.	;
;																;
;	Parameters:		n/a											;
;	Returns:		n/a											;
;	Pre-Conditions:	n/a											;
;	Changed Regs:	eax, edx
;---------------------------------------------------------------;
GenerateValuesOption PROC
	
	ret
GenerateValuesOption ENDP

;---------------------------------------------------------------;
;	The InputValuesOption procedure is called when the user		;
;	chose to load the RBT with user specified values. The user	;
;	can continue adding, deleting and searching until further	;
;	specified.													;
;																;
;	Parameters:		n/a											;
;	Returns:		n/a											;
;	Pre-Conditions:	n/a											;
;	Changed Regs:	eax, edx
;---------------------------------------------------------------;
InputValuesOption PROC
	
	ret
InputValuesOption ENDP




END main																									; the symbolyses that the main program is finished