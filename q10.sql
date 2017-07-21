SET search_path TO artistdb;

-- Create a table to temporarily store MJ's values.
CREATE TABLE mj_thrill
(
	mj_id int, 
	thriller_id int,
	songs_id int
);

-- Insert MJ's values to the temp table.
INSERT INTO mj_thrill (mj_id, thriller_id, songs_id)
SELECT Artist.artist_id as mj_id, Album.album_id as thriller_id, song_id as songs_id
FROM Artist, Album, BelongsToAlbum
WHERE Artist.artist_id=Album.artist_id
AND Album.album_id=BelongsToAlbum.album_id
AND name='Michael Jackson'
AND title='Thriller';

-- Delete traces of thriller from BelongsToAlbum table.
DELETE FROM BelongsToAlbum
WHERE EXISTS 
(SELECT mj_thrill.thriller_id 
FROM mj_thrill
WHERE mj_thrill.thriller_id=BelongsToAlbum.album_id);

-- Delete traces of thriller from ProducedBy table.
DELETE FROM ProducedBy
WHERE EXISTS 
(SELECT mj_thrill.thriller_id 
FROM mj_thrill
WHERE mj_thrill.thriller_id=ProducedBy.album_id);

-- Delete traces of thriller from Album table.
DELETE FROM Album
WHERE EXISTS 
(SELECT mj_thrill.thriller_id 
FROM mj_thrill
WHERE mj_thrill.thriller_id=Album.album_id);

-- Delete traces of thriller from Songs table.
DELETE FROM Song
WHERE EXISTS 
(SELECT mj_thrill.songs_id 
FROM mj_thrill
WHERE mj_thrill.songs_id=Song.song_id);

-- Delete traces of thriller from Collaboration table.
DELETE FROM Collaboration 
WHERE EXISTS 
(SELECT mj_thrill.songs_id 
FROM mj_thrill
WHERE mj_thrill.songs_id=Collaboration.song_id);

-- Drop previously created table.
DROP TABLE mj_thrill CASCADE;
