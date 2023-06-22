# Create a MYSQL database using Docker
Ensure database is:
-   Collation: latin1_swedish_ci
-   Remote login is allowed for use

# Commands to setup:
- Enter file structure and apply `sudo docker-compose up`
- Put correct information into the setup.sql file, and this will automate the sql user requirements
- Check if user exists with `SELECT User FROM mysql.user WHERE User = 'k3s';`


# Non-automated method below
# - Enter the docker to execute commands
    - `sudo docker exec -it mysql bash`
 - `mysql -p`  (Enter password)
    ```sql 
    CREATE DATABASE k3s COLLATE latin1_swedish_ci;
    CREATE USER ‘user’@’%’ IDENTIFIED BY password’;
    GRANT ALL ON k3s.* TO 'user'@'%';
    FLUSH PRIVILEGES;
    ```
- Check if user exist with 
`SELECT User FROM mysql.user WHERE User = 'k3s';`




