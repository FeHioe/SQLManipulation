SET search_path TO artistdb;

-- Find AC/DC's id.
CREATE VIEW acdc_id AS
	SELECT band_id as ad_id
	FROM  wasinband, artist
	WHERE wasinband.band_id=artist.artist_id
	AND name = 'AC/DC';

-- Find the members of AC/DC.
CREATE VIEW acdc_members AS
	SELECT artist_id, ad_id
	FROM wasinband, acdc_id
	WHERE wasinband.band_id = acdc_id.ad_id;

-- Insert the reformation into WasInBand.
INSERT INTO WasInBand (artist_id, band_id, start_year, end_year)
SELECT artist_id, ad_id, 2014 AS start_year, 2015 AS end_year
FROM acdc_members;

DROP VIEW acdc_members;
DROP VIEW acdc_id;
