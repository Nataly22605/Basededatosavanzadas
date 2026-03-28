#Documentacion de comandos de contenedores  de SGBD
##Contenedores sin volumen
**Comando para creacion de contenedor con nombre de imagen**
docker run -e "ACCEPT_EULA=Y" -e "MSSQL_SA_PASSWORD=P@ssw0rd" \
   -p 1433:1433 --name servidorsqlserverDev  \
   -d \
   mcr.microsoft.com/mssql/server:2022-latest

**comando para creacion de contenedor con id**
   docker run -e "ACCEPT_EULA=Y" -e "MSSQL_SA_PASSWORD=P@ssw0rd" \
   -p 1438:1433 --name servidorsqlserverDev1  \
   -d \
     db9a

##contenedores con volumen
   docker run -e "ACCEPT_EULA=Y" 
   -e "MSSQL_SA_PASSWORD=P@ssw0rd" \
   -p 1439:1433 --name servidorsqlserverDev2 -v volume-sqlserverdev:/var/opt/mssql \
   -d \
     db9a


     docker run -e "ACCEPT_EULA=Y" -e "MSSQL_SA_PASSWORD=P@ssw0rd" \ 
   -p 1439:1433 --name servidorsqlserverDev2 -v volume-sqlserverdev:/var/
   opt/mssql \
   -d \
   db9a

   P@ssw0rd