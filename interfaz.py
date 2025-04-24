import mysql.connector
import os
from datetime import datetime, timedelta
import tkinter as tk
from tkinter import ttk, messagebox


# Database connection configuration
def conectar_db():
    try:
        return mysql.connector.connect(
            host="localhost",
            user=os.getenv("DB_USER", "root"),
            password=os.getenv("DB_PASS", "kg1784dg.1234"),
            port= "3306",
            database="MyCineMusic24"
        )
    except mysql.connector.Error as err:
        messagebox.showerror("Error", f"Error al conectar a la base de datos: {err}")
        return None


# Display data in Treeview
def actualizar_tabla(treeview, data, columns):
    treeview.delete(*treeview.get_children())  # Clear table
    treeview["columns"] = columns
    treeview["show"] = "headings"
    for col in columns:
        treeview.heading(col, text=col)
        treeview.column(col, anchor="center", width=150)
    for row in data:
        treeview.insert("", "end", values=row)


# Query 1: Search films by classification
def buscar_peliculas_por_clasificacion(treeview, clasificacion=None):
    conexion = conectar_db()
    if conexion:
        try:
            with conexion.cursor() as cursor:
                query = """
                SELECT f.title, f.release_date, f.duration, c.description AS classification
                FROM FILM f
                JOIN CLASSIFICATION c ON f.classification_id = c.classification_id
                """
                if clasificacion:
                    query += " WHERE c.description = %s"
                    cursor.execute(query, (clasificacion,))
                else:
                    cursor.execute(query)
                peliculas = cursor.fetchall()
                columns = [i[0] for i in cursor.description]
                actualizar_tabla(treeview, peliculas, columns)
        except mysql.connector.Error as err:
            messagebox.showerror("Error", f"Error al buscar películas por clasificación: {err}")
        finally:
            conexion.close()


# Query 2: View a director's filmography
def ver_filmografia_director(treeview, director=None):
    conexion = conectar_db()
    if conexion:
        try:
            with conexion.cursor() as cursor:
                query = """
                SELECT f.title, f.release_date
                FROM FILM f
                JOIN FILM_DIRECTOR fd ON f.film_id = fd.film_id
                JOIN DIRECTOR d ON fd.director_id = d.director_id
                """
                if director:
                    query += " WHERE d.name = %s"
                    cursor.execute(query, (director,))
                else:
                    cursor.execute(query)
                filmografia = cursor.fetchall()
                columns = [i[0] for i in cursor.description]
                actualizar_tabla(treeview, filmografia, columns)
        except mysql.connector.Error as err:
            messagebox.showerror("Error", f"Error al consultar la filmografía del director: {err}")
        finally:
            conexion.close()


# Query 3: Find films with a specific actor
def buscar_peliculas_por_actor(treeview, actor=None):
    conexion = conectar_db()
    if conexion:
        try:
            with conexion.cursor() as cursor:
                query = """
                SELECT f.title, f.release_date
                FROM FILM f
                JOIN FILM_ACTOR fa ON f.film_id = fa.film_id
                JOIN ACTOR a ON fa.actor_id = a.actor_id
                """
                if actor:
                    query += " WHERE a.name = %s"
                    cursor.execute(query, (actor,))
                else:
                    cursor.execute(query)
                peliculas = cursor.fetchall()
                columns = [i[0] for i in cursor.description]
                actualizar_tabla(treeview, peliculas, columns)
        except mysql.connector.Error as err:
            messagebox.showerror("Error", f"Error al buscar películas por actor: {err}")
        finally:
            conexion.close()


# Query 4: Search soundtracks by author
def buscar_soundtracks_por_autor(treeview, autor=None):
    conexion = conectar_db()
    if conexion:
        try:
            with conexion.cursor() as cursor:
                query = """
                SELECT s.title, s.duration, s.release_date
                FROM SOUNDTRACK s
                JOIN AUTHOR a ON s.author_id = a.author_id
                """
                if autor:
                    query += " WHERE a.name = %s"
                    cursor.execute(query, (autor,))
                else:
                    cursor.execute(query)
                soundtracks = cursor.fetchall()
                columns = [i[0] for i in cursor.description]
                actualizar_tabla(treeview, soundtracks, columns)
        except mysql.connector.Error as err:
            messagebox.showerror("Error", f"Error al buscar soundtracks por autor: {err}")
        finally:
            conexion.close()


# Query 5: List interpreters of a soundtrack
def listar_interpretes_soundtrack(treeview, titulo_soundtrack=None):
    conexion = conectar_db()
    if conexion:
        try:
            with conexion.cursor() as cursor:
                query = """
                SELECT i.name
                FROM INTERPRETER i
                JOIN SOUNDTRACK_INTERPRETER si ON i.interpreter_id = si.interpreter_id
                JOIN SOUNDTRACK s ON si.soundtrack_id = s.soundtrack_id
                """
                if titulo_soundtrack:
                    query += " WHERE s.title = %s"
                    cursor.execute(query, (titulo_soundtrack,))
                else:
                    cursor.execute(query)
                interpretes = cursor.fetchall()
                columns = [i[0] for i in cursor.description]
                actualizar_tabla(treeview, interpretes, columns)
        except mysql.connector.Error as err:
            messagebox.showerror("Error", f"Error al listar intérpretes del soundtrack: {err}")
        finally:
            conexion.close()


# Tab creation functions
def crear_pestaña_buscar_peliculas_por_clasificacion(notebook):
    tab = ttk.Frame(notebook)
    notebook.add(tab, text="Buscar Películas por Clasificación")
    treeview = ttk.Treeview(tab, height=20)
    treeview.pack(fill="both", expand=True)

    tk.Label(tab, text="Clasificación:").pack(pady=5)
    entry_clasificacion = tk.Entry(tab)
    entry_clasificacion.pack(pady=5)
    ttk.Button(tab, text="Buscar", command=lambda: buscar_peliculas_por_clasificacion(treeview, entry_clasificacion.get())).pack(pady=5)
    ttk.Button(tab, text="Mostrar Todos", command=lambda: buscar_peliculas_por_clasificacion(treeview)).pack(pady=5)


def crear_pestaña_ver_filmografia_director(notebook):
    tab = ttk.Frame(notebook)
    notebook.add(tab, text="Ver Filmografía de Director")
    treeview = ttk.Treeview(tab, height=20)
    treeview.pack(fill="both", expand=True)

    tk.Label(tab, text="Director:").pack(pady=5)
    entry_director = tk.Entry(tab)
    entry_director.pack(pady=5)
    ttk.Button(tab, text="Buscar", command=lambda: ver_filmografia_director(treeview, entry_director.get())).pack(pady=5)
    ttk.Button(tab, text="Mostrar Todos", command=lambda: ver_filmografia_director(treeview)).pack(pady=5)


def crear_pestaña_buscar_peliculas_por_actor(notebook):
    tab = ttk.Frame(notebook)
    notebook.add(tab, text="Buscar Películas por Actor")
    treeview = ttk.Treeview(tab, height=20)
    treeview.pack(fill="both", expand=True)

    tk.Label(tab, text="Actor:").pack(pady=5)
    entry_actor = tk.Entry(tab)
    entry_actor.pack(pady=5)
    ttk.Button(tab, text="Buscar", command=lambda: buscar_peliculas_por_actor(treeview, entry_actor.get())).pack(pady=5)
    ttk.Button(tab, text="Mostrar Todos", command=lambda: buscar_peliculas_por_actor(treeview)).pack(pady=5)


def crear_pestaña_buscar_soundtracks_por_autor(notebook):
    tab = ttk.Frame(notebook)
    notebook.add(tab, text="Buscar Soundtracks por Autor")
    treeview = ttk.Treeview(tab, height=20)
    treeview.pack(fill="both", expand=True)

    tk.Label(tab, text="Autor:").pack(pady=5)
    entry_autor = tk.Entry(tab)
    entry_autor.pack(pady=5)
    ttk.Button(tab, text="Buscar", command=lambda: buscar_soundtracks_por_autor(treeview, entry_autor.get())).pack(pady=5)
    ttk.Button(tab, text="Mostrar Todos", command=lambda: buscar_soundtracks_por_autor(treeview)).pack(pady=5)


def crear_pestaña_listar_interpretes_soundtrack(notebook):
    tab = ttk.Frame(notebook)
    notebook.add(tab, text="Listar Intérpretes de Soundtrack")
    treeview = ttk.Treeview(tab, height=20)
    treeview.pack(fill="both", expand=True)

    tk.Label(tab, text="Título del Soundtrack:").pack(pady=5)
    entry_titulo_soundtrack = tk.Entry(tab)
    entry_titulo_soundtrack.pack(pady=5)
    ttk.Button(tab, text="Buscar", command=lambda: listar_interpretes_soundtrack(treeview, entry_titulo_soundtrack.get())).pack(pady=5)
    ttk.Button(tab, text="Mostrar Todos", command=lambda: listar_interpretes_soundtrack(treeview)).pack(pady=5)


def crear_interfaz():
    ventana = tk.Tk()
    ventana.title("Sistema MyCineMusic24")
    ventana.geometry("800x600")

    notebook = ttk.Notebook(ventana)
    notebook.pack(expand=1, fill="both")

    crear_pestaña_buscar_peliculas_por_clasificacion(notebook)
    crear_pestaña_ver_filmografia_director(notebook)
    crear_pestaña_buscar_peliculas_por_actor(notebook)
    crear_pestaña_buscar_soundtracks_por_autor(notebook)
    crear_pestaña_listar_interpretes_soundtrack(notebook)

    ventana.mainloop()


# Run the interface
if __name__ == "__main__":
    crear_interfaz()