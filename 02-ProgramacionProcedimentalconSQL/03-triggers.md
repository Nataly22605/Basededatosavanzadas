sp-Ejecuta solo

triggers se ejecuta solo 


los store son de uso global 
los triggers estan asociados a una tabla
trabajan con dos tablas en sql 
una se llama insert y la otra se llama deleted ->son tablas virtuales 
son tablas mutantes porque tienen los campos de la tabla principal asignada
insert funciona cuando se dispara un trigger en un insert solo lo guarda en insert 
si se hace el deleted se guarda en esa tabla
siempre existen las tablas
cuando se hace un update se guarda en las dos en insert(nuevo) y el deleted(viejo)

#Triggers(Disparadores)

#¿que es un trigger?

Es un bloque de ocidgo SQL que se ejecuta unicamente cuando ocurre un evento en una tabla:

😉Eventos 

-INSERT 
-UPDATE 
-DELETE

🐽 No se ejecutan manualmente , se activan solos.

##🫏 ¿Para que sirven?

-Validaciones
-Auditoria (guardar historial)
-Reglas del negocio
-Automatizacion

##👾 Tipos de Triggers en SQL SERVER 

-AFTER TRIGGER

Se ejecuta despues del evento 
-INSTEAD OF

Reemplaza la operacion priginal 


##🐦‍🔥Sintaxis basica 
```sql
    CREATE TRIGGER nombre_trigger
    ON nombre_tabla
    AFTER INSERT 
    AS
    BEGIN 
        --codigo
    END;
```

##Tablas especiales 

| Tabla | Contenido |
| :--- | :--- |
| INSERTED| Nuevos Datos|
| DELETED  | Datos Anteriores |

