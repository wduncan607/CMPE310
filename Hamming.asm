section .data
    word1 db 'foo'
    word2 db 'bar'

section .bss
    distance resb 2

section .text
global _start

_start:
    mov esi, word1
    mov edi, word2
    mov ecx, 3
    xor ebx, ebx
wordLoop:
    mov al, [esi]
    xor al, [edi]
bitCounterPrep:
    xor edx, edx
    mov ebp, 8
bitCountLoop:
    test al, 1
    je nullBit
    add edx, 1
nullBit:
    shr al, 1
    dec ebp
    jne bitCountLoop
    add ebx, edx
    add esi, 1
    add edi, 1
    loop wordLoop
outputPrep:
    mov al, bl
    add al, '0'
    mov [distance], al
    mov [distance+1], byte 10

        ;; print
    mov eax, 4
    mov ebx, 1
    mov ecx, distance
    mov edx, 2
        int 0x80

        ;; exit
    mov eax, 1
    xor ebx, ebx
    int 0x80
