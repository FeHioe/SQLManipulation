SET search_path TO artistdb;

-- Find all songwriters and the albums that contain their written song.
CREATE VIEW songwrite AS
	SELECT songwriter_id, album_id
	FROM Song, BelongsToAlbum
	WHERE Song.song_id=BelongsToAlbum.song_id
	ORDER BY album_id;

-- Find all artists and their albums.
CREATE VIEW artists AS
	SELECT artist_id, album_id
	FROM album;

-- Find all the albums that have other songwriters.
CREATE VIEW not_write AS
	SELECT artists.album_id as album_id
	FROM artists, songwrite
	WHERE artists.album_id=songwrite.album_id
	AND songwriter_id!=artist_id;

-- Filter the albums to only include the musician/band as the songwriter.
CREATE VIEW only_write AS
	(SELECT album_id 
	FROM Album)
EXCEPT
	(SELECT album_id
	FROM not_write);

-- Return the result in proper form.
SELECT DISTINCT name as artist_name, title as album_name
FROM only_write, Album, Artist
WHERE only_write.album_id=Album.album_id
AND Artist.artist_id=Album.artist_id
ORDER BY artist_name ASC, album_name ASC;


DROP VIEW only_write;
DROP VIEW not_write;
DROP VIEW songwrite;
DROP VIEW artists;
