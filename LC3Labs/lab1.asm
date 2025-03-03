.ORIG x3000
    LD R0, x00FF
    LD R1, x00FF
    ADD R2, R0, R1
    AND R3, R0, R1
    NOT R4, R0
    NOT R5, R1
    AND R6, R4, R5
    NOT R6, R6
    AND R7, R0, x0001

    ST R2, x00F8
    ST R3, x00F8
    ST R6, x00F8
    ST R4, x00F8
    ST R5, x00F8
    ST R7, x00FA

    ADD R6, R0, #3
    ADD R7, R1, #-3

    ST R6, x00F5
    ST R7, x00F5
    
    HALT
.END
