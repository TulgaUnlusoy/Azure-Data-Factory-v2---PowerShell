# Connect to Azure
Connect-AzAccount

# See if there is at least one subscription and also more than one subscription
Get-AzSubscription

# If you have more than one subscription, select the subscription first.
# Select-AzSubscription -SubscriptionId ""

# Set variables
$resourceGroupName = ""
$location = "eastus"
$dataFactoryName = ""

# Initialize variables
$resourceGroups = ""
$azureDataFactories = ""
$storageAccounts = ""
$myError = ""

# Create a resource group if needed
$resourceGroups = Get-AzResourceGroup -ErrorAction SilentlyContinue -ErrorVariable myError | Select-Object ResourceGroupName
if ($myError)
{
    # No resource groups found
    Write-Host $myError -ForegroundColor Red -BackgroundColor Black    
    $myError = ""
    Write-Host "No resource groups found! Creating the resource group " $resourceGroupName " ..." -ForegroundColor Yellow -BackgroundColor Black
    New-AzResourceGroup -Name $resourceGroupName -Location $location
}
elseif ($resourceGroups -match $resourceGroupName) 
{
    # Skip creating the resource group
    Write-Host "Resource group " $resourceGroupName " already exists! Step skipped..." -ForegroundColor Yellow -BackgroundColor Black  
}
else
{
    Write-Host "Create the resource group " $resourceGroupName " ..." -ForegroundColor Yellow -BackgroundColor Black
    New-AzResourceGroup -Name $resourceGroupName -Location $location
}

# Create a ADF account if needed
$azureDataFactories = Get-AzDataFactoryV2 -ErrorAction SilentlyContinue -ErrorVariable myError | Select-Object DataFactoryName
if ($myError)
{
    # No ADF found
    Write-Host $myError -ForegroundColor Red -BackgroundColor Black    
    $myError = ""
    Write-Host "No Data Factory v2 found! Creating the Data Factory v2 " $dataFactoryName " ..." -ForegroundColor Yellow -BackgroundColor Black
    Set-AzDataFactoryV2 -ResourceGroupName $resourceGroupName -Name $dataFactoryName -Location $location
}
elseif ($azureDataFactories -match $dataFactoryName) 
{
    # Skip creating the ADF
    Write-Host "Azure Data Factory v2 " $dataFactoryName " already exists! Step skipped..." -ForegroundColor Yellow -BackgroundColor Black  
}
else
{
    Write-Host "Create the Azure Data Factory v2 " $dataFactoryName " ..." -ForegroundColor Yellow -BackgroundColor Black
    Set-AzDataFactoryV2 -ResourceGroupName $resourceGroupName -Name $dataFactoryName -Location $location
}
