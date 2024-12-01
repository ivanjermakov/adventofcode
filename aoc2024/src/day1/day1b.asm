section .bss
    a1: resb 4 * 1024
    a2: resb 4 * 1024
    input: resb 20 * 1024

section .data
    input_filename: db "data/day1.txt", 0
    input_filename_len: equ $-input_filename
    fmt db "%s", 0

    input_len: dd 24000
    a1_len: dd 0
    a2_len: dd 0

    i: dd 0
    j: dd 0
    k: dd 0
    parsed_n: dd 0
    e: db 0
    e2: db 0
    result: dd 0
    n: dd 0
    n2: dd 0

    exit_id: dd 1
    read_id: dd 3
    write_id: dd 4
    open_id: dd 5

section .text
    global _start

extern printf

_start:
    ; open file, eax is a fd
    mov eax, [open_id]
    mov ebx, input_filename
    mov ecx, 0
    mov edx, 0
    int 0x80

    ; read file bytes into input
    mov ebx, eax
    mov eax, [read_id]
    mov ecx, input
    mov edx, [input_len]
    int 0x80

    ; iterate each byte in input and assemble a1 and a2 with i32s
    mov dword [i], 0
    mov dword [j], 0

    loop:
        mov esi, input
        add esi, [i]
        mov al, [esi]
        mov [e], al

        cmp [e], byte 0
        je loop_out

        ; for each char
        call parse_num
        mov edi, [j]
        mov [a1 + 4 * edi], eax

        ; skip spaces
        add dword [i], 3

        call parse_num
        mov edi, [j]
        mov [a2 + 4 * edi], eax

        inc dword [i]
        inc dword [j]
        jmp loop

    loop_out:

    mov eax, [j]
    mov dword [a1_len], eax
    mov dword [a2_len], eax

    ; iterate pairs calculating sum of similarity score
    mov [result], dword 0
    mov [i], dword 0
    sum_loop:
        mov eax, [i]
        cmp eax, [a1_len]
        jge print_res

        mov ebx, [a1 + 4 * eax]
        mov [n], ebx
        call count
        imul eax, [n]
        add [result], eax
; mov ecx, 0
; mov edx, eax
; call print

        inc dword [i]
        jmp sum_loop

    print_res:
        mov ecx, result
        mov edx, 4
        call print

    call exit

; count occurrences of n in buf2
; store count in eax
count:
    mov [k], dword 0
    mov eax, [a1_len]
    dec eax
    mov [j], eax

    count_loop:
    cmp [j], dword 0
    js count_done

    mov ebx, [j]
    mov eax, [a2 + 4 * ebx]
    mov [n2], eax
    cmp eax, [n]
    jne count_neq

    count_eq:
        inc dword [k]
    count_neq:

    dec dword [j]
    jmp count_loop

    count_done:
    mov eax, [k]
    ret

; read buf[i] until byte is not in digits range (0x30 - 0x39), incrementing i
; store resulting u32 to eax
parse_num:
    mov dword [parsed_n], 0

    parse_num_loop:
        mov esi, input
        add esi, [i]
        mov al, [esi]
        mov [e], al

        cmp [e], byte 0x30
        jl parse_num_done
        cmp [e], byte 0x39
        jg parse_num_done

        sub [e], byte 0x30

        mov eax, [parsed_n]
        imul eax, 10
        add eax, [e]
        mov dword [parsed_n], eax

        inc dword [i]
        jmp parse_num_loop

    parse_num_done:
        mov eax, [parsed_n]

    ret

print:
    mov eax, [write_id]
    mov ebx, 1
    int 0x80
    ret

exit:
    mov eax, [exit_id]
    mov ebx, 0
    int 0x80
    ret

