--Cleaning the date column
	
--checking for date format
	SELECT date_added
	FROM netflix
	WHERE date_added !~ '^[0-9]{1,2}-[A-Za-z]{3}-[0-9]{2}$';

--adding a new column
	ALTER TABLE netflix ADD COLUMN date_added_clean date;

---fill valid rows
UPDATE netflix
SET date_added_clean =
  CASE
    WHEN date_added ~ '^[0-9]{1,2}-[A-Za-z]{3}-[0-9]{2}$'
      THEN to_date(date_added, 'DD-Mon-YY')::date
    WHEN date_added ~ '^[A-Za-z]+ [0-9]{1,2}, [0-9]{4}$'
      THEN to_date(date_added, 'FMMonth FMDD, YYYY')::date
    ELSE NULL
  END;

