SET search_path TO artistdb;

-- Find the record labels and the albums they produced. 
CREATE VIEW label_album AS
	SELECT RecordLabel.label_id, label_name, year, sales, Album.album_id, title
	FROM RecordLabel, ProducedBy, Album
	WHERE RecordLabel.label_id=ProducedBy.label_id
	AND Album.album_id=ProducedBy.album_id;

-- Return result in proper format.
SELECT DISTINCT label_name AS record_label, year, sum(sales) AS total_sales
FROM label_album
GROUP BY record_label, year
ORDER BY record_label ASC, year ASC;

DROP VIEW label_album;
