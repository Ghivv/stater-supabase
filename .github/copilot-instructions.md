# Flutter Development Guidelines

U can find our reuseable widget docs at 
lib/core/widget/docs.dart

## Code Architecture
lib
  model
    user.dart
  service
    auth_service.dart
  presentation
    login_view.dart

## Design Principles
1. Always create unique, elegant, premium UIs
2. Avoid animations entirely
3. Do not use SliverWidgets
4. Add multiple sections to pages when appropriate
5. Avoid QCard components for now
6. Never use ListTile widgets
7. Don't implement BottomNavigationBar (TabBar is acceptable if you provide content for each tab)
8. In newer Flutter versions, use `.withAlpha(value)` instead of `.withOpacity(value)`
9. Prevent UI overflow and ensure comfortable display on mobile screens

## Core Components
- Use components from `lib/core/widget/docs.dart`: navigation, contextless utilities, snackbar, button, form widgets
- Implement ReuseKit framework components throughout the project
- Follow the established theme configuration
- Use ReuseKit form components (QTextField, QImagePicker, etc.)

## Form Handling
- **TextFields**: 
    - Use `onChanged` event to capture values
    - Set initial values with the `value:` property
    - Do NOT use TextEditingController anywhere
- **Buttons**:
    - Always use solid QButton variants
    - Avoid outlined button styles

## Styling & Layout
- Use `.withAlpha(value)` instead of `.withOpacity(value)`
- Prefer the `spacing` property in Column/Row over multiple SizedBox widgets
- Create visually balanced layouts with appropriate padding and margins
- Use consistent spacing throughout the application

## Loading States
- Handle page loading manually with a boolean state variable and CircularProgressIndicator
- Only use showLoading/hideLoading when a button click requires loading
- Never use showLoading/hideLoading for entire page loading, for example when getting data from API at the beginning of the page, please use bool loading state and CircularProgressIndicator instead

## Naming & Architecture
- Follow view naming convention: `XxxView` (e.g., LoginView, ProductListView)
- Use the same page for both edit and create operations
- Do not use `part of` or `part` directives
- Views do not need explicit imports as everything is available in core.dart

## IMport
jika ada service atau model, itu tidak perlu du import lagi,
karena sudah ada di core.dart

## Validation
validation menggunakan class Valdiator, dan di impplementasikan dengan formKey,
Jadi tidak perlu diberi IF IF IF lagi
lib\core\util\validator\validator.dart

## Reuseable Widget
semua widget yang di awali Q, misalnya QTextField, QButton, QCard, dll adalah widget yang reusable yang sudah saya buat,
dan cukup mengimport core.dart saja, dokumentasi pengunaannya ada di:
.github/widget-docs.md

Jika menggunakan reuseable widget,
Jangan gunakan argument yang tidak ada di dokumentasi,

Untuk mengatur initialValue, gunakan property value:
Contoh:
Q...(
  ...
  value: _email,
 ...
)

* Semua reuseable widget untuk form wajib di isi event
onChanged, tidak boleh di null kan.


### Aturan untuk Reuseable Widget yang saya buat:
* Tidak perlu mendefinisikan maxLength atau maxLines.
* Tidak perlu mendefinisikan keyboardType:
* Tidak perlu mengatur suffixIcon
* Tidak perlu mengatur labelColor pada QButton, QTextField dan lainnya
* Kalau pakai colorset seperti primaryColor, mestinya widget-nya tidak di definsiikan dengan const
* Jangan mengatur height dari QButton
* Jangan gunakan property selain yang saya contohkan di dokumentasi reuseable widget

### Dismissible
gunakan rowAction untuk dismissible, dan jangan gunakan dismissible langsung,
rowAction(
    onDismiss: () {},
    child: ListTile(...),
) 


### REQUIRED
Setiap membuat halaman baru wajib mengimport kedua hal ini:  
import 'package:flutter/material.dart';
import 'package:reusekit/core.dart';

### STATE MANAGEMENT
* Saya prefer menggunakan kode seperti ini(contoh):
loading = true;
setState(() {});
Daripada:
setState(() {
  loading = true;
});

### Design
- By default ketika saya membuat halaman itu diperuntukkan untuk mobile, kecuali saya meminta versi tablet atau desktop-nya
- Kalo perlu gambar dummy, gunakan placehold.co


### SUPABASE CONFIG (if we use supabase as backend)
#### SQL FORMAT
- Postgresql Supabase

#### schema.sql
- Gunakan schema.sql untuk membuat schema database, formatnya:
- Hanya boleh query CREATE DAN DROP
- Tidak boleh ada query CREATE INDEX, dan INSERT
```
CASCADE DROP ...
CREATE TABLE ...

CASCADE DROP ...
CREATE TABLE ...
```
- Sebelum CREATE TABLE, harus ada DROP TABLE DULU
#### schema_seeder.sql
- Hanya berisi query INSERT

### Convert data type
String to Timeofday
TimeOfDay = "10:00".timeOfDay;


### Snacbar
##### SUCCESS
ss("Data berhasil disimpan");
##### ERROR
se("Data gagal disimpan");
##### WARNING
sw("Data sudah ada sebelumnya");
##### INFO
si("Data sudah diperbarui");

### Date Type Format
double to money
(double.tryParse("{value}") ?? 0).currency;

### Confirm Dialog
bool isConfirmed  = await confirm("Apakah Anda yakin ingin menghapus data ini?");

### Navigation
await to(const LoginView());
await offAll(const LoginView());
back(); //no argument




### Others
- TextStyle tidak perlu didefinisikan dengan const

Contoh switch yang benar:
```
QSwitch(
    label: "Status Aktif",
    items: [
        {
        "label": "Aktif",
        "value": true,
        "checked": isActive,
        }
    ],
    value: [if (isActive) {"label": "Aktif", "value": true, "checked": true}],
    onChanged: (values, ids) {
        setState(() {
        isActive = values.isNotEmpty;
        });
    },
)
```

Contoh dropdown yang benar:
```
QDropdownField(
    label: "Filter Semester",
    items: semesterItems,
    value: selectedSemester,
    onChanged: (value, label) {
    selectedSemester = value;
    _filterKelas();
    },
)
```

### Import Rules
- Tidak perlu mengimport class model.dart atau service.dart ketika dibutuhkan


### Views
- Ketika membuat View,dan ternyata ada viewlain yang belum tersedia, jangan dibuat di file yang sama ya.
Saya akan membuatkan view itu nanti.

- Ketika membuat Form yang di dalamnya ada Column atau Row, gunakan spacing: spMd


### Catch-Exception
- Saya tidak ingin menggunakan finally sama sekali, jadi jangan gunakan finally