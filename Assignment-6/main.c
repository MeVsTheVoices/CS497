#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <ctype.h>

#include "caesar_cipher.h"

int parseParameters(int argc, char** argv,
                    int* shift, int* reverse, 
                    int* numberAllOutputLines, char* inputFile) {
    int c;
    char* shiftAsAString = NULL;
    extern char* optarg;
    extern int optind, opterr, optopt;
    
    while ((c = getopt(argc, argv, "s:rn")) != -1) {
        switch(c) {
            case 's':
                shiftAsAString = optarg;
                break;
            case 'r':
                *reverse = 1;
                break;
            case 'n':
                *numberAllOutputLines = 1;
                break;
            case ':':
                printf("Option -%c requires an operand\n", optopt);
                return 1;
            case '?':
                printf("Unrecognized option: -%c\n", optopt);
                return 1;
        }
    }
    if (optind == argc - 1)
        strcpy(inputFile, argv[optind]);
    else {
        printf("No input file specified\n");
        return 1;
    }
    *shift = atoi(shiftAsAString);
    return 0;
}

int main(int argc, char** argv) {
    int shift;
    int reverse = 0;
    int numberAllOutputLines = 0;
    char inputFile[50];
    int parseResult = parseParameters(argc, argv, 
                                      &shift, &reverse, 
                                      &numberAllOutputLines, 
                                      inputFile);
    if (parseResult != 0) {
        printf("Usage: %s [-s shift] [-r] [-n] file\n", argv[0]);
        return parseResult;
    }
    caesar_cipher_file(inputFile, shift, reverse, numberAllOutputLines);
    return 0;
}