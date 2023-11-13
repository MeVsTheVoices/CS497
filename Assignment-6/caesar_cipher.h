#ifndef CAESAR_CIPHER_H
#define CAESAR_CIPHER_H

#include <string.h>
char caesar_cipher_character(char c, int shift, int reverse);
void caesar_cipher_file(char* fileName, int shift, int reverse, int numberLines);
#endif