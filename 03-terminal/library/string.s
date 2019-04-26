.include "include/registers.s"

.global string_compare
.global string_compare_space
.global string_copy

string_compare:
    ld r17, Y+ ; 1 string do porównania
    lpm r18, Z+ ;w pamięci programu, 2 do porównania
    cp r17, r18 
    brne string_compare_failed
    cpi r17, 0
    brne string_compare
    ldi r16, 1
    ret
string_compare_failed:
    ldi r16, 0
    ret

string_copy: ; z ram do ram 
    ld r16, Y+
    st Z+, r16
    cpi r16, 0
    brne string_copy
    ret
string_compare_space:
    ld r17, Y+ ; 1 string do porównania
    lpm r18, Z+ ;w pamięci programu, 2 do porównania
    cp r17, r18 
    brne string_compare_space_failed
    cpi r17, 32
    brne string_compare_space
    ldi r16, 1
    ret
string_compare_space_failed:
    ldi r16, 0
    ret
