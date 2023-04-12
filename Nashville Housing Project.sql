SELECT 
	*
FROM
	PortfolioProject..NashvilleHousing

-------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format

SELECT 
	SaleDateConverted, CONVERT(Date,SaleDate)
FROM
	PortfolioProject..NashvilleHousing
	

Update NashvilleHousing
SET SaleDate = CONVERT(Date,SaleDate)

ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;

Update NashvilleHousing
SET SaleDateConverted = CONVERT(Date,SaleDate)


-------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data

SELECT 
	*
FROM
	PortfolioProject..NashvilleHousing
--WHERE PropertyAddress is null
ORDER BY ParcelID

SELECT 
	a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM
	PortfolioProject..NashvilleHousing a
JOIN PortfolioProject..NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is null


Update a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)

FROM
	PortfolioProject..NashvilleHousing a
JOIN PortfolioProject..NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is null


------------------------------------------------------------------------------------------------------------------------


-- Breaking out Address into Individual Columns (Address, City, State)


SELECT 
	PropertyAddress
FROM
	PortfolioProject..NashvilleHousing
--WHERE PropertyAddress is null
--ORDER BY ParcelID

SELECT
	SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1) as Address,
	SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) as City
FROM
	PortfolioProject..NashvilleHousing


ALTER TABLE NashvilleHousing
Add PropertySplitAddress nvarchar(255);

Update NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1)


ALTER TABLE NashvilleHousing
Add PropertySplitCity nvarchar(255);

Update NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress))


-- Breaking out Owner Address into Individual Columns (Address, City, State)
-- Easier compared to the last one

SELECT
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
FROM
	PortfolioProject..NashvilleHousing


ALTER TABLE NashvilleHousing
Add OwnerSplitAddress nvarchar(255);

Update NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)


ALTER TABLE NashvilleHousing
Add OwnerSplitCity nvarchar(255);

Update NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)


ALTER TABLE NashvilleHousing
Add OwnerSplitState nvarchar(255);

Update NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)


--------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field

SELECT 
	DISTINCT(SoldAsVacant),
	COUNT(SoldAsVacant)
FROM 
	PortfolioProject..NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2

SELECT 
	SoldAsVacant,
	CASE When SoldAsVacant = 'Y' THEN 'Yes'
	When SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
	END
FROM 
	PortfolioProject..NashvilleHousing


UPDATE NashvilleHousing
SET SoldAsVacant = 
		CASE When SoldAsVacant = 'Y' THEN 'Yes'
			When SoldAsVacant = 'N' THEN 'No'
			ELSE SoldAsVacant
			END
	

-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates

WITH RowNumCTE AS(
SELECT 
	*,
	ROW_NUMBER() OVER (
			PARTITION BY ParcelID,
						 PropertyAddress,
						 SalePrice,
						 SaleDate,
						 LegalReference
						 ORDER BY
							UniqueID
							) as row_num
FROM
	PortfolioProject..NashvilleHousing
--ORDER BY row_num desc
)
DELETE
FROM
	RowNumCTE
WHERE row_num > 1
--ORDER By PropertyAddress


---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns


SELECT 
	*
FROM
	PortfolioProject..NashvilleHousing

ALTER TABLE PortfolioProject..NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE PortfolioProject..NashvilleHousing
DROP COLUMN SaleDate