#include "caesar_cipher.h"

#include <fcntl.h>
#include <stdio.h>
#include <unistd.h>

char caesar_cipher_character(char c, int shift, int reverse) {
    if (shift > 26)
        shift %= 26;
    
    if (reverse) {
        shift = 26 - shift;
    }
    
    if (c >= 'A' && c <= 'Z') {
        if ((c + shift) > 'Z')
            c = c + shift - 26;
        else if ((c + shift) < 'A')
            c = c + shift + 26;
        else
            c += shift;
    } else if (c >= 'a' && c <= 'z') {
        if ((c + shift) > 'z')
            c = c + shift - 26;
        else if ((c + shift) < 'a')
            c = c + shift + 26;
        else 
            c += shift;
    }
    return c;
}

void caesar_cipher_file(char* fileName, int shift, int reverse, int numberLines) {
    const int BUFFER_SIZE = 1024;
    int fileDescriptor = open(fileName, O_RDONLY);
    int currentLine = 1;
    int charactersToRead = 0;
    int endLine;
    int currentChar;
    char buf[BUFFER_SIZE];
    fileDescriptor = open(fileName, O_RDONLY);
    if (fileDescriptor == -1) {
        perror("Error opening file");
        return;
    }
    if (numberLines)
        printf("%d ", currentLine);
    while ((charactersToRead = read(fileDescriptor, buf, BUFFER_SIZE)) > 0) {
        for (int i = 0; i < charactersToRead; i++) {
            currentChar = buf[i];
            if (currentChar == '\n') {
                currentLine++;
                if (numberLines)
                    printf("\n%d ", currentLine);
            }
            else if (currentChar == EOF) {
                printf("\n");
                close(fileDescriptor);
                return;
            }
            else {
                char c = caesar_cipher_character(currentChar, shift, reverse);
                printf("%c", c);
            }
        }
    }
    close(fileDescriptor);
    printf("\n");
}


