nasm -felf64 -o reververacion.o reververacion.asm
ld -o reververacion reververacion.o

echo "Procesando archivos..."

./reververacion

python3 reproductor.py