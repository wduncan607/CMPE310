section .data
    file db "randomInt100.txt", 0
    nl db 10, 0
    msg db "Sum: ", 0

section .bss
    buf resb 1000
    total resd 1
    num resd 1
    str1 resb 12

section .text
    global _start

_start:
    ; Open file
    mov eax, 5
    mov ebx, file
    mov ecx, 0
    int 0x80

    mov ebx, eax

    ; Read file into buffer
    mov eax, 3
    mov ecx, buf
    mov edx, 1000
    int 0x80

    mov edx, eax

    ; Init sum and num
    mov dword [total], 0
    mov dword [num], 0
    mov esi, buf

loop:
    mov al, [esi]
    cmp al, 0
    je finish
    cmp al, '0'
    jl delim
    cmp al, '9'
    jg delim

    sub al, '0'
    movzx eax, al
    mov ebx, [num]
    imul ebx, ebx, 10
    add ebx, eax
    mov [num], ebx

    jmp next

delim:
    mov eax, [num]
    add [total], eax
    mov dword [num], 0

next:
    inc esi
    jmp loop

finish:
    mov eax, [num]
    add [total], eax

    mov eax, [total]
    mov edi, str1
    call to_str

    mov eax, 4
    mov ebx, 1
    mov ecx, msg
    mov edx, 5
    int 0x80
    
    mov eax, 4
    mov ebx, 1
    mov ecx, str1
    mov edx, 12
    int 0x80
    
    mov eax, 4
    mov ebx, 1
    mov ecx, nl
    mov edx, 1
    int 0x80
    
    mov eax, 1
    mov ebx, 0
    int 0x80

to_str:
    mov ecx, 10
    mov ebx, 0
    mov edi, str1 + 11
    mov byte [edi], 0
    sub edi, 1

conv:
    mov edx, 0
    div ecx
    add dl, '0'
    mov [edi], dl
    dec edi
    inc ebx
    test eax, eax
    jnz conv

    inc edi
    ret
