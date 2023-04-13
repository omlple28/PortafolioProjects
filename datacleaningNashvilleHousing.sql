SELECT * FROM nashville_housing

-- estandarizar el formato fecha de la columna SaleDate
ALTER TABLE nashville_housing
ALTER COLUMN "SaleDate" SET DATA TYPE date;

-- eliminar los valores nulos de PropertyAddress
SELECT 
    *
FROM
    nashville_housing
ORDER BY 'ParcelID';

SELECT  a."uniqueID",a."ParcelID",b."PropertyAddress"
FROM nashville_housing a
JOIN nashville_housing b ON a."ParcelID"=b."ParcelID" AND a."uniqueID"<>b."uniqueID"
WHERE a."PropertyAddress" IS NULL

UPDATE nashville_housing
SET "PropertyAddress"=s."PropertyAddress"
FROM ( SELECT  a."uniqueID",a."ParcelID",b."PropertyAddress"
	FROM nashville_housing a
	JOIN nashville_housing b ON a."ParcelID"=b."ParcelID" AND a."uniqueID"<>b."uniqueID"
	WHERE a."PropertyAddress" IS NULL) AS s
WHERE  nashville_housing."uniqueID"=s."uniqueID";


-- segmentar PropertyAddress en dos nuevas columnas (address,city)
SELECT 
    SUBSTRING('PropertyAddress',
        1,
        STRPOS('PropertyAddress', ',') - 1) AS address,
    SUBSTRING('PropertyAddress',
        STRPOS('PropertyAddress', ',') + 1,
        LENGTH('PropertyAddress')) AS city
FROM
    nashville_housing;

ALTER TABLE nashville_housing
ADD COLUMN propertysplitcity text;

UPDATE nashville_housing 
SET 
    propertysplitcity = SUBSTRING('PropertyAddress',
        STRPOS('PropertyAddress', ',') + 1,
        LENGTH('PropertyAddress'));

ALTER TABLE nashville_housing
ADD COLUMN propertysplitaddress text;

UPDATE nashville_housing 
SET 
    propertysplitaddress = SUBSTRING('PropertyAddress',
        1,
        STRPOS('PropertyAddress', ',') - 1);

-- segmentar OwnerAddress en tres nuevas columnas (address,city and state)
SELECT 
    SPLIT_PART('OwnerAddress', ',', 1),
    SPLIT_PART('OwnerAddress', ',', 2),
    SPLIT_PART('OwnerAddress', ',', 3)
FROM
    nashville_housing;

ALTER TABLE nashville_housing
ADD COLUMN ownersplitaddress text;

ALTER TABLE nashville_housing
ADD COLUMN ownersplitcity text;

ALTER TABLE nashville_housing
ADD COLUMN ownersplitstate text;

UPDATE nashville_housing 
SET 
    ownersplitaddress = SPLIT_PART('OwnerAddress', ',', 1);

UPDATE nashville_housing 
SET 
    ownersplitcity = SPLIT_PART('OwnerAddress', ',', 2);

UPDATE nashville_housing 
SET 
    ownersplitstate = SPLIT_PART('OwnerAddress', ',', 3);

-- estandarizar la columna SoldAsVacant cambiando N por No y Y por Yes
SELECT 
    'SoldAsVacant', COUNT('SoldAsVacant')
FROM
    nashville_housing
GROUP BY 'SoldAsVacant';

SELECT 
    CASE
        WHEN 'SoldAsVacant' = 'Y' THEN 'Yes'
        WHEN 'SoldAsVacant' = 'N' THEN 'No'
        ELSE 'SoldAsVacant'
    END
FROM
    nashville_housing;

UPDATE nashville_housing
SET "SoldAsVacant"= CASE WHEN "SoldAsVacant"='Y' THEN 'Yes'
	 					WHEN "SoldAsVacant"='N' THEN 'No'
	 					ELSE "SoldAsVacant"
					END;
					

		
