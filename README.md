# mysql.studio ... dockerizando ... vagrantizando ...

## 1 mysql en ubuntu

[**tuto**](https://www.digitalocean.com/community/tutorials/how-to-install-mysql-on-ubuntu-20-04-es) https://www.digitalocean.com/community/tutorials/how-to-install-mysql-on-ubuntu-20-04-es


```bash
$ sudo apt update && sudo apt install mysql-server
$ sudo mysql_secure_installation

Securing the MySQL server deployment.

Connecting to MySQL using a blank password.

VALIDATE PASSWORD COMPONENT can be used to test passwords
and improve security. It checks the strength of password
and allows the users to set only those passwords which are
secure enough. Would you like to setup VALIDATE PASSWORD component?

Press y|Y for Yes, any other key for No: y

There are three levels of password validation policy:

LOW    Length >= 8
MEDIUM Length >= 8, numeric, mixed case, and special characters
STRONG Length >= 8, numeric, mixed case, special characters and dictionary file

Please enter 0 = LOW, 1 = MEDIUM and 2 = STRONG: 2

Skipping password set for root as authentication with auth_socket is used by default.
If you would like to use password authentication instead, this can be done with the "ALTER_USER" command.
See https://dev.mysql.com/doc/refman/8.0/en/alter-user.html#alter-user-password-management for more information.

By default, a MySQL installation has an anonymous user,
allowing anyone to log into MySQL without having to have
a user account created for them. This is intended only for
testing, and to make the installation go a bit smoother.
You should remove them before moving into a production
environment.

Remove anonymous users? (Press y|Y for Yes, any other key for No) : Y
Success.

Normally, root should only be allowed to connect from
'localhost'. This ensures that someone cannot guess at
the root password from the network.

Disallow root login remotely? (Press y|Y for Yes, any other key for No) : NO

Remove test database and access to it? (Press y|Y for Yes, any other key for No) : N

 ... skipping.
Reloading the privilege tables will ensure that all changes
made so far will take effect immediately.

Reload privilege tables now? (Press y|Y for Yes, any other key for No) : Y
Success.

All done! 
```

Para conectar con MySQL como root usando passw hay que cambiar el método de autenticación:
de `auth_socket` a otro como **`caching_sha2_password`** (mejor) (o `mysql_native_password`)

```bash
$ sudo mysql
[sudo] pass ...
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 12
Server version: 8.0.35-0ubuntu0.22.04.1 (Ubuntu)
Copyright (c) 2000, 2023, Oracle and/or its affiliates.
Oracle is a registered trademark ...

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql>
```

**Usaremos como password:** `"P***t4_*0**s"` (tanto para `root` como para el sudoer `ray`)

```sql
mysql> SELECT user, authentication_string, plugin, host FROM mysql.user WHERE user="root";
-- > el plugin de root es: auth_socket
mysql> ALTER USER 'root'@'localhost' IDENTIFIED WITH caching_sha2_password BY '***'; -- MEJOR
--sql> ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '***';
-- > ERROR 1819 (HY000): Your password does not satisfy the current policy requirements
mysql> SHOW VARIABLES LIKE 'validate_password%';
-- > validate_password.length: 8
mysql> ALTER USER 'root'@'localhost' IDENTIFIED WITH caching_sha2_password BY 'P4t4t4_*0**s';
-- > Query OK, 0 rows affected (0,02 sec)
```

then, NOW:

```bash
$ sudo mysql
[sudo] contraseña para ray: 
ERROR 1045 (28000): Access denied for user 'root'@'localhost' (using password: NO)
$ sudo mysql -u root -p
Enter password: P4t***_*0**s
c
Nuevo usuario con contraseña segura:
```

```sql
mysql> CREATE user 'ray' identified by 'Ch4nge_me' PASSWORD expire;
--> Query OK, 0 rows affected (0,01 sec)
mysql> SELECT user from mysql.user;
mysql> GRANT ALL PRIVILEGES ON *.* TO 'ray'@'localhost' WITH GRANT OPTION;
ERROR 1410 (42000): You are not allowed to create a user with GRANT
-- This means that to grant some privileges to a user, the user must be created first.
-- see https://dev.mysql.com/blog-archive/how-to-grant-privileges-to-users-in-mysql-80/
mysql> exit
```

```bash
$ mysql -u ray -pCh4nge_me -h localhost
```
```sql
mysql> -- y ahora si es efectiva la existencia del usuario
mysql> set password='P4t***_*0**s';
mysql> show privileges;
-- > mas de 80
```

Mas sobre privilegios convenientes e interesantes -y roles- en 
[**esta receta**](https://dev.mysql.com/blog-archive/how-to-grant-privileges-to-users-in-mysql-80/)

### utileria

```bash
[sudo] systemctl status mysql.service
[sudo] systemctl stop mysql.service
[sudo] systemctl start mysql.service
[sudo] systemctl restart mysql.service
```
## 2 mysql en docker

Tuto en el [**video**](https://www.youtube.com/watch?v=lhijcwwvrWo) 

Official: [https://hub.docker.com/_/mysql](https://hub.docker.com/_/mysql)
... via docker compose:

`touch docker-compose.yml`

### cliente DBeaver: 
    
    ++connection; set: driver-properties:allowPublicRetrieval: TRUE

## 3 Vagrant en Ubuntu

- [!!] https://www.redeszone.net/tutoriales/servidores/vagrant-instalacion-configuracion-ejemplos/
>(...) de Vagrant es su capacidad para utilizar diferentes proveedores de virtualización, como VirtualBox, VMware y Hyper-V. Estos proveedores ofrecen diferentes características y optimizaciones de rendimiento, lo que permite a desarrolladores elegir ante casos específicos. **Además**, Vagrant tambien "virtualiza ligero" utilizando tecnologías como **Docker** y **LXC**, lo que permite inicio y apagado más rápidos de las máquinas

### 3.1 LXC: linux containers

- [ ] [**que son**](https://www.qindel.com/que-son-los-contenedores-linux-o-lxc-linux-containers/)

## 4 mysql en vagrant

- [ ] Connecting to Vagrant VM MySQL database from host: [**this gist**](https://gist.github.com/rmatil/8d21620c11039a442964)


