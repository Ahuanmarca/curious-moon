-- 
-- clean it up by removing headers
-- and empty rows
delete from import.inms
where sclk IS NULL or sclk = 'sclk';
-- 