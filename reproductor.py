from os import system, name
from playsound import playsound

# define our clear function
def clear():
  
    # for windows
    if name == 'nt':
        _ = system('cls')
  
    # for mac and linux(here, os.name is 'posix')
    else:
        _ = system('clear')

clear()
# Audio 1
print('######### Audio 1 ##########\n')
print('a - Reproduciendo audio de entrada sin reververacion\n')
playsound('input1.wav')
print('b - Reproduciendo audio de salida con reververacion\n')
playsound('output1.wav')

# Audio 2
print('######### Audio 2 ##########\n')
print('a - Reproduciendo audio de entrada con reververacion\n')
playsound('input2.wav')
print('b - Reproduciendo audio de entrada sin reververacion\n')
playsound('output2.wav')

# Fin
print('######### FIN ##########')