import 'package:flutter/material.dart';
import 'package:reusekit/core.dart';
import 'package:reusekit/service/student_service.dart';

class StudentFormView extends StatefulWidget {
  final Map? item;
  const StudentFormView({
    super.key,
    this.item,
  });

  @override
  State<StudentFormView> createState() => _StudentFormViewState();
}

class _StudentFormViewState extends State<StudentFormView> {
  final formKey = GlobalKey<FormState>();
  bool loading = false;
  bool isActive = true;

  String? studentId;
  String? name;
  String? email;
  String? phone;
  String? address;

  @override
  void initState() {
    super.initState();
    if (widget.item != null) {
      studentId = widget.item!["student_id"];
      name = widget.item!["name"];
      email = widget.item!["email"];
      phone = widget.item!["phone"];
      address = widget.item!["address"];
      isActive = widget.item!["is_active"] ?? true;
    }
  }

  Future<void> save() async {
    if (!formKey.currentState!.validate()) return;

    loading = true;
    setState(() {});

    try {
      Map item = {
        "student_id": studentId,
        "name": name,
        "email": email,
        "phone": phone,
        "address": address,
        "is_active": isActive,
      };

      if (widget.item == null) {
        await StudentService.create(item);
        ss("Data berhasil disimpan");
      } else {
        item["id"] = widget.item!["id"];
        await StudentService.update(item);
        ss("Data berhasil diperbarui");
      }

      back();
    } catch (e) {
      se("Terjadi kesalahan");
    }

    loading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(
          widget.item == null ? "Add Student" : "Update Student",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: ElevatedButton.icon(
              onPressed: loading ? null : () => save(),
              icon: loading 
                ? SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Icon(Icons.save_rounded, size: 20),
              label: Text(loading ? "Saving..." : "Save"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                elevation: 2,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Icons.school_rounded,
                                color: Theme.of(context).primaryColor,
                                size: 24,
                              ),
                            ),
                            SizedBox(width: 16),
                            Text(
                              "Student Information",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 24),
                        _buildFormField(
                          context,
                          "Student ID",
                          studentId,
                          Validator.required,
                          (value) => studentId = value,
                          Icons.badge_rounded,
                        ),
                        const SizedBox(height: 20),
                        _buildFormField(
                          context,
                          "Name",
                          name,
                          Validator.required,
                          (value) => name = value,
                          Icons.person_rounded,
                        ),
                        const SizedBox(height: 20),
                        _buildFormField(
                          context,
                          "Email",
                          email,
                          Validator.email,
                          (value) => email = value,
                          Icons.email_rounded,
                        ),
                        const SizedBox(height: 20),
                        _buildFormField(
                          context,
                          "Phone",
                          phone,
                          Validator.required,
                          (value) => phone = value,
                          Icons.phone_rounded,
                        ),
                        const SizedBox(height: 20),
                        _buildFormField(
                          context,
                          "Address",
                          address,
                          Validator.required,
                          (value) => address = value,
                          Icons.location_on_rounded,
                          maxLines: 2,
                        ),
                        const SizedBox(height: 24),
                        Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: isActive ? Colors.green.withOpacity(0.2) : Colors.grey.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  isActive ? Icons.check_circle_rounded : Icons.cancel_rounded,
                                  color: isActive ? Colors.green : Colors.grey,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                "Student Status",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Spacer(),
                              Switch(
                                value: isActive,
                                onChanged: (value) {
                                  setState(() {
                                    isActive = value;
                                  });
                                },
                                activeColor: Colors.green,
                                activeTrackColor: Colors.green.withOpacity(0.3),
                              ),
                              Text(
                                isActive ? "Active" : "Inactive",
                                style: TextStyle(
                                  color: isActive ? Colors.green.shade700 : Colors.grey,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormField(
    BuildContext context,
    String label,
    String? value,
    String? Function(String?)? validator,
    Function(String) onChanged,
    IconData icon, {
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: Theme.of(context).primaryColor,
              size: 20,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Theme.of(context).primaryColor,
              width: 2,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Colors.red,
              width: 1,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Colors.red,
              width: 2,
            ),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        ),
        initialValue: value,
        validator: validator,
        onChanged: onChanged,
        maxLines: maxLines,
        style: TextStyle(fontSize: 16),
      ),
    );
  }
}
