# Import AD
Import-Module ActiveDirectory

# Reset user input variable
$userInput = ""

# Set the path
$path = "locationofthecsv"

# Define the user to action
$userName = "user samaccountname"

# Import the csv with group names
$groups = Import-Csv -Path $path -Header Name

# Create an empty array to store the actioned groups
$groupsActioned = @()

# Create the loop
do {
    $userInput = Read-Host "Would you like to Add (A) or Remove (R) $userName from the requested groups? To Quit, press (Q)." -ForegroundColor Cyan
    switch ($userInput) {
        "A" { # Add groups
            foreach ($group in $groups) {
                try {
                    Add-ADGroupMember -Identity $group.Name -Member $userName -Confirm:$false
                    $groupsActioned += $group.Name
                    Write-Host "Added $userName to $($group.Name)." -ForegroundColor Yellow
                } catch {
                    Write-Host "Error adding $userName to $($group.Name): $_" -ForegroundColor Red
                }
            }
            # Display an output of the groups added
            Write-Host ""
            Write-Host "Groups added to $userName" -ForegroundColor Green
            $groupsActioned
          }
        "R" { # Remove groups
            foreach ($group in $groups) {
                try {
                    Remove-ADGroupMember -Identity $group.Name -Member $userName -Confirm:$false
                    $groupsActioned += $group.Name
                    Write-Host "Removed $userName from $($group.Name)." -ForegroundColor Yellow
                } catch {
                    Write-Host "Error removing $userName from $($group.Name): $_" -ForegroundColor Red
                }
            }
            # Display an output of the groups removed
            Write-Host ""
            Write-Host "Groups removed from $userName" -ForegroundColor Green
            $groupsActioned        
        }
        "Q" {
            Write-Host "Exiting loop"
            break
        }
        Default { # Invalid selection
            Write-Host "Invalid selection. Select A or R or Q to quit."
        }
    }
} until ($userInput -eq "Q")
