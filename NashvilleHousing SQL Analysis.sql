Select *
From PortfolioProject.dbo.NashvilleHousing

--Data Overview


Select Count(*) As Total_Properties
From PortfolioProject.dbo.NashvilleHousing

Select MIN(SaleDateConverted) As Min_SaleDate, MAX(SaleDateConverted) As Max_SaleDate
From PortfolioProject.dbo.NashvilleHousing

Select AVG(SalePrice) As AVG_SalePrice
From PortfolioProject.dbo.NashvilleHousing

Select LandUse, Count(*) As LandUse_Count
From PortfolioProject.dbo.NashvilleHousing
Group By LandUse
Order by LandUse_Count asc


--Price Analysis

Select TOP 100 PropertySplitAddress, Saleprice, Bedrooms
From PortfolioProject.dbo.NashvilleHousing
Order By SalePrice desc

Select AVG(SalePrice) SalePrice, Bedrooms, Count(*) As PropertyCount
From PortfolioProject.dbo.NashvilleHousing
Group By Bedrooms
Order By Bedrooms

Select *
From PortfolioProject.dbo.NashvilleHousing
Where Year(SaleDateConverted) = 2014

Select *
From PortfolioProject.dbo.NashvilleHousing
Where Year(SaleDateConverted) = 2013


--Location Insights

Select LandUse, Count(*) As LandUse_Count, AVG(SalePrice)
From PortfolioProject.dbo.NashvilleHousing
Group By LandUse
Order by LandUse_Count asc

Select Top 100 PropertySplitAddress, AVG(SalePrice) AVG_SalesPrice, Count(*) As SalesCount
From PortfolioProject.dbo.NashvilleHousing
Group By PropertySplitAddress
Order By SalesCount asc

Select Top 100 PropertySplitCity, AVG(SalePrice) AVG_SalesPrice, Count(*) As SalesCount
From PortfolioProject.dbo.NashvilleHousing
Group By PropertySplitCity
Order By AVG(SalePrice) desc


--Price Outliers

With CityAverage AS (
    Select PropertySplitCity, AVG(SalePrice) AS AVG_SalePrice
    From PortfolioProject.dbo.NashvilleHousing
    Group By PropertySplitCity
)
Select * 
From CityAverage

With CityAverage AS (
    Select PropertySplitCity, AVG(SalePrice) AS AVG_SalePrice
    From PortfolioProject.dbo.NashvilleHousing
    Group By PropertySplitCity
)
Select nh.PropertySplitCity, nh.PropertySplitAddress, nh.SalePrice, ca.AVG_SalePrice
From PortfolioProject.dbo.NashvilleHousing AS nh
INNER JOIN CityAverage AS ca ON nh.PropertySplitCity = ca.PropertySplitCity
Where nh.SalePrice > (ca.AVG_SalePrice * 1.20)