SET search_path TO artistdb;

-- Find all artists who have more than three albums in different genres.
CREATE VIEW album_three AS
	SELECT artist_id, count(DISTINCT Album.genre_id) as count
	FROM Album, Genre
	WHERE Album.genre_id=Genre.genre_id
	GROUP BY artist_id
	HAVING count(DISTINCT Album.genre_id) >= 3;

-- Find all songwriters who have more than three songs in different genres.
CREATE VIEW song_three AS
	SELECT songwriter_id, count(DISTINCT genre_id) as count
	FROM  Song, BelongsToAlbum, Album
	WHERE Song.song_id=BelongsToAlbum.song_id
	AND BelongsToAlbum.album_id=Album.album_id
	GROUP BY songwriter_id
	HAVING count(DISTINCT genre_id) >= 3;

-- Find all bands and musicians.
CREATE VIEW band_mus AS
	SELECT * 
	FROM Role
	WHERE role!='Songwriter';

-- Find all songwriters.
CREATE VIEW songwriter AS
	SELECT *
	FROM Role
	WHERE role='Songwriter';

-- Filter musician and band section.
CREATE VIEW three_album AS
	(SELECT DISTINCT name as artist, role as capacity, count as genres
	FROM Artist, album_three, band_mus
	WHERE Artist.artist_id=album_three.artist_id
	AND band_mus.artist_id=album_three.artist_id ORDER BY genres DESC, artist ASC);

-- Filter songwriter section.
CREATE VIEW three_song AS
	(SELECT DISTINCT name as artist, role as capacity, count as genres
	FROM Artist, song_three, songwriter
	WHERE Artist.artist_id=song_three.songwriter_id
	AND songwriter.artist_id=song_three.songwriter_id ORDER BY genres DESC, artist ASC);

-- Combine songwriters with musicians and bands.
(SELECT * FROM three_album)
UNION ALL
(SELECT * FROM three_song);

DROP VIEW three_song CASCADE;
DROP VIEW three_album CASCADE;
DROP VIEW band_mus CASCADE;
DROP VIEW songwriter CASCADE;
DROP VIEW album_three CASCADE;
DROP VIEW song_three CASCADE;
