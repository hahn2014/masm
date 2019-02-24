TITLE Program 5		(Project5.asm)

; Author: Bryce Hahn
; Course/Project ID: CS 271 Project 5
; Date: 2/20/2019
; Description:
;	This program asks users to enter a number between 10
;		and 200 as the base of how many random numbers
;		between the range of 100 and 999 will be 
;		generated. These generated numbers will be stored
;		in a consecutive array for reference. It will then
;		print all generated numbers (10 per line). Finally,
;		sorting the array from largest to smallest and 
;		store back into the array. Print the medain value of
;		the list. Then finally print the ordered list.
;		EC: 

INCLUDE Irvine32.inc

;-----------------------;
;    Var Declaration    ;
;-----------------------;
.data

project			BYTE	"-	 Number Composition   --   Bryce Hahn  -", 0
intro_1			BYTE	"Welcome to the Number Generator! I will take in an integer (from 10 to 200) to ", 0; Intro 1 
intro_2			BYTE	"represent how many random numbers you want to generate [from 100 and 999]. ", 0	; Intro 2
intro_3			BYTE	"I will verify integer inputs. I will then print the demanded number of ", 0		; Intro 3
intro_4			BYTE	"generated numbers to screen, print the median number, and then sort from ", 0		; Intro 4
intro_5			BYTE	"greatest to smallest, then finally print them in order.", 0						; Intro 5
EC_intro_1		BYTE	"EC: I use the recursive quick sort method.", 0										; EC 1
EC_intro_2		BYTE	"EC: I allign the numbers in columns instead of rows.", 0							; EC 2
EC_intro_3		BYTE	"EC: The generated numbers are first saved to a file, then loaded to the array.", 0	; EC 3
EC_intro_4		BYTE	"EC: The program utalizes floating point numbering systems.", 0						; EC 4   doubtful but we'll see
prompt_1		BYTE	"Please enter how many random numbers I should generate: ", 0						; Prompt for a random number
failed_input_1	BYTE	"The entered number was above the allowed range!", 0								; Warn the user that they can't input such a RIDICULOUSLY high number
failed_input_2	BYTE	"The entered number was bellow the allowed range!", 0								; Warn the user that they can't input such a CRAZY low number
outro_1			BYTE	"             ---  Outputting your unsorted array  ---             ", 0
outro_2			BYTE	"The array median is: ", 0
outro_3			BYTE	"             ---  Outputting your sorted array  ---             ", 0
finished		BYTE	"Thank you for using my program! Goodbye.", 0										; Thank the user and say goodbye by name input
space			BYTE	"    ", 0
filename		BYTE	"generated.txt", 0


MAXNUM			=		200																					; The maximum range for generated numbers
MINNUM			=		10																					; The minimum range for generated numbers
LOWEST			=		100																					; The lowest number that can be generated
HIGHEST			=		999																					; The largest number that can be generated
generationCount	DWORD	?
arrayHold		DWORD	MAXNUM DUP(?)
outputfile		DWORD	?


;------------------------;
;    Code Declaration    ;
; This section is where	 ;
; the bulk of the program;
; is going to be writen  ;
;------------------------;
.code
;---------------------------------------------------------------;
;	main PROC will be called once the program is run, this		;
;	is where we can call other processes so that we aren't		;
;	crowded into the main function like this (GROSS), so we		;
;	will implement this into further projects.					;
;---------------------------------------------------------------;
main	PROC
		call	Randomize						; set the time seed for the randomize functions in order to keep the generator psuedo-random

	;-----------Display Program Intro-----------;
		push	OFFSET	project					; +44
		push	OFFSET	intro_1					; +40
		push	OFFSET	intro_2					; +36
		push	OFFSET	intro_3					; +32
		push	OFFSET	intro_4					; +28
		push	OFFSET	intro_5					; +24
		push	OFFSET	EC_intro_1				; +20
		push	OFFSET	EC_intro_2				; +16
		push	OFFSET	EC_intro_3				; +12
		push	OFFSET	EC_intro_4				; +8
		call	intro

	;----------Get User Data (Inputs)-----------;
		push	OFFSET	prompt_1				; +20
		push	OFFSET	failed_input_1			; +16
		push	OFFSET	failed_input_2			; +12
		push	generationCount					; +8
		call	getData

	;-----------Fill The User Array-------------;
		push	OFFSET	arrayHold				; +12
		push	generationCount					; +8
		call	fillArray

	;-------Print The Array To The Screen-------;
		push	OFFSET	arrayHold				; +20
		push	generationCount					; +16
		push	OFFSET	space					; +12
		push	OFFSET	outro_1					; +8
		call	printArray

	;-----------Sort The User Array-------------;
		push	OFFSET	arrayHold				; +12
		push	generationCount					; +8
		call	sortArray

	;-----------Calculate The Median------------;
		push	OFFSET	arrayHold				; +16
		push	generationCount					; +12
		push	OFFSET	outro_2					; +8
		call	getMedian

	;-------Print The Array To The Screen-------;
		push	OFFSET	arrayHold				; +20
		push	generationCount					; +16
		push	OFFSET	space					; +12
		push	OFFSET	outro_3					; +8
		call	printArray

	;------------End Of The Program-------------;
		push	OFFSET	finished				; +8
		call	restart
	exit										; close program, return to OS
main	ENDP									; the main PROC is finished, this symbolyses that we are done with the proc

;---------------------------------------------------------------;
;	The intro procedure will be called right off the bat, sort	;
;	of like before using procedures. This will allow to keep	;
;	the main function clean and organized, making debugging		;
;	easier! This function litterally just calls all intro		;
;	scripts.													;
;	Parameters: program, intro_1, intro_2, intro_3, intro_4,	;
;	intro_5, EC_intro_1, EC_intro_2, EC_intro_3, EC_intro_4		;
;	Returns: 40 bytes from the stack							;
;	Pre-Conditions: none										;
;---------------------------------------------------------------;
intro	PROC
	mov		eax, lightGray + (blue * 16)		; color varaibles consist of: black, white, brown, yellow, blue, green, cyan, red, magenta, gray, lightBlue, lightGreen, lightCyan, lightRed, lightMagenta, and lightGray.
	call	setTextColor						; EXTRA CREDIT: change background and foreground colors

	push	ebp									; push all the general purpose regs to stack
	mov		ebp, esp							; save the stack into ebp to not alter data

	mov		edx, [ebp + 44]						; program
	call	WriteString
	call	CrLf
	mov		edx, [ebp + 40]						; intro_1
	call	WriteString
	call	CrLf
	mov		edx, [ebp + 36]						; intro_2
	call	WriteString
	call	CrLf
	mov		edx, [ebp + 32]						; intro_3
	call	WriteString
	call	CrLf
	mov		edx, [ebp + 28]						; intro_4
	call	WriteString
	call	CrLf
	mov		edx, [ebp + 24]						; intro_5
	call	WriteString
	call	CrLf
	
	mov		edx, [ebp + 20]						; EC_intro_1
	call	WriteString
	call	CrLf
	mov		edx, [ebp + 16]						; EC_intro_2
	call	WriteString
	call	CrLf
	mov		edx, [ebp + 12]						; EC_intro_3
	call	WriteString
	call	CrLf
	mov		edx, [ebp + 8]						; EC_intro_4
	call	WriteString
	call	CrLf

	pop		ebp

	ret		40									; clean the stack 40 bytes up
intro	ENDP

;---------------------------------------------------------------;
;	The Lower/Higher Inputs labels will be jumped to when the 	;
;	user inputs a faulty negative integer, because it was above ;
;	the first given integer. This will warn the user to input 	;
;	a proper lower int, then ask for a new int, and check if	;
;	the new int is above num1. If successful, will jump the		;
;	user to the calculations label.								;
;	Parameters: prompt_1, failed_input_1, failed_input_2		;
;	Returns: user inputed generationCount						;
;	Pre-Condition: none											;
;---------------------------------------------------------------;
getData	PROC
	push	ebp
	mov		ebp, esp
	mov		ebx, [ebp + 8]

	StartInp:
		mov		edx, [ebp + 20]					; prompt_1
		call	WriteString
		mov		eax, 0
		call	ReadInt
		cmp		eax, MAXNUM
		jg		HigherInput
		cmp		eax, MINNUM
		jl		LowerInput
		;mov	[ebp - 4], eax
		mov		generationCount, eax
		pop		ebp
		ret		12								; clean the stack 12 bytes up

	; Input entered was too low
	LowerInput:
		mov		edx, [ebp + 12]					; failed_input_2
		call	WriteString
		call	CrLf
		jmp		StartInp

	; Input entered was too high
	HigherInput:
		mov		edx, [ebp + 16]					; failed_input_1
		call	WriteString
		call	CrLf
		jmp		StartInp
getData	ENDP

;---------------------------------------------------------------;
;	The generate procedure will be the initial procedure to		;
;	call and generate the initial list of numbers. It will		;
;	recursively call the RandomRange function to generate the	;
;	array of numbers.											;
;	Parameters: arrayHold, generationCount						;
;	Returns: none												;
;	Pre-Conditions: generationCount needs to be within the range;
;		that the array can hold (no more than 200)				;
;---------------------------------------------------------------;
fillArray	PROC
	push	ebp
	mov		ebp, esp

	mov		edi, [ebp + 12]
	mov		ecx, [ebp + 8]						; loop count

	generateNew:
		mov		eax, HIGHEST
		sub		eax, LOWEST

		call	RandomRange
		add		eax, LOWEST
		mov		[edi], eax

		; WRITE TO FILE EC
		;mov		ebx, ecx						; perserve ecx value since stupid writefile procedure uses the register
		;lea		edx, filename
		;call	CreateOutputFile
		;mov		outputfile, esi
		;
		;lea		edx, eax
		;mov		eax, outputfile
		;mov		ecx, 10
		;call	WriteToFile
		

		;mov		ecx, ebx
		add		edi, 4
		
		loop	generateNew

	pop		ebp
	ret		8
fillArray	ENDP

;---------------------------------------------------------------;
;	The propSpacing procedure will be called when spacing out	;
;	the numbers to align them properly. This is so we can		;
;	do so without running out of room in the previous procedure	;
;	Parameters: none											;
;	Returns: none												;
;	Pre-Conditions: none										;
;---------------------------------------------------------------;
propSpacing PROC
	
		ret
propSpacing	ENDP

;---------------------------------------------------------------;
;	The sortArray procedure will recursively sort the array of	;
;	generated numbers from greatest to smallest using the		;
;	(SORT METHOD HERE) sorting method.							;
;	Parameters: arrayHold, generationCount, index				;
;	Returns: the array sorted from greatest to lowest			;
;	Pre-Conditions: a populated array with integer elements,	;
;		and generationCount being a real number withing the		;
;		provided range.											;
;---------------------------------------------------------------;
recursiveSort	PROC
	push	ebp
	mov		ebp, esp

	;void quickSort(int arr[], int low, int high) {
	;	if (low < high) {
	;		int pi = partition(arr, low, high);
	;		quickSort(arr, low, pi - 1);
	;		quickSort(arr, pi + 1, high);
	;	}
	;}

	mov		eax, [ebp + 8]						; low
	mov		ebx, [ebp + 12]						; high
	cmp		eax, ebx
	jl		InsideLoop

	InsideLoop:
		pushad								; push register values onto stack to save them
		mov		esi, [ebp + 12]				; reference array to esi
		mov		ecx, 4						; 4 bytes per space
		mul		ecx							; multiply eax by 4
		add		esi, eax					; add value to array
		push	esi							; 
		mov		eax, ebx
		mul		ecx
		add		edi, eax
		push	edi
		call	sortPartition				; swap the elements on the list
		popad


	pop		ebp
	ret		8
recursiveSort	ENDP

;---------------------------------------------------------------;
;	The sortArray procedure will recursively sort the array of	;
;	generated numbers from greatest to smallest using the		;
;	(SORT METHOD HERE) sorting method.							;
;	Parameters: arrayHold, generationCount						;
;	Returns: the array sorted from greatest to lowest			;
;	Pre-Conditions: a populated array with integer elements,	;
;		and generationCount being a real number withing the		;
;		provided range.											;
;---------------------------------------------------------------;
sortArray	PROC
	push	ebp
	mov		ebp, esp
	mov		ecx, 0								; start loop at 0
	mov		edi, [ebp + 12]						; array referenced to edi

	
	;for (k = 0; k < request - 1; k++) {
	;	i = k;
	;	for (j = k + 1; j < request; j++) {
	;		if (array[j] > array[i])
	;			i = j;
	;		}
	;		exchange(array[k], array[i]);
	;	}
	;}

	SortStart:
		mov		eax, ecx
		mov		ebx, ecx

		InnerLoop:
			inc		ebx							; j = k + 1
			cmp		ebx, [ebp + 8]				; compare how many elements have been sorted to number of elements
			je		OuterLoop

			mov		edx, [edi + ebx * 4]		; array[j] > array[i]
			cmp		edx, [edi + eax * 4]		; compare method
			jl		innerLoop

			pushad								; push register values onto stack to save them
			mov		esi, [ebp + 12]				; reference array to esi
			mov		ecx, 4						; 4 bytes per space
			mul		ecx							; multiply eax by 4
			add		esi, eax					; add value to array
			push	esi							; 
			mov		eax, ebx
			mul		ecx
			add		edi, eax
			push	edi
			call	sortPartition				; swap the elements on the list
			popad
			jmp		innerLoop					; jump to next iteration of loop

		OuterLoop:
			inc		ecx
			cmp		ecx, [ebp + 8]
			je		SortEnd						; returns if all elements have been sorted
			jmp		SortStart

	SortEnd:
		pop		ebp
		ret		8
sortArray	ENDP

sortPartition PROC
	push	ebp
	mov		ebp, esp

	mov		eax, [ebp + 8]						; the lowest index
	mov		ecx, [eax]							; set the value to ecx
	mov		ebx, [ebp + 12]						; the highest index
	mov		edx, [ebx]							; set the value to edx
	mov		[eax], edx							; swap a to b
	mov		[ebx], ecx							; swap b to a

	pop		ebp
	ret		8
sortPartition ENDP



;---------------------------------------------------------------;
;	The getMedian procedure will calculate the median from the	;
;	array and print it to the screen.							;
;	Parameters: arrayHold, outro_2, generationCount				;
;	Returns: none												;
;	Pre-Conditions: array populated with sorted integers,		;
;		generationCount being a real number within it's range	;
;---------------------------------------------------------------;
getMedian	PROC
	push	ebp
	mov		ebp, esp
	mov		edi, [ebp + 16]						; array list
	
	call	CrLf
	mov		edx, [ebp + 8]						; outro_2
	call	WriteString
	
	mov		eax, [ebp + 12]						; generationCount
	cdq
	mov		ebx, 2								; we need to divide by 2 to see if theres an even middle
	div		ebx									; divide by 2
	cmp		edx, 0								; if remainder is 0, then its an even number of elements in the array
	je		EvenCount
	jne		OddCount

	EvenCount:
		dec		eax								; we want the sum of the two middle numbers to get the middle of them
		mov		ebx, [edi + eax * 4]
		inc		eax								; get the next of after the first middle
		mov		ecx, [edi + eax * 4]
		mov		eax, ebx						; move the first value to eax
		add		eax, ecx						; add the second value to eax for the sum
		mov		ebx, 2							; prep to div by 2
		div		ebx								; divide by 2 to get the middle number
		call	WriteDec						; display the median of an even number of elements
		call	CrLf
		pop		ebp
		ret		12

	OddCount:
		mov		ebx, [edi + eax * 4]
		mov		eax, ebx
		call	WriteDec
		call	CrLf
		pop		ebp
		ret		12
getMedian	ENDP

;---------------------------------------------------------------;
;	The printArray will look through the array and print it to	;
;	the screen, this saves space in the calculation procedure.	;
;	Parameters: outro_1 or outro_3, arrayHold, generationCount	;
;		space.													;
;	Returns: none												;
;	Pre-Conditions: array populated with integers,				;
;		generationCount being a real integer within range		;
;---------------------------------------------------------------;
printArray	PROC
	push	ebp
	mov		ebp, esp
	mov		edx, [ebp + 8]						; outro_1 / outro_3
	mov		ecx, [ebp + 16]						; loop count
	mov		esi, [ebp + 20]						; array
	mov		ebx, 0								; line count
	
	call	CrLf
	call	WriteString
	call	CrLf

	printing:
		mov		eax, [esi]						; move the address of the array position
		call	WriteDec						; write the current number to the screen
		add		esi, 4							; move the array location by 4 bytes (next number)

		mov		edx, [ebp + 12]					; spacer
		call	WriteString

		inc		ebx								; move the line counter up by 1
		cmp		ebx, 10
		je		newLine
		jne		continue

		newLine:
			mov		ebx, 0
			call	CrLf

		continue:
			loop	printing						; keep looping the print until the loop (ecx counter) is done

	call	CrLf
	pop		ebp
	ret		20
printArray	ENDP

;---------------------------------------------------------------;
;	The restart procedure will test to see if the user is		;
;	wanting to run the process one more time, which is 1		;
;	is inputed, will jump the user back into the				;
;	introduction where the user will be asked to input more		;
;	integers. If anything else is answered, the program will	;
;	exit to the OS.												;
;	Parameters: finished										;
;	Returns: none												;
;	Pre-Conditions: none										;
;---------------------------------------------------------------;
restart		PROC
	push	ebp
	mov		ebp, esp
	
	call	CrLf
	mov		edx, [ebp + 8]						; finished
	call	WriteString

	pop		ebp
	ret		4
restart		ENDP

END main										; the symbolyses that the main program is finished