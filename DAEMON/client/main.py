import json
import pymssql  
from pymongo import MongoClient
from pprint import pprint
import pandas as pd

client = MongoClient('mongodb+srv://db2_p2:8XdKTBUCq4vi3ODF@cluster0.dfzgh5g.mongodb.net/?retryWrites=true&w=majority')

db = client['db2_mongodb']
collection = db.quickaccess

conn = pymssql.connect(server='34.67.166.0', 
    user='SA', 
    password='BD2Proyecto2.', 
    database='NETFLIX',
    autocommit=True)

cursor = conn.cursor()

def get_titleMongo():
    title = input("Ingrese el título que desea buscar > ")
    if collection.count_documents({"primaryTitle":title}) != 0:
        result = collection.find({"primaryTitle":title})
        for x in result:
            pprint(x)
            print("\n")
    else: print("No se ha encontrado ningún título con el criterio ingresado.")
    menu()

def get_titleByRatingMongo():
    rating = input("Ingrese el rating que desea que posea los títulos > ")
    result = collection.find()
    for x in result:
        x1 = json.dumps(x)
        xjson = json.loads(x1)
        ratings = json.loads(json.dumps(xjson["rating"]))
        if (ratings["averageRating"]==float(rating)):
            pprint(x)
            print("\n")
    menu()

def all_titles():
    cursor.execute('SELECT id FROM title;')
    titles = []
    row = cursor.fetchone()
    while row:
        titles.append(str(row[0]))
        row = cursor.fetchone()

    return titles

def cast_table(id_title):
    cursor.execute("SELECT p.name FROM crew c INNER JOIN person p ON c.personId = p.id INNER JOIN role r ON c.roleId = r.id WHERE c.titleId = '" + str(id_title) + "' AND (r.name = 'actress' OR r.name = 'actor');")
    cast = []
    row = cursor.fetchone()
    while row:
        cast.append(str(row[0]))
        row = cursor.fetchone()
    return cast

def detailed_title(id_title):
    cursor.execute("SELECT t.id, t.primaryTitle, t.isAdult, t.startYear, t.endYear, t.runtime, t.[description], tp.name FROM title t INNER JOIN titletype tp ON t.titleTypeId = tp.id WHERE t.id = '" + str(id_title) + "';")
    return cursor.fetchone()

def get_genres(id_title):
    cursor.execute("SELECT g.name FROM title_genre tg INNER JOIN genre g ON tg.genreId = g.id WHERE tg.titleId = '" + str(id_title) + "';")
    genres = []
    row = cursor.fetchone()
    while row:
        genres.append(str(row[0]))
        row = cursor.fetchone()
    return genres

def get_creator(id_title, role):
    cursor.execute("SELECT p.name FROM crew c INNER JOIN person p ON c.personId = p.id INNER JOIN role r ON c.roleId = r.id WHERE c.titleId = '" + id_title + "' AND r.name = '" + role + "';")
    return cursor.fetchone()[0]

def get_rating(id_title):
    cursor.execute("SELECT r.averageRating, r.numVotes FROM [35.193.226.141].IMDB.dbo.rating r WHERE r.titleId = '" + id_title + "';")
    row = cursor.fetchone()
    return [float(row[0]), int(row[1])]

def new_title():
    title = input (":: Ingrese el título de la película > ")
    year = input (":: Ingrese el año de lanzamiento (por defecto 0) > ")
    if(int(year) > 0):
         year=year 
    else:
        year="0"
    print('\n')
    cursor.execute('SELECT * FROM titletype;')

    row = cursor.fetchone()  
    while row:  
        print ("\t\t" + str(row[0]) + ". " + str(row[1]))     
        row = cursor.fetchone()  
    
    cod_type = input("\n:: Ingrese el tipo del título > ")
    desc = input(":: Ingrese una breve descripción > ")
    res = None
    cursor.callproc('insert_title', ( str(title), str(year), str(cod_type), str(desc),res))
    print("EL RESULTADO ES > ")
    input("\nEl título " + str(title) + " ha sido añadido.")
    eleccion = input("\n\n-> ¿Desea registrar un nuevo título? [s/n] > ")
    
    if eleccion == 'S' or eleccion == 's':
        new_title()
    else: menu()

def menu():
    print("\t1. Añadir un nuevo título")
    print("\t2. Buscar por título")
    print("\t3. Buscar por título por rating")
    print("\t4. Acerca de")
    print("\t5. Salir")
    option = input("\n-> ¿Qué deseas realizar? > ")

    if int(option) == 1:
        eleccion = input ("¿Deseas agregar un nuevo título? [s/n] > ")
        if eleccion == 'S' or eleccion == 's':
            new_title()
        else: menu()
    elif int(option) == 2: get_titleMongo()
    elif int(option) == 3: get_titleByRatingMongo()
    elif int(option) == 4: about()
    elif int(option) == 5: exit()
    else: menu()

def inicio():
    print("\n\n -------------------- PROYECTO NO. 2 --------------------")

    menu()

def about():
    print("|-------------------------------------------------------------|")
    print("|Nombre                           | Carné                     |")
    print("|-------------------------------------------------------------|")
    print("|Jorge David Espina Molina        | 201403632                 |")
    print("|Josué David Zea Herrera          | 201807159                 |")
    print("|Kenni Roberto Martínez Marroquin | 201800457                 |")
    print("|-------------------------------------------------------------|\n\n")

    menu()

def exit():    
    print("Saliendo del cliente.")

if __name__=='__main__':
    inicio()