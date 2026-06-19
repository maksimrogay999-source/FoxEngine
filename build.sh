cython edit.pyx --embed -o edit.c
gcc edit.c -I/usr/include/python3.14 -I/usr/include/python3.14  -fno-strict-overflow -Wsign-compare  -DNDEBUG -g -O3 -Wall -L/usr/lib/python3.14/config-3.14-x86_64-linux-gnu -L/usr/lib/x86_64-linux-gnu  -ldl  -lm -lpython3.14 -o edit
chmod +x ./edit
