# ReuseKit Widget Documentation

This document provides comprehensive documentation for the reusable widgets and utilities available in the ReuseKit framework. To use these components, simply import `package:reusekit/core.dart` in your file.

## Table of Contents

1. [Context-less Utilities](#context-less-utilities)
   - [Navigation](#navigation)
   - [Snackbar](#snackbar)
   - [Confirmation Dialog](#confirmation-dialog)
   - [Loading Indicators](#loading-indicators)
   - [Dismissible Row Action](#dismissible-row-action)
2. [Form Widgets](#form-widgets)
   - [QButton](#qbutton)
   - [QTextField](#qtextfield)
   - [QSearchField](#qsearchfield)
   - [QNumberField](#qnumberfield)
   - [QDatePicker](#qdatepicker)
   - [QDropdownField](#qdropdownfield)
   - [QCheckField](#qcheckfield)
   - [QSwitch](#qswitch)
   - [QAutoComplete](#qautocomplete)
   - [QImagePicker](#qimagepicker)
   - [QFilePicker](#qfilepicker)
   - [QCameraPicker](#qcamerapicker)
   - [QMemoField](#qmemofield)
   - [QLocationPicker](#qlocationpicker)
   - [QRatingField](#qratingfield)
   - [QCategoryPicker](#qcategorypicker)
3. [Navigation Widgets](#navigation-widgets)
   - [QNavigation](#qnavigation)

## Context-less Utilities

These utilities can be called from anywhere in your application logic without requiring a BuildContext.

### Navigation

Context-less navigation functions. Always use `await` for asynchronous navigation.

```dart
// Navigate to a new view (always use await)
await to(ExampleView());

// Navigate to a new view and clear the stack (always use await)
await offAll(ExampleView());

// Go back to the previous view
back();
```

### Snackbar

Display brief messages to users with different styling based on the message type:

```dart
// Success message (green)
ss("message");

// Error message (red)
se("message");

// Information message (blue)
si("message");

// Warning message (yellow/orange)
sw("message");

// Primary color message
sp("message");

// Standard/neutral message
ssn("message");
```

### Confirmation Dialog

Show a dialog to confirm user actions:

```dart
// Returns true if confirmed, false otherwise
bool confirmed = await confirm("Are you sure?");
```

### Loading Indicators

Show or hide a global loading indicator:

> **Important**: Only use these for short-term actions like button clicks. For page-level loading (e.g., when fetching data on page load), use a boolean state variable with CircularProgressIndicator instead.

```dart
// Display loading indicator
showLoading();

// Hide loading indicator
hideLoading();
```

### Dismissible Row Action

Create a dismissible item (swipe to delete/action):

```dart
rowAction(
  onDismiss: () {
    // Action to perform when dismissed
  },
  child: Card(
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text("Swipe me"), 
    ),
  ),
)
```

> **Note**: Always use Card or custom widgets as children. Do not use ListTile.

## Form Widgets

### QButton

A versatile button component. Always use solid button variants; avoid outlined styles.

```dart
// Basic button
QButton(
  label: "Save",
  onPressed: () {},
)

// Button with predefined color
QButton(
  label: "Danger",
  color: dangerColor,
  onPressed: () {},
)

// Primary colored button
QButton(
  label: "Primary Action",
  color: primaryColor,
  onPressed: () {},
)

// Button with icon
QButton(
  label: "Add Item",
  icon: Icons.add,
  onPressed: () {},
)
```

**Available Colors**: 
- primaryColor
- secondaryColor
- successColor
- warningColor
- dangerColor

> **Note**: Do not define `textColor` or `borderColor` properties.

### QTextField

Standard text input field:

```dart
QTextField(
  label: "Name",
  validator: Validator.required,
  value: nameVariable, // Initial value
  onChanged: (value) {
    // Update state with new value
    nameVariable = value;
  },
)
```

Email field example:

```dart
QTextField(
  label: "Email",
  validator: Validator.email,
  suffixIcon: Icons.email,
  value: emailVariable,
  onChanged: (value) {
    emailVariable = value;
  },
)
```

Password field example:

```dart
QTextField(
  label: "Password",
  obscureText: true,
  validator: Validator.required,
  suffixIcon: Icons.password,
  value: passwordVariable,
  onChanged: (value) {
    passwordVariable = value;
  },
)
```

### QSearchField

Specialized input field for search functionality:

```dart
QSearchField(
  label: "Search",
  value: searchQuery,
  prefixIcon: Icons.search,
  onChanged: (value) {
    searchQuery = value;
    // Handle search as user types
  },
  onSubmitted: (value) {
    // Handle search on submission
  },
)
```

### QNumberField

For numeric input:

```dart
// Basic number field
QNumberField(
  label: "Age",
  validator: Validator.required,
  value: ageVariable,
  onChanged: (value) {
    ageVariable = value;
  },
)

// Currency field with formatting
QNumberField(
  label: "Price",
  validator: Validator.required,
  value: "15000",
  pattern: "#,###", // Format pattern
  locale: "en_US",  // Locale for formatting
  onChanged: (value) {
    priceVariable = value;
  },
)
```

### QDatePicker

For selecting dates:

```dart
QDatePicker(
  label: "Birth date",
  validator: Validator.required,
  value: birthDateVariable, // DateTime object
  onChanged: (value) {
    birthDateVariable = value;
  },
)
```

### QDropdownField

For selecting a single option from a list:

```dart
QDropdownField(
  label: "Roles",
  validator: Validator.required,
  items: const [
    {
      "label": "Admin",
      "value": "Admin",
    },
    {
      "label": "Staff",
      "value": "Staff",
    }
  ],
  value: selectedRole, // Initial selection
  onChanged: (value, label) {
    selectedRole = value;
  },
)
```

### QCheckField

For selecting multiple options using checkboxes:

```dart
QCheckField(
  label: "Club",
  validator: Validator.atLeastOneitem, // Ensure at least one selection
  items: [
    {
      "label": "Persib",
      "value": 101,
      "checked": false,
    },
    {
      "label": "Persikabo",
      "value": 102,
      "checked": true,
    }
  ],
  onChanged: (values, ids) {
    // values: Updated list of items with checked status
    // ids: List of selected values
    selectedClubs = values;
    selectedClubIds = ids;
  },
)
```

### QSwitch

For radio-button-like selection or a simple on/off toggle:

```dart
QSwitch(
  label: "Member",
  validator: Validator.atLeastOneitem,
  items: const [
    {
      "label": "Private",
      "value": 1,
    },
    {
      "label": "Premium",
      "value": 2,
    }
  ],
  value: membershipType, // Initial selection
  onChanged: (values, ids) {
    membershipType = values;
  },
)

// For a simple boolean switch (single item toggle)
QSwitch(
  label: "Notifications Enabled",
  value: isNotificationsEnabled, // boolean
  onChanged: (newValue) {
    isNotificationsEnabled = newValue;
  },
)
```

### QAutoComplete

For selecting an item with search/autocomplete functionality:

```dart
QAutoComplete(
  label: "Favorite employee",
  validator: Validator.required,
  items: const [
    {
      "label": "Jackie Roo",
      "value": "101",
      "info": "Hacker",
    },
    {
      "label": "Dan Milton",
      "value": "102",
      "info": "UI/UX Designer",
    },
    {
      "label": "Ryper Roo",
      "value": "103",
      "info": "Android Developer",
    }
  ],
  value: selectedEmployeeId,
  onChanged: (value, label) {
    selectedEmployeeId = value;
  },
)
```

### QImagePicker

For selecting an image from the gallery:

```dart
QImagePicker(
  label: "Photo",
  validator: Validator.required,
  value: imagePathVariable,
  onChanged: (value) {
    imagePathVariable = value;
  },
)
```

### QFilePicker

For selecting any type of file:

```dart
QFilePicker(
  label: "Attachment",
  validator: Validator.required,
  value: filePathVariable,
  onChanged: (value) {
    filePathVariable = value;
  },
)
```

### QCameraPicker

For capturing an image using the device camera:

```dart
QCameraPicker(
  label: "Photo",
  validator: Validator.required,
  value: cameraImagePath,
  onChanged: (value) {
    cameraImagePath = value;
  },
)
```

### QMemoField

For multi-line text input:

```dart
QMemoField(
  label: "Address",
  validator: Validator.required,
  value: addressText,
  onChanged: (value) {
    addressText = value;
  },
)
```

### QLocationPicker

For selecting geographic locations:

```dart
QLocationPicker(
  label: "Location",
  latitude: -6.218481065235333,  // Initial latitude
  longitude: 106.80254435779423, // Initial longitude
  onChanged: (latitude, longitude, address) {
    // Store the selected coordinates and address
    locationLatitude = latitude;
    locationLongitude = longitude;
    locationAddress = address;
  },
)
```

### QRatingField

For collecting rating input (e.g., star ratings):

```dart
QRatingField(
  label: "Rating",
  value: 3, // Initial rating value (1-5)
  onChanged: (value) {
    ratingValue = value;
  },
)
```

### QCategoryPicker

For selecting a category from predefined options:

```dart
QCategoryPicker(
  label: "Category",
  items: const [
    {
      "label": "Main Course",
      "value": "Main Course",
    },
    {
      "label": "Drink",
      "value": "Drink",
    },
    {
      "label": "Snack",
      "value": "Snack",
    },
    {
      "label": "Dessert",
      "value": "Dessert",
    }
  ],
  value: selectedCategory, // Initial selection
  validator: Validator.required,
  onChanged: (index, label, value, item) {
    selectedCategory = value;
  },
)
```

## Navigation Widgets

### QNavigation

Creates a navigation structure for your application:

```dart
QNavigation(
  mode: QNavigationMode.nav0, // Navigation style/mode
  menus: [
    NavigationMenu(
      icon: Icons.dashboard,
      label: "Dashboard",
      view: DashboardView(),
    ),
    NavigationMenu(
      icon: Icons.list,
      label: "Order",
      view: OrderView(),
    ),
    NavigationMenu(
      icon: Icons.favorite,
      label: "Favorite",
      view: FavoriteView(),
    ),
    NavigationMenu(
      icon: Icons.person,
      label: "Profile",
      view: ProfileView(),
    ),
  ],
)
```

> **Note**: TabBar is acceptable, but avoid using BottomNavigationBar.

## Validation

Form validation is handled using the `Validator` class. Common validations:

- `Validator.required`: Ensures field is not empty
- `Validator.email`: Validates email format
- `Validator.atLeastOneitem`: Ensures at least one item is selected in multi-selection fields

Use with a Form widget and formKey:

```dart
final formKey = GlobalKey<FormState>();

// In build method
Form(
  key: formKey,
  child: Column(
    children: [
      // Form fields with validators
    ],
  ),
)

// Validate before submission
if (formKey.currentState!.validate()) {
  // Proceed with submission
}
```

## Important Guidelines

1. Always prefer reusable components from the ReuseKit framework
2. Use solid button variants only, avoid outlined styles
3. Never use TextEditingController, use value property and onChanged handlers
4. For page loading, use boolean states and CircularProgressIndicator, not showLoading()/hideLoading()
5. Avoid ListTile widgets; use Card or custom widgets instead
6. Don't use BottomNavigationBar (TabBar is acceptable)
7. Use `.withAlpha(value)` instead of `.withOpacity(value)` for transparency