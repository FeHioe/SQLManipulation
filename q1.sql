SET search_path TO artistdb;

-- Find the year of Steppenwolf's first album.
CREATE VIEW wolf_year AS
	SELECT min(year) as min_year
	FROM Album
	WHERE artist_id = (

		SELECT artist_id
		FROM Artist
		WHERE name = 'Steppenwolf'

		);

-- Find songwriters and musicians born on the same year.
SELECT distinct(name), nationality
FROM Artist, Role, wolf_year
WHERE Extract(year from birthdate) = wolf_year.min_year
AND Artist.artist_id=Role.artist_id AND role!='Band'
ORDER BY name ASC;

DROP VIEW wolf_year;
