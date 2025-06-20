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

  save() async {
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
      appBar: AppBar(
        title: Text(
          widget.item == null ? "Add Student" : "Update Student",
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: QButton(
              label: "Save",
              icon: Icons.save,
              onPressed: () => save(),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                QTextField(
                  label: "Student ID",
                  validator: Validator.required,
                  value: studentId,
                  onChanged: (value) {
                    studentId = value;
                  },
                ),
                QTextField(
                  label: "Name",
                  validator: Validator.required,
                  value: name,
                  onChanged: (value) {
                    name = value;
                  },
                ),
                QTextField(
                  label: "Email",
                  validator: Validator.email,
                  value: email,
                  onChanged: (value) {
                    email = value;
                  },
                ),
                QTextField(
                  label: "Phone",
                  validator: Validator.required,
                  value: phone,
                  onChanged: (value) {
                    phone = value;
                  },
                ),
                QTextField(
                  label: "Address",
                  validator: Validator.required,
                  value: address,
                  onChanged: (value) {
                    address = value;
                  },
                ),
                QSwitch(
                  label: "Status",
                  items: [
                    {
                      "label": "Active",
                      "value": true,
                      "checked": isActive,
                    }
                  ],
                  value: [
                    if (isActive)
                      {"label": "Active", "value": true, "checked": true}
                  ],
                  onChanged: (values, ids) {
                    setState(() {
                      isActive = values.isNotEmpty;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
