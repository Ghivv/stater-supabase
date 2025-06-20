import 'package:flutter/material.dart';
import 'package:reusekit/core.dart';
import 'package:reusekit/service/invitation_service.dart';

class InvitationFormView extends StatefulWidget {
  final Map? item;
  const InvitationFormView({
    super.key,
    this.item,
  });

  @override
  State<InvitationFormView> createState() => _InvitationFormViewState();
}

class _InvitationFormViewState extends State<InvitationFormView> {
  final formKey = GlobalKey<FormState>();
  bool loading = false;
  bool isVip = false;

  String? invitationId;
  String? guestName;
  String? seat;
  String? phone;
  String? email;

  @override
  void initState() {
    super.initState();
    if (widget.item != null) {
      invitationId = widget.item!["invitation_id"];
      guestName = widget.item!["guest_name"];
      seat = widget.item!["seat"];
      phone = widget.item!["phone"];
      email = widget.item!["email"];
      isVip = widget.item!["is_vip"] ?? false;
    }
  }

  save() async {
    if (!formKey.currentState!.validate()) return;

    loading = true;
    setState(() {});

    try {
      Map item = {
        "invitation_id": invitationId,
        "guest_name": guestName,
        "seat": seat,
        "phone": phone,
        "email": email,
        "is_vip": isVip,
      };

      if (widget.item == null) {
        await InvitationService.create(item);
        ss("Data berhasil disimpan");
      } else {
        item["id"] = widget.item!["id"];
        await InvitationService.update(item);
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
          widget.item == null ? "Create Invitation" : "Update Invitation",
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
                  label: "Invitation ID",
                  validator: Validator.required,
                  value: invitationId,
                  onChanged: (value) {
                    invitationId = value;
                  },
                ),
                QTextField(
                  label: "Guest Name",
                  validator: Validator.required,
                  value: guestName,
                  onChanged: (value) {
                    guestName = value;
                  },
                ),
                QTextField(
                  label: "Seat Number",
                  validator: Validator.required,
                  value: seat,
                  onChanged: (value) {
                    seat = value;
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
                  label: "Email",
                  validator: Validator.email,
                  value: email,
                  onChanged: (value) {
                    email = value;
                  },
                ),
                QSwitch(
                  label: "VIP Status",
                  items: [
                    {
                      "label": "VIP",
                      "value": true,
                      "checked": isVip,
                    }
                  ],
                  value: [
                    if (isVip) {"label": "VIP", "value": true, "checked": true}
                  ],
                  onChanged: (values, ids) {
                    setState(() {
                      isVip = values.isNotEmpty;
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
