DROP DATABASE IF EXISTS spotify;

CREATE DATABASE spotify;


CREATE USER 'marc'@'%' IDENTIFIED BY 'hi22pass322*';
GRANT SELECT ON `spotify`.* TO 'marc'@'%';

USE spotify;


CREATE TABLE `PLAN` (
  `ID` int PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `NAME` varchar(20) NOT NULL,
  `PRICE` int NOT NULL
);

CREATE TABLE `USER` (
  `ID` int PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `NAME` varchar(20) NOT NULL,
  `LASTNAME` varchar(30) NOT NULL,
  `DATE_OF_BIRTH` DATE NOT NULL,
  `ADDRESS` varchar(100) NOT NULL,
  `EMAIL` varchar(50) NOT NULL,
  `PASSWORD` varchar(100) NOT NULL,
  `USER_TYPE_ID` int NOT NULL,
  `COUNTRY` varchar(255) NOT NULL,
  `DATE_CREATED` DATE NOT NULL,
  `IS_ACTIVE` int(1) NOT NULL
);

CREATE TABLE `USER_TYPE` (
  `ID` int PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `ID_PUBLICIDAD` int,
  `TYPE` varchar(20) NOT NULL
);

CREATE TABLE `CONTRACT` (
  `ID` int PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `USER_ID` int NOT NULL,
  `NUMBER` int NOT NULL,
  `PLAN_ID` int NOT NULL,
  `PAY_METHOD` int NOT NULL
);

CREATE TABLE `SONGS` (
  `ID` int PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `TITLE` varchar(255) NOT NULL,
  `ARTIST_ID` int NOT NULL,
  `ALBUM_ID` int NOT NULL,
  `DURATION_MS` int NOT NULL,
  `LIKES` int NOT NULL,
  `PLAYS` int NOT NULL,
  `GENRE_ID` int NOT NULL
);

CREATE TABLE `ALBUM` (
  `ID` int PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `TITLE` varchar(255) NOT NULL,
  `ARTIST_ID` int NOT NULL,
  `DATE` year NOT NULL,
  `COVER` mediumblob NOT NULL,
  `GENRE_ID` int NOT NULL
);

CREATE TABLE `GENRE` (
  `ID` int PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `NAME` varchar(255) NOT NULL
);

CREATE TABLE `ARTIST` (
  `ID` int PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `NAME` varchar(255) NOT NULL,
  `LASTNAME` varchar(255) NOT NULL,
  `ALIAS` varchar(255) NOT NULL,
  `BIOGRAPHY` varchar(555) NOT NULL,
  `PHOTO` mediumblob NOT NULL,
  `FOLLOWERS` int NOT NULL
);

CREATE TABLE `LIBRARY_USER` (
  `ID_LIBRARY_USER` int PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `USER_ID` int NOT NULL,
  `SONG_ID` int NOT NULL,
  `PLAYLIST_USER_ID` int NOT NULL
);

CREATE TABLE `PLAYLIST_USER` (
  `ID_PLAYLIST_USER` int PRIMARY KEY NOT NULL,
  `SONG_ID` int NOT NULL,
  `COVER` mediumblob NOT NULL,
  `DATE_CREATED` datetime NOT NULL
);

CREATE TABLE `ROL_ARTISTA` (
  `ID` int PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `ID_USER` int NOT NULL,
  `ID_ARTISTA` int NOT NULL
);

CREATE TABLE `FACTURA` (
  `ID` int PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `ID_PLAN` int(20) NOT NULL,
  `ID_USER` int NOT NULL,
  `ID_CONTRACT` int NOT NULL,
  `DETALLE` varchar(255) NOT NULL,
  `DATE_CREATED` DATE NOT NULL
);

CREATE TABLE `PUBLICIDAD` (
  `ID` int PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `COMPANY` varchar(20) NOT NULL,
  `DURATION_MS` int NOT NULL,
  `NAME` varchar(50) NOT NULL,
  `FRECUENCY` bigint NOT NULL
);


CREATE TABLE `USER_SESSION` (
  `ID` INT PRIMARY KEY NOT NULL,
  `SESSION_LOGOUT` TIMESTAMP(2),
  `SESSION_LOGIN` TIMESTAMP(2),
  `LOGIN_COUNT` INT,
  `USER_ID` INT
);


CREATE TABLE `PLAYED_SONGS` (
  `SONG_ID` INT NOT NULL,
  `USER_ID` INT NOT NULL,
  PRIMARY KEY (`SONG_ID`, `USER_ID`)
);

ALTER TABLE `PLAYED_SONGS` ADD FOREIGN KEY (`SONG_ID`) REFERENCES `SONGS` (`ID`) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE `PLAYED_SONGS` ADD FOREIGN KEY (`USER_ID`) REFERENCES `USER` (`ID`) ON DELETE NO ACTION ON UPDATE NO ACTION;



ALTER TABLE `ARTIST` ADD FOREIGN KEY (`ID`) REFERENCES `ROL_ARTISTA` (`ID_ARTISTA`);


ALTER TABLE `USER_SESSION` ADD FOREIGN KEY (`USER_ID`) REFERENCES `USER` (`USER_ID`) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE `PUBLICIDAD` ADD FOREIGN KEY (`ID`) REFERENCES `USER_TYPE` (`ID`);

ALTER TABLE `CONTRACT` ADD FOREIGN KEY (`USER_ID`) REFERENCES `USER` (`ID`);

ALTER TABLE `USER` ADD FOREIGN KEY (`USER_TYPE_ID`) REFERENCES `USER_TYPE` (`ID`);

ALTER TABLE `CONTRACT` ADD FOREIGN KEY (`PLAN_ID`) REFERENCES `PLAN` (`ID`);

ALTER TABLE `SONGS` ADD FOREIGN KEY (`ARTIST_ID`) REFERENCES `ARTIST` (`ID`);

ALTER TABLE `ALBUM` ADD FOREIGN KEY (`ARTIST_ID`) REFERENCES `ARTIST` (`ID`);

ALTER TABLE `SONGS` ADD FOREIGN KEY (`ALBUM_ID`) REFERENCES `ALBUM` (`ID`);

ALTER TABLE `SONGS` ADD FOREIGN KEY (`GENRE_ID`) REFERENCES `GENRE` (`ID`);

ALTER TABLE `ALBUM` ADD FOREIGN KEY (`GENRE_ID`) REFERENCES `GENRE` (`ID`);

ALTER TABLE `LIBRARY_USER` ADD FOREIGN KEY (`USER_ID`) REFERENCES `USER` (`ID`);

ALTER TABLE `LIBRARY_USER` ADD FOREIGN KEY (`SONG_ID`) REFERENCES `SONGS` (`ID`);

ALTER TABLE `LIBRARY_USER` ADD FOREIGN KEY (`PLAYLIST_USER_ID`) REFERENCES `PLAYLIST_USER` (`ID_PLAYLIST_USER`);

ALTER TABLE `PLAYLIST_USER` ADD FOREIGN KEY (`SONG_ID`) REFERENCES `SONGS` (`ID`);

ALTER TABLE `ROL_ARTISTA` ADD FOREIGN KEY (`ID_USER`) REFERENCES `USER` (`ID`);

ALTER TABLE `FACTURA` ADD FOREIGN KEY (`ID_PLAN`) REFERENCES `PLAN` (`ID`);

ALTER TABLE `FACTURA` ADD FOREIGN KEY (`ID_USER`) REFERENCES `USER` (`ID`);

ALTER TABLE `FACTURA` ADD FOREIGN KEY (`ID_CONTRACT`) REFERENCES `CONTRACT` (`ID`);
