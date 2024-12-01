section .bss
    out: resb 2048
    input: resb 2048
    a1: resb 2048
    a2: resb 2048
    result_str: resb 10

section .data
    input_filename: db "data/day1a.txt", 0
    input_filename_len: equ $-input_filename
    fmt db "%s", 0

    out_len: dd 0
    input_len: dd 2048
    a1_len: dd 0
    a2_len: dd 0
    sort_arr_len: dd 0
    sort_arr: dd 0
    result_str_len: dd 10

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
        mov esi, [j]
        mov [a1 + 4 * esi], eax

        ; skip spaces
        add dword [i], 3

        call parse_num
        mov esi, [j]
        mov [a2 + 4 * esi], eax

        inc dword [i]
        inc dword [j]
        jmp loop

    loop_out:

    mov eax, [j]
    mov dword [a1_len], eax
    mov dword [a2_len], eax
    mov dword [sort_arr_len], eax

    ; in place sort a1
    lea eax, a1
    mov [sort_arr], eax
    call sort

    ; in place sort a2
    lea eax, a2
    mov [sort_arr], eax
    call sort

    ; iterate pairs calculating sum of their difference
    mov [result], dword 0
    mov [i], dword 0
    sum_loop:
        mov eax, [i]
        cmp eax, [sort_arr_len]
        jge print_res

        mov ebx, [a1 + 4 * eax]
        mov [n], ebx
        mov ebx, [a2 + 4 * eax]
        mov [n2], ebx

        mov eax, [n]
        mov ebx, [n2]
        call abs_diff
        add [result], eax

        inc dword [i]
        jmp sum_loop

    print_res:
        mov ecx, 0
        mov edx, [result]
        call print

    call exit

; read buf[i] until byte is not in digits range (0x30 - 0x39), incrementing i
; store resulting u32 to eax
parse_num:
    mov dword [parsed_n], 0

    parse_num_loop:
        mov esi, input
        add esi, [i]
        mov al, [esi]
        mov [e], al

        cmp byte [e], 0x30
        jl parse_num_done
        cmp byte [e], 0x39
        jg parse_num_done

        sub byte [e], 0x30

        mov eax, [parsed_n]
        imul eax, 10
        add eax, [e]
        mov dword [parsed_n], eax

        inc dword [i]
        jmp parse_num_loop

    parse_num_done:
        mov eax, [parsed_n]

    ret

; in place sort array sort_arr
sort:
    mov eax, [sort_arr_len]
    mov dword [i], eax

    sort_outer_loop:
        cmp [i], dword 0
        jz sort_done

        ; for each element
        mov [j], dword 0
        sort_inner_loop:
            mov eax, [sort_arr_len]
            dec eax
            cmp dword [j], eax
            jge sort_inner_done

            mov esi, [j]
            imul esi, 4
            add esi, [sort_arr]

            mov eax, [esi]
            mov ebx, [esi + 4]

            cmp eax, ebx
            jle sort_no_swap

            sort_swap:
                mov dword [esi], ebx
                mov dword [esi + 4], eax
            sort_no_swap:

            inc dword [j]
            jmp sort_inner_loop

        sort_inner_done:
        dec dword [i]
        jmp sort_outer_loop
        
    sort_done:
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


abs_diff:
    sub eax, ebx
    js negate_result
    ret

    negate_result:
        neg eax
        ret
