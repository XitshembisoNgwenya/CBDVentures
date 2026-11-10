# CBDventures shared places update

This update makes Explore and the chatbot use the same curated directory in `src/main/resources/assistant/places.json`.

It includes 11 entries: the ten storefronts in the photo set, plus Xpresso from the location screenshots. Explore no longer shows the unrelated database demo listings. Places with coordinates use the supplied map pins; entries without verified coordinates are labelled as unverified and are not given a distance.

## Apply the update

1. Unzip this package.
2. Copy the included `src` folder into the root of `XitshembisoNgwenya/cbdventures-final-project`, allowing the listed files to be replaced.
3. Commit and push the changes to the repository's `main` branch.
4. Render should deploy the commit from the connected repository.

The package contains only changed source files and the ten storefront photos. It does not contain secrets or database credentials.

