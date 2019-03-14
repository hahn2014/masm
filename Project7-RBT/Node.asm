; Author: Bryce Hahn
; Project ID: Project 7
; Date: 3/14/2019
; Description:
;	Red Black Tree Node class.

INCLUDE Irvine32.inc

.data
node			STRUCT
	val				DWORD		?	; anything from 1 to 1000	Starts = undefined
	COLOR			BYTE		?	; 1 for red, 0 for black	Starts = undefined
;	parent			node		<>	; parent pointer			Starts = NULL
;	leftChild		node		<>	; left child pointer		Starts = NULL
;	rightChild		node		<>	; right child pointer		Starts = NULL
node			ENDS

.code
;---------------------------------------------------------------;
;	The getLeftChild procedure
;																;
;	Parameters:		
;	Returns:		
;	Pre-Conditions:	
;	Changed Regs:	
;---------------------------------------------------------------;
getLeftChild	PROC
	
	ret
getLeftChild	ENDP

;---------------------------------------------------------------;
;	The setLeftChild procedure
;																;
;	Parameters:		
;	Returns:		
;	Pre-Conditions:	
;	Changed Regs:	
;---------------------------------------------------------------;
setLeftChild	PROC
	
	ret
setLeftChild	ENDP

;---------------------------------------------------------------;
;	The getRightChild procedure
;																;
;	Parameters:		
;	Returns:		
;	Pre-Conditions:	
;	Changed Regs:	
;---------------------------------------------------------------;
getRightChild	PROC
	
	ret
getRightChild	ENDP

;---------------------------------------------------------------;
;	The setRightChild procedure
;																;
;	Parameters:		
;	Returns:		
;	Pre-Conditions:	
;	Changed Regs:	
;---------------------------------------------------------------;
setRightChild	PROC

	ret
setRightChild	ENDP

;---------------------------------------------------------------;
;	The getParent procedure
;																;
;	Parameters:		
;	Returns:		
;	Pre-Conditions:	
;	Changed Regs:	
;---------------------------------------------------------------;
getParent		PROC
	
	ret
getParent		ENDP

;---------------------------------------------------------------;
;	The setParent procedure
;																;
;	Parameters:		
;	Returns:		
;	Pre-Conditions:	
;	Changed Regs:	
;---------------------------------------------------------------;
setParent		PROC
	
	ret
setParent		ENDP

;---------------------------------------------------------------;
;	The getVal procedure
;																;
;	Parameters:		
;	Returns:		
;	Pre-Conditions:	
;	Changed Regs:	
;---------------------------------------------------------------;
getVal			PROC
	
	ret
getVal			ENDP

;---------------------------------------------------------------;
;	The setVal procedure
;																;
;	Parameters:		
;	Returns:		
;	Pre-Conditions:	
;	Changed Regs:	
;---------------------------------------------------------------;
setVal			PROC
	
	ret
setVal			ENDP

;---------------------------------------------------------------;
;	The getColor procedure
;																;
;	Parameters:		
;	Returns:		
;	Pre-Conditions:	
;	Changed Regs:	
;---------------------------------------------------------------;
getColor		PROC
	
	ret
getColor		ENDP

;---------------------------------------------------------------;
;	The setColor procedure
;																;
;	Parameters:		
;	Returns:		
;	Pre-Conditions:	
;	Changed Regs:	
;---------------------------------------------------------------;
setColor		PROC
	
	ret
setColor		ENDP

END