TITLE Project 7 - RedBlackTree		(RedBlackTree.asm)

; Author: Bryce Hahn
; Project ID: Project 7
; Date: 3/14/2019
; Description:
;	Red Black Tree, options to read in values from
;	a given file, auto generated within a given
;	number of values, or through user input. Prints
;	sorted tree to the console.

INCLUDE Irvine32.inc
INCLUDE	Node.inc

.data
MINIMUM			=		1																					; The min number of nodes that can be written
MAXIMUM			=		500																					; The max number of nodes that can be written
MAXIMUMVAL		=		1000																				; highest value enterable into the array
unsorted_list	DWORD	MAXIMUM DUP(?)																		; The list that unsorted values will be placed in with a max array size of 500
BUFFER_SIZE		=       5000																				; Max size for a file buffer
buffer			DWORD   BUFFER_SIZE dup (?)																	; file buffer
bytesRead		DWORD	0																					; temp to keep track of bytes
infileH			DWORD   0
inFilename		BYTE    "input.txt", 0																		; file name
;root			node	<>

;#region Macro Setup

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
;#endregion

.code
;---------------------------------------------------------------;
;	main PROC will be called once the program is run, this		;
;	is where we can call other processes so that we aren't		;
;	crowded into the main function like this (GROSS), so we		;
;	will implement this into further projects.					;
;---------------------------------------------------------------;
main	PROC
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
;	The PrintUnsortedList process is called once all the data	;
;	has been stored into the unsorted array, and will then be	;
;	printed to the screen to give the user a heads up on the	;
;	data going into the tree.									;
;																;
;	Parameters:		unsorted_list								;
;	Returns:		n/a											;
;	Pre-Conditions:	unsorted_list contains at least 1 value		;
;	Changed Regs:	eax, ebx, ecx, edx, esi						;
;---------------------------------------------------------------;
PrintUnsortedList PROC
	push			ebp
	mov				ebp, esp

	mov				ebx, 0
	mov				ecx, 0
	mov				esi, OFFSET unsorted_list

	PrintLoop:
		mov			eax, [esi + ebx * 4]																	; move current index value to eax
		cmp			eax, 0																					; first 0 we encounter is the end of the list
		je			EndPrint
		mWriteDec	eax
		inc			ecx																						; increase line print count
		cmp			ecx, 10																					; see if we've printed 10 values on a line
		je			NewLine
		jne			OldLine

		NewLine:
			call	CrLf
			mov		ecx, 0																					; start line count again
			jmp		NextCall
		OldLine:
			mWrite	","
			call	PropSpacing
			jmp		NextCall
		NextCall:
			inc		ebx
			cmp		ebx, LENGTHOF unsorted_list
			je		EndPrint
			jne		PrintLoop
	EndPrint:
		call		CrLf
		pop			ebp
		ret
PrintUnsortedList ENDP

;---------------------------------------------------------------;
;	The PropSpacing procedure will be called when spacing out	;
;	the unsorted values to align them properly.					;
;																;
;	Parameters:		current value [ebp - 8]						;
;	Returns:		n/a											;
;	Pre-Conditions:	unsorted_list contains at least 1 value		;
;	Changed Regs:	eax, edx, edi								;
;---------------------------------------------------------------;
PropSpacing PROC
	cmp				eax, 10
	jl				singleDigit
	cmp				eax, 100
	jl				doubleDigit
	cmp				eax, 1000
	jl				tripleDigit
	jmp				quadrupleDigit

	singleDigit:
		mov			edi, 5
		jmp			printLoop
	doubleDigit:
		mov			edi, 4
		jmp			printLoop
	tripleDigit:
		mov			edi, 3
		jmp			printLoop
	quadrupleDigit:
		mov			edi, 2
		jmp			printLoop

	printLoop:
		mWrite		" "
		dec			edi
		cmp			edi, 0
		jg			printLoop
		ret
PropSpacing	ENDP

;---------------------------------------------------------------;
;	The VerifyDuplicates procedure will be called each time a	;
;	a value is about to be inserted into the unsorted list.		;
;	This will ensure that the list remains filled with variable	;
;	values.														;
;																;
;	Parameters:		push all registers to stack to save any		;
;						valuable information. Then the compare	;
;						value (putting it at ebp + 8)			;
;	Returns:		edi = 1 if duplicate, 0 if not duplicate	;
;	Pre-Conditions:	ebp + 8 contains an integer					;
;	Changed Regs:	eax, ecx, ebx, esi, edi, ebp				;
;---------------------------------------------------------------;
VerifyDuplicates PROC
	push			ebp
	mov				ebp, esp

	mov				ebx, 0
	mov				esi, OFFSET unsorted_list
	LoopThroughArray:
		mov			eax, [esi + ebx * 4]																	; move current index value to eax
		mov			ecx, [ebp + 8]																			; move reference generated value to ecx
		cmp			eax, 0																					; first 0 we encounter is the end of the array
		je			NoDuplicateValue																		; if we're still in the loop and hit a 0, there were no dupes
		cmp			eax, ecx																				; compare generated to current array index
		je			DuplicateValue																			; if they're the same it's equal
		inc			ebx																						; next index
		cmp			ebx, LENGTHOF unsorted_list																; test if we're at the end of the list
		je			NoDuplicateValue
		jne			LoopThroughArray
	DuplicateValue:
		mov			edi, 1																					; return 1 (for compare method to know it's a dupe)
		;mWriteDec	ecx
		;mWriteLn	" is a duplicate value!"
		pop			ebp
		ret
	NoDuplicateValue:
		mov			edi, 0																					; return 0 (for compare method to know it's not a dupe)
		;mWriteDec	ecx
		;mWriteLn	" is not a duplicate value!"
		pop			ebp
		ret
VerifyDuplicates ENDP

;#region File Data Input

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
	mWriteLn		"Loading data from input.txt..."
	;------Open File------;
	mov				edx, OFFSET inFilename
	call			OpenInputFile
	mov				infileH, eax
	;------Read File------;
	mov				edx, OFFSET buffer
	mov				ecx, BUFFER_SIZE
	call			ReadFromFile
	mov				bytesRead, eax
	;------Close File------;
	mov				eax, infileH
	call			CloseFile
	;------Convert Chars to Int------;
	lea				esi, OFFSET buffer
	lea				edi, OFFSET unsorted_list
	mov				edx, 0
	ConvertLoop:
		call		AsciiToInt
		mov			[edi], eax
		inc			edi
		inc			esi
		inc			edx
		cmp			edx, MAXIMUM - 1																		; We hit the max number of inputs allowed, don't convert the rest of the file
		jne			ConvertLoop
		jmp			FinishUp

	FinishUp:
		mov			eax, edx
		inc			eax
		mWrite		"Now Printing "
		mWriteDec	eax
		mWriteLn	" values from input.txt to insert into tree:"
		call		PrintUnsortedList																		; give the user a full list of unsorted values
		push		OFFSET unsorted_list																	; make sure we have access to the unsorted list
		call		SortToTree																				; call the sort procedure
		ret
LoadFileOption ENDP

AsciiToInt PROC
	mov				ecx, 0
	mov				eax, 0
	nextDigit:
		mov			bl, [esi]
		cmp			bl, '0'
		jl			LoopFinished
		cmp			bl, '9'
		jg			LoopFinished
		add			bl, -30h
		imul		eax, 10
		add			eax, ebx
		;mov		[esi], eax
		;mov		[edi], eax
		inc			ecx
		inc			esi
		;inc		edi
		jmp			nextDigit
	LoopFinished:
		ret
AsciiToInt ENDP

;#endregion

;#region Generate Data Input

;---------------------------------------------------------------;
;	The GenerateValuesOption procedure is called when the user	;
;	chose to load the RBT with auto-generated values by the		;
;	program. The user specifies how many values to generate.	;
;																;
;	Parameters:		n/a											;
;	Returns:		n/a											;
;	Pre-Conditions:	n/a											;
;	Changed Regs:	eax, edx, ecx, ebx, esi						;
;---------------------------------------------------------------;
GenerateValuesOption PROC
	call			Randomize																				; set the time seed for the randomize functions in order to keep the generator psuedo-random
	call			GetGenerationCount

	mWrite			"Now generating "
	mWriteDec		eax
	mWriteLn			" values to insert into tree:"

	mov				ecx, eax																				; loop through the desired generationcount num held on eax.
	mov				esi, OFFSET unsorted_list																; point to array address
	mov				ebx, 0
	GenerateRandNum:
		mov			eax, MAXIMUMVAL																			; eax will be the max range to generate
		dec			eax																						; 999 is where we want, because randomrange includes 0.
		call		RandomRange
		inc			eax																						; this now gives us a random value from 1 to 1000.
		
		push		ebx																						; save all register values
		push		ecx
		push		eax
		call		VerifyDuplicates																		; Ensure there is no dupe
		pop			eax
		pop			ecx
		pop			ebx																						; restore all register values
		
		cmp			edi, 1																					; VerifyDuplicates will return 1 if true
		je			GenerateRandNum																			; if true, we need to gen a different number on the same index
		mov			[esi + ebx * 4], eax																	; no dupe, store the generated value into array[loop count * 4 bytes]
		inc			ebx																						; update index counter
		loop		GenerateRandNum																			; keep going until ecx = 0

	call			PrintUnsortedList																		; give the user a full list of unsorted values
	push			OFFSET unsorted_list																	; make sure we have access to the unsorted list
	call			SortToTree																				; call the sort procedure
	ret
GenerateValuesOption ENDP

;---------------------------------------------------------------;
;	The GetGenerationCount procedure gets from user input their	;
;	desired number of values to be added to the tree within the	;
;	defined range of 1-500.										;
;																;
;	Parameters:		n/a											;
;	Returns:		Generation count to eax						;
;	Pre-Conditions:	n/a											;
;	Changed Regs:	eax, edx									;
;---------------------------------------------------------------;
GetGenerationCount PROC
	getInput:
		mWrite		"Please enter how many values you wish to generate [1-500]: "
		call		ReadDec

	VerifyInput:
		cmp			eax, MINIMUM																			; user inputed a value too low
		jl			InvalidInput
		cmp			eax, MAXIMUM																			; user inputed a value too high
		jg			InvalidInput
		jmp			ValidInput																				; input is within range

	InvalidInput:
		mWrite		"The entered value "
		mWriteDec	eax
		mWriteLn	" is outside of the designated range."
		jmp			getInput

	ValidInput:
		ret																									; return generation count on eax
GetGenerationCount ENDP

;#endregion

;#region User Input Data

;---------------------------------------------------------------;
;	The InputValuesOption procedure is called when the user		;
;	chose to load the RBT with user specified values. The user	;
;	can continue adding, deleting and searching until further	;
;	specified.													;
;																;
;	Parameters:		n/a											;
;	Returns:		n/a											;
;	Pre-Conditions:	n/a											;
;	Changed Regs:	eax, ecx, edx, esi							;
;---------------------------------------------------------------;
InputValuesOption PROC
	mov				esi, OFFSET unsorted_list
	mov				ecx, 0
	NewInput:
		call		GetUserInputData
		cmp			eax, 0
		je			DoneWithInput
		jmp			AddToArray
	AddToArray:
		push		ecx																						; save all register values
		push		eax
		call		VerifyDuplicates																		; Ensure there is no dupe
		pop			eax
		pop			ecx																						; restore all register values
		
		cmp			edi, 1																					; VerifyDuplicates will return 1 if true
		je			DuplicateInput
		mov			[esi + ecx * 4], eax																	; store value to array[index * 4 bytes]
		inc			ecx																						; next index value
		cmp			ecx, MAXIMUM																			; make sure we haven't hit 500
		je			MaxInputs
		jmp			NewInput
	DuplicateInput:
		mWriteDec	eax
		mWriteLn	" was a duplicate! Please enter a different value."
		jmp			NewInput
	MaxInputs:
		mWriteLn	"You've Inputted the max number of inputs for the tree.."
	DoneWithInput:
		mWrite		"Now printing your "
		mWriteDec	ecx
		mWriteLn	" inputted values:"
		call		PrintUnsortedList																		; give the user a full list of unsorted values
		push		OFFSET unsorted_list																	; make sure we have access to the unsorted list
		call		SortToTree																				; call the sort procedure
		ret
InputValuesOption ENDP

;---------------------------------------------------------------;
;	The GetUserInputData procedure is called when the program	;
;	needs to fill the array with data. It will continue to be	;
;	called while the user wishes to add more values to the tree.;
;																;
;	Parameters:		n/a											;
;	Returns:		eax contains the new inputted value			;
;	Pre-Conditions:	n/a											;
;	Changed Regs:	eax, edx									;
;---------------------------------------------------------------;
GetUserInputData PROC
	GetValue:
		xor			eax, eax																				; completly clear eax register
		mWrite		"Please enter a data value [1-1000] or 0 to stop:"
		call		ReadDec

	VerifyInput:
		cmp			eax, MAXIMUMVAL
		jg			InvalidInput
		cmp			eax, 0
		je			ValidInput
		cmp			eax, MINIMUM
		jl			InvalidInput
		jmp			ValidInput

	InvalidInput:
		mWriteLn	"The entered value was not within the defined range."
		jmp			GetValue
	ValidInput:
		ret
GetUserInputData ENDP


;#endregion

;#region Red-Black Tree Methods

SortToTree PROC
	push			ebp
	mov				ebp, esp

	mWriteLn		"Now sorting list to Red-Black Tree:"
	mWriteLn		"lol if you thought this would be done first you're incredibly mistaken"

	pop				ebp
	ret 4
SortToTree ENDP


;#endregion

END main																									; the symbolyses that the main program is finished