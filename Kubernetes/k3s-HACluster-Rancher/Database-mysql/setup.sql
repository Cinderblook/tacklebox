CREATE DATABASE k3s COLLATE latin1_swedish_ci;
CREATE USER 'user'@'%' IDENTIFIED BY 'password';
GRANT ALL ON k3s.* TO 'user'@'%';
FLUSH PRIVILEGES;
