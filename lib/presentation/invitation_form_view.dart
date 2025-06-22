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

  Future<void> save() async {
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
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(
          widget.item == null ? "Create Invitation" : "Update Invitation",
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
                                Icons.card_membership_rounded,
                                color: Theme.of(context).primaryColor,
                                size: 24,
                              ),
                            ),
                            SizedBox(width: 16),
                            Text(
                              "Invitation Details",
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
                          "Invitation ID",
                          invitationId,
                          Validator.required,
                          (value) => invitationId = value,
                          Icons.confirmation_number_rounded,
                        ),
                        const SizedBox(height: 20),
                        _buildFormField(
                          context,
                          "Guest Name",
                          guestName,
                          Validator.required,
                          (value) => guestName = value,
                          Icons.person_rounded,
                        ),
                        const SizedBox(height: 20),
                        _buildFormField(
                          context,
                          "Seat Number",
                          seat,
                          Validator.required,
                          (value) => seat = value,
                          Icons.event_seat_rounded,
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
                          "Email",
                          email,
                          Validator.email,
                          (value) => email = value,
                          Icons.email_rounded,
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
                                  color: isVip ? Colors.amber.withOpacity(0.2) : Colors.grey.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.star_rounded,
                                  color: isVip ? Colors.amber : Colors.grey,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                "VIP Status",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Spacer(),
                              Switch(
                                value: isVip,
                                onChanged: (value) {
                                  setState(() {
                                    isVip = value;
                                  });
                                },
                                activeColor: Colors.amber,
                                activeTrackColor: Colors.amber.withOpacity(0.3),
                              ),
                              Text(
                                isVip ? "VIP" : "Regular",
                                style: TextStyle(
                                  color: isVip ? Colors.amber.shade700 : Colors.grey,
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
    IconData icon,
  ) {
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
        style: TextStyle(fontSize: 16),
      ),
    );
  }
}
