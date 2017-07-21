SET search_path TO artistdb;

-- Find all Canadian artist.
CREATE VIEW canada AS
	SELECT artist_id
	FROM Artist
	WHERE nationality='Canada';

-- Find the year of Canadian artists first album.
CREATE VIEW min_year AS
	SELECT canada.artist_id, min(year) as first_year
	FROM canada, album
	WHERE canada.artist_id=album.artist_id
	GROUP BY canada.artist_id;

-- Find Canadian artists first album.
CREATE VIEW first_album AS
	SELECT album_id, min_year.artist_id
	FROM Album, min_year
	WHERE Album.year=min_year.first_year
	AND album.artist_id=min_year.artist_id;

-- Find all Canadian first albums that were produced by a label.
CREATE VIEW produced_first_album AS
	SELECT ProducedBy.album_id, artist_id 
	FROM first_album, ProducedBy
	WHERE first_album.album_id=ProducedBy.album_id;

-- Find indie Canadian first albums.
CREATE VIEW indie_can_first AS
	(SELECT * 
	FROM first_album)
EXCEPT
	(SELECT *
	FROM produced_first_album);

-- Find albums that were produced by an American label.
CREATE VIEW us_produced AS
	SELECT Album.album_id, artist_id
	FROM ProducedBy, RecordLabel, Album
	WHERE ProducedBy.label_id=RecordLabel.label_id
	AND ProducedBy.album_id=Album.album_id
	AND country='America';

-- Return the result in the proper format.
SELECT DISTINCT name as artist_name
FROM indie_can_first, us_produced, Artist
WHERE indie_can_first.artist_id=us_produced.artist_id
AND us_produced.artist_id=Artist.artist_id
ORDER BY artist_name ASC;

DROP VIEW us_produced CASCADE;
DROP VIEW indie_can_first CASCADE;
DROP VIEW produced_first_album CASCADE;
DROP VIEW first_album CASCADE;
DROP VIEW min_year CASCADE;
DROP VIEW canada CASCADE;
