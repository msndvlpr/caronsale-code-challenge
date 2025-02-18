# CarOnSale Vehicle Auction App- A Coding Challenge

## Overview
This project is a Flutter-based application for vehicle auctions, where users can search for vehicles by VIN, view auction details, and authenticate using a repository-based 
authentication system. It also supports caching mechanisms, dark theme and also UI state handling for improved user experience in case of network success or failures.

## Features
- **User Authentication**: Uses an Authentication Repository and a mocked HTTP handler. Authentication is simulated with random success/failure responses.
- **VIN Search**: Users can search for vehicles using a VIN. Based on the VIN, the user may get a full match or a list of similar vehicles.
- **Auction Data**: Users can select vehicles and view their auction details.
- **Caching**: Data is cached per VIN in the `VehicleSearchScreen` and per External ID (EID) in the `VehicleSelectionScreen`.
- **State Management**: The application follows the BLoC architecture pattern for state management.
- **VIN Validation**: A static validator checks user input based on Wikipedia and other online sources.

## Project Structure
```
lib/
├── app/
│   ├── app.dart
│   ..
│
├── user_authentication/
│   ├── bloc/
│   ├── view/
│   ├── widget/
│
├── utils/
│
├── vehicle_auction/
│   ├── bloc/
│   ├── model/
│   ├── view/
│   ├── widget/
│
├── vehicle_search/
│
├── main.dart
│
packages/
├── auction_repository/
├── authentication_repository/
├── network_api/
├── secure_storage_api/
│
test/
│
assets/
│
pubspec.yaml
..
```

## Screen Flow and Features Overview:

### Login Screen:
In this screen user should enter it's username and password for the identification (authentication), for simulating a real situation username and password are arbitrary and 
on a random basis success or failure response will be returned from a Mocked Http Handler. Once the authentication is successful a token will be responded and it will be saved in a
local Secure Storage with the Username to be used later for the calling other mocked http requests (for auctions etc.), then it will be navigated to the next screen and for the
next time of application launch, the login page will be skipped as requested in the requirement document.

### Vehicle/VIN Search Screen:
In this screen a text field is provided to enter a VIN and it will be validated by a validator utility class upon user entry. Based on the requirement document there will be
a few number of response types, so if the response id an error or failure it will be shown here, otherwise it will navigate to the next page to display the corresponding 
vehicle auction data. User can also enable "use cache" feature by which a cached version of data will be shown if we receive error from backend (i.e. mocked http handler). 
Please also note that cached data is per VIN, so if we already receive a successful response for a VIN and then we enable use cache feature, then upon getting failure from 
backend, the cached data will be shown.
In this page user can also change the theme to dark or light, and also logout from th current user from the top left option menu, then they will be requested again to enter
username and password to authenticate and previous authentication data (i.e. token  and username) will be cleared from local storage.

### Vehicle Selection Screen:
This page will show the data in case of MultipleChoice (300 code) response, so all the vehicle options will be shown according to their similarity number from top to bottom. Also an
indicator is used to visualise the similarity number to the user. If user clicks on each arbitrary item, then "External Id" of the item will be used to call another backend endpoint
to fetch the Auction Details and accordingly and then navigate to the Auction Details Screen. 
Note: As it has been requested in the requirements document not to manipulate the mocked
http handler class, so response type 300 was filtered out and accounted as an error response in order to simulate a separate service for getting Auction Details from external id (EID).
If caching feature is enabled in the previous page, here it will also apply and if a data per EID is already cached, then in case of getting error response from backed, it will be shown.

### Auction Details Screen:
This screen is responsible to show the Auction Details data, it is possible to come to this page directly from VIN search screen if the response is 200, or from Vehicle Search Screen
when clicking on an option and receive a non error response. At the first glance, some important information of an auction/vehicle will be shown, and then user can click on the arrow
icon to expand the box and see further details including the relevant dates etc. 





## Testing
- The project uses `flutter_test` and `mocktail` for unit testing.
- Tests are available in the `test/` folder.
- Run tests using:
  ```sh
  flutter test
  ```
- Note: `authentication_repository_test.dart` does not run visually but can be executed via the command line.

## Architecture
This project follows the **BLoC** (Business Logic Component) pattern for state management. BLoC provides a structured and testable way to manage complex business logic 
in Flutter applications. It also resembles the **MVVM** pattern, where:
- The **View** layer handles UI.
- **Repositories & APIs** function as the Model layer.
- **BLoC** components act as the ViewModel.

## VIN Validation
- A static validator in `utils/data_validator.dart` checks user input.
- The validation logic is based on real-world VIN examples.
- While accurate, it may not be 100% reliable.

## Running the Project
1. Install Flutter dependencies:
   ```sh
   flutter pub get
   ```
2. Run the application:
   ```sh
   flutter run
   ```

## Notes
- Authentication is simulated, and real credentials are not checked.
- Username and password for the user identification (authentication) are arbitrary and everything can be entered. (the verification is on a random basis)
- Cached data is only used when an exact VIN or EID match is found.
- `CosChallenge` class cannot be instantiated, so it is not injected into `NetworkApiService`.

---

This README provides an overview of the project structure, features, and development approach. Let me know if you'd like to refine any section! 🚀