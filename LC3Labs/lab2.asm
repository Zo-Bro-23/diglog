.ORIG   x3100
        LD R0, x001F
        LD R4, x001E
        BRzp SKIP1
        NOT R4, R0
        ADD R4, R4, #1

SKIP1   LD R1, x001B
        LD R5, x001A
        BRzp SKIP2
        NOT R5, R1
        ADD R5, R5, #1
        
SKIP2   NOT R3, R1
        ADD R3, R3, #1
        ADD R3, R3, R0
        ST R3, x0014
        ST R4, x0014
        ST R5, x0014

        AND R2, R2, x0000
        NOT R6, R5
        ADD R6, R6, #1
        ADD R6, R6, R4
        BRp POS
        BRz ZER
        BRn NEG

NEG     ADD R2, R2, #1
POS     ADD R2, R2, #1
ZER     ST R2, x000B

        HALT
.END
