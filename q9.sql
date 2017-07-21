SET search_path TO artistdb;
-- Find Adam Levine's id.
CREATE VIEW adam_id AS
	SELECT artist_id
	FROM Artist 
	WHERE name='Adam Levine';

-- Update the table to annouce his farewell.
UPDATE WasInBand
SET end_year='2014'
FROM adam_id
WHERE WasInBand.artist_id=adam_id.artist_id;

-- Find Mick Jagger's id.
CREATE VIEW mick_id AS
	SELECT artist_id 
	FROM Artist
	WHERE name='Mick Jagger';

-- Update the table to remove Mick Jagger from his past band.
UPDATE WasInBand
SET end_year='2014'
FROM mick_id
WHERE WasInBand.artist_id=mick_id.artist_id;

-- Find Maroon 5's id.
CREATE VIEW maroon5_id AS
	SELECT artist_id 
	FROM Artist 
	WHERE name='Maroon 5';

-- Update the table to show Maroon 5's new singer.
INSERT INTO WasInBand (artist_id, band_id, start_year, end_year)
SELECT mick_id.artist_id as artist_id, maroon5_id.artist_id as band_id,
'2014' AS start_year, '2015' AS end_year
FROM mick_id, maroon5_id;

DROP VIEW mick_id;
DROP VIEW adam_id;
