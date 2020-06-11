--Vista 1 Sesiones de Usuarios

CREATE VIEW VISTA_SESIONES AS

SELECT NAME, SESSION_LOGOUT, LOGIN_COUNT FROM USER, USER_SESSION WHERE USER.ID = USER_SESSION.USER_ID;

SELECT * FROM VISTA_SESIONES;

--Vista 2 Crear una tabla songs_play que tenga id_song e id_usuario e veces reproducidas

create definer = root@`%` view VISTA_MOSTPLAYED as
select `spotify`.`SONGS`.`TITLE`                          AS `SONG`,
       `spotify`.`ALBUM`.`TITLE`                          AS `ALBUM`,
       `spotify`.`ARTIST`.`NAME`                          AS `ARTIST`,
       count(`spotify`.`PLAYED_SONGS`.`SONG_ID`)          AS `PLAYEDS_COUNT`,
       count(distinct `spotify`.`PLAYED_SONGS`.`USER_ID`) AS `PLAYEDS_DIFF_USERS`
from ((((`spotify`.`SONGS` join `spotify`.`ALBUM`) join `spotify`.`USER`) join `spotify`.`ARTIST`)
         join `spotify`.`PLAYED_SONGS`)
where ((`spotify`.`USER`.`ID` = `spotify`.`PLAYED_SONGS`.`USER_ID`) and
       (`spotify`.`ARTIST`.`ID` = `spotify`.`ALBUM`.`ARTIST_ID`) and
       (`spotify`.`ALBUM`.`ID` = `spotify`.`SONGS`.`ALBUM_ID`) and
       (`spotify`.`SONGS`.`ID` = `spotify`.`PLAYED_SONGS`.`SONG_ID`))
group by `spotify`.`PLAYED_SONGS`.`SONG_ID`
order by `PLAYEDS_COUNT` desc;

--Vista 3 Usuario login

CREATE VIEW VISTA_USUARIOS AS

SELECT NAME, SESSION_LOGIN FROM USER, USER_SESSION WHERE USER.ID = USER_SESSION.USER_ID;

SELECT * FROM VISTA_SESIONES;