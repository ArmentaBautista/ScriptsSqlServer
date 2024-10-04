

SELECT ISNULL('DROP ' + CASE
				 WHEN a.type='IF' THEN 'FUNCTION'
				 WHEN a.type='P' THEN 'PROCEDURE'
				 WHEN a.type='TT' THEN 'TYPE'
				 WHEN a.type='U' THEN 'TABLE'
				 WHEN a.type='V' THEN 'VIEW'
				 END
			+ ' ' + a.name,'')
, a.name,a.type, b.name, b.type
FROM (
		SELECT * FROM [iERP_WOK].sys.objects o
		WHERE name LIKE '%BKG%' AND type NOT IN ('D','F','PK')
	) a
RIGHT JOIN (
		SELECT * FROM [iERP_KFT].sys.objects o
		WHERE name LIKE '%BKG%' AND type NOT IN ('D','F','PK')
		) b ON b.name=a.name
