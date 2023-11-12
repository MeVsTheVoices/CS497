caesar_cipher: caesar_cipher.o
	gcc -c caesar_cipher.c -o caesar_cipher.o

caesar_cipher.o: caesar_cipher.c

main: main.o
	gcc -c main.c -o main.o

main.o: main.c

all: caesar_cipher main
	gcc caesar_cipher.o main.o -o main

clean:
	rm -f *.o *.exe *.out