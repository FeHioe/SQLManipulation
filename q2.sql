SET search_path TO artistdb;

-- Find the albums with a collaboration song.
CREATE VIEW album_collabs AS
	SELECT distinct(album_id) as album_id
	FROM BelongsToAlbum, Collaboration
	Where BelongsToAlbum.song_id=Collaboration.song_id;

-- Find all artists who have collaborations.
CREATE VIEW artist_collabs AS
	(SELECT artist_id 
	FROM Artist, Collaboration
	WHERE Artist.artist_id=Collaboration.artist1)
UNION 
	(SELECT artist_id
	FROM Artist, Collaboration
	WHERE Artist.artist_id=Collaboration.artist2);

-- Find all the albums without collaboration songs, but with the artists
-- who have been in a collaboration.
CREATE VIEW album_no_collabs AS
	(SELECT album_id 
	FROM Album, artist_collabs
	WHERE Album.artist_id=artist_collabs.artist_id)
EXCEPT
	(SELECT album_id
	FROM album_collabs);

-- Find the average sales of the albums that don't have a collaborator.
CREATE VIEW no_collab_sales AS
	SELECT avg(sales) as sales_no_collab, Album.album_id, artist_id
	FROM Album, album_no_collabs
	WHERE Album.album_id=album_no_collabs.album_id
	GROUP BY Album.album_id;

-- Find the average sales of the albums that do have a collaborator.
CREATE VIEW collab_sales AS
	SELECT avg(sales) as sales_collab, Album.album_id, artist_id
	FROM album_collabs, Album
	WHERE Album.album_id=album_collabs.album_id
	GROUP BY Album.album_id;

-- Find the albums that have higher average sales with a collaborator
-- than without.
CREATE VIEW higher_collab AS
	SELECT sales_collab, collab_sales.artist_id
	FROM no_collab_sales, collab_sales
	WHERE no_collab_sales.artist_id=collab_sales.artist_id
	AND collab_sales.sales_collab>no_collab_sales.sales_no_collab;

-- Return the result in the format specified. 
SELECT DISTINCT (name) AS artists, sales_collab AS avg_collab_sales
FROM higher_collab, Artist
WHERE Artist.artist_id=higher_collab.artist_id
ORDER BY artists ASC;

DROP VIEW higher_collab;
DROP VIEW no_collab_sales;
DROP VIEW collab_sales;
DROP VIEW album_no_collabs;
DROP VIEW artist_collabs;
DROP VIEW album_collabs;
