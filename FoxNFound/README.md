Software Development 2 Course Work - Fall 2019

The connect_db.php needs to be in the grandparent folder of the rest of the files. This project was done using an Abyss Web Server. connect_db.php is placed in the Abyss Web Server root folder. The T7 folder is placed within the htdocs folder (located in the Abyss Web Server root)

For this project, we created a user (mike) with password (easysteps). The tables were stored on a MySQL database (site_db) and the connection was on the localhost. This is the information we checked for in the connect_db.php file.

To replicate the project: CREATE DATABASE site_db; USE site_db; GRANT SELECT, INSERT, UPDATE, DELETE ON site_db.* TO 'mike'@'localhost' IDENTIFIED BY 'easysteps';

Project was done by Joseph McDonough, Matthew Parisi, and Chris Pellerito
