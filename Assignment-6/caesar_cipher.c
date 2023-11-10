#include "caesar_cipher.h"

void caesar_cipher_charater(char &c, int shift) {
    if (shift > 26)
        shift %= 26;
    
    if (c >= 'A' && c <= 'Z') {
        if ((c + shift) > 'Z')
            c = c + shift - 26;
        else
            c += shift
    } else if (c >= 'a' && c <= 'z') {
        if ((c + shift) > 'Z')
            c = c + shift -26;
        else 
            c += shift
    }
}
void caesar_cipher_string(std::string &str, int shift) {

}