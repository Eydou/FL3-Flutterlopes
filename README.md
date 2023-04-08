# FL3-Flutterlopes

This project is about cooking. You can register to the application whith Google and search for recipes. Moreover if you have the admin status, you can create your own recipes !

## Deploy locally

In order to build locally the project. You must have a corresponding [Firebase project](https://console.firebase.google.com/u/0/)
Then you must install the [Firebase CLI](https://firebase.google.com/docs/cli?hl=fr#setup_update_cli)
Next you should open your favorite shell to locally configure firebase to use you registered project: `flutterfire configure`. This command will setup the supported platforms.
Firebase should be ready to use.

## Code architecture

The code is divided in 4 main categories:
    - bloc: BloC global state manager used for authentication
    - class: Main data structures used in the project
    - pages: Contains all flutter pages
    - widgets: Different generic or specific widget used in the project

## External librairies

The project currently uses the following external dependencies:
    - cupertino_icons: Asset repo for icons.
    - flutter_bloc: Integrates blocs and cubits into Flutter.
    - firebase_core, firebase_auth, firebase_database, cloud_firestore, firebase_storage: Firebase librairies used for authentication and data management.
    - equatable: overrides the == and hasCode methods.
    - google_sign_in: Google authentication
    - email_validator: Validates email for auth
    - image_picker: Pick images and camera management
    - material_floating_search_bar: Search bar