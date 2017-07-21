SET search_path TO artistdb;

-- Find songs and their album.
CREATE VIEW song_album AS
	SELECT Song.song_id, album_id
	FROM Song, BelongsToAlbum 
	WHERE Song.song_id=BelongsToAlbum.song_id;

-- Find songs that were in more than one album.
CREATE VIEW covered_songs AS
	SELECT DISTINCT s1.song_id as song_id
	FROM song_album s1, song_album s2
	WHERE s1.song_id= s2.song_id
	AND s1.album_id!=s2.album_id;

-- Return the results in the proper format.
SELECT DISTINCT Song.title as song_name, year as year, name as artist_name
FROM Song, BelongsToAlbum, Album, Artist, covered_songs
WHERE Song.song_id=BelongsToAlbum.song_id
AND BelongsToAlbum.album_id=Album.album_id
AND Album.artist_id=Artist.artist_id
AND Song.song_id=covered_songs.song_id
ORDER BY song_name ASC, year ASC, artist_name ASC;

DROP VIEW covered_songs;
DROP VIEW song_album;
