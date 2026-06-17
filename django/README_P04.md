# Proyecto P-04 — CRUD y Autenticación

**Stack:** Python · Django · SQLite  
**Área:** Back-end  

---

## Descripción

API web construida con Django que implementa un CRUD completo,
con sistema de autenticación de usuarios.

Proyecto orientado a demostrar manejo del ciclo completo de desarrollo back-end:
modelado de datos, vistas, autenticación y despliegue.

---

## Funcionalidades

- CRUD completo (Create, Read, Update, Delete)
- Autenticación de usuarios (registro, login, logout)
- Protección de rutas según estado de sesión
- Interfaz web con templates Django

---

## Stack técnico

| Herramienta | Uso |
|-------------|-----|
| Python 3.x  | Lenguaje base |
| Django      | Framework web |
| SQLite      | Base de datos |
| HTML/CSS    | Templates |

---

## Estructura del proyecto

```
p04_crud/
├── app/
│   ├── models.py
│   ├── views.py
│   ├── urls.py
│   └── templates/
├── manage.py
└── requirements.txt
```

---

## Instalación

```bash
git clone https://github.com/joseRPM/Portafolio-data
cd p04_crud
pip install -r requirements.txt
python manage.py migrate
python manage.py runserver
```

---

## Estado

 En desarrollo
