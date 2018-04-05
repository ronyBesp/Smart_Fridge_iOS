# SmartFridge_iOS
The iOS app of the Smart Fridge Project.

This will serve the users as users will use the iOS app to interact with the system.
The iOS App integrates and connects to the Server to retrieve results using a GET request.


The other related repository locations are:

**Server**: 

**Pi**:


## Features
The iOS application is split into the following tabs with these features:
- Home tab – Display’s the users dashboard which shows the user the date of the last fridge update and how full the fridge was at that time (i.e. the capacity of the fridge)
- Picture tab – Users will be able to view the full image of the fridge the Pi took as well as view each individual shelf and item images
- Items tab – Displays the textual results of the objects recognized in the user’s fridge (i.e. apple, banana, etc.)
- Shop tab – Compares the currently recognized objects to the items the user previously had and displays the differences in the shop tab. Essentially, the shop tab is the shopping list as it shows all items that were present in the user’s fridge that are not present anymore. The idea is that once users buy these missing items and place them in the fridge, the user’s shopping list will decrease as these items are no longer missing. Users will see the shopping list decrease as soon as the Pi takes the new photo of the fridge and the server finishes processing the new results.

## Configuration

By default, the iOS app is configured to run with the server. Therefore, to interact and see the app in motion no setup
is needed - simply run it in Xcode.

To get it working with a local server, everywhere where the server URL is used within the app must be changed to
point to the local server you would like to use.
