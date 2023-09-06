# mi_script.py
import sys

def funcion_a():
    return "Hola desde función A"

def funcion_b():
    return "Hola desde función B"

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Uso: python mi_script.py nombre_de_la_funcion")
        sys.exit(1)

    funcion_name = sys.argv[1]
    
    if funcion_name == 'funcion_a':
        resultado = funcion_a()
    elif funcion_name == 'funcion_b':
        resultado = funcion_b()
    else:
        print(f"La función '{funcion_name}' no existe.")
        resultado = None

    if resultado is not None:
        print(resultado)