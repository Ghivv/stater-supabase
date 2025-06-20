import 'package:flutter/material.dart';
import 'package:reusekit/core.dart';
import 'package:reusekit/presentation/home_view.dart';
import 'package:reusekit/presentation/profile_view.dart';
import 'package:reusekit/presentation/student_form_view.dart';
import 'package:reusekit/presentation/invitation_form_view.dart';
import 'package:reusekit/service/student_service.dart';
import 'package:reusekit/service/invitation_service.dart';

class MainNavigationView extends StatefulWidget {
  const MainNavigationView({super.key});

  @override
  State<MainNavigationView> createState() => _MainNavigationViewState();
}

class _MainNavigationViewState extends State<MainNavigationView> {
  List<Map> students = [];
  List<Map> invitations = [];
  bool studentsLoading = false;
  bool invitationsLoading = false;
  String? studentSearch;
  String? invitationSearch;

  @override
  void initState() {
    super.initState();
    loadStudents();
    loadInvitations();
  }

  Future<void> loadStudents() async {
    studentsLoading = true;
    setState(() {});

    try {
      students = await StudentService.getStudents();
      if (studentSearch != null) {
        students = students.where((student) {
          return student["name"]
                  .toString()
                  .toLowerCase()
                  .contains(studentSearch!.toLowerCase()) ||
              student["student_id"]
                  .toString()
                  .toLowerCase()
                  .contains(studentSearch!.toLowerCase());
        }).toList();
      }
    } catch (_) {}

    studentsLoading = false;
    setState(() {});
  }

  Future<void> loadInvitations() async {
    invitationsLoading = true;
    setState(() {});

    try {
      invitations = await InvitationService.getInvitations();
      if (invitationSearch != null) {
        invitations = invitations.where((invitation) {
          return invitation["guest_name"]
                  .toString()
                  .toLowerCase()
                  .contains(invitationSearch!.toLowerCase()) ||
              invitation["invitation_id"]
                  .toString()
                  .toLowerCase()
                  .contains(invitationSearch!.toLowerCase());
        }).toList();
      }
    } catch (_) {}

    invitationsLoading = false;
    setState(() {});
  }

  Future<void> deleteStudent(Map student) async {
    bool confirmed =
        await confirm("Apakah anda yakin ingin menghapus data ini?");
    if (!confirmed) return;

    try {
      await StudentService.delete(student["id"]);
      ss("Data berhasil dihapus");
      loadStudents();
    } catch (_) {
      se("Gagal menghapus data");
    }
  }

  Future<void> deleteInvitation(Map invitation) async {
    bool confirmed =
        await confirm("Apakah anda yakin ingin menghapus data ini?");
    if (!confirmed) return;

    try {
      await InvitationService.delete(invitation["id"]);
      ss("Data berhasil dihapus");
      loadInvitations();
    } catch (_) {
      se("Gagal menghapus data");
    }
  }

  @override
  Widget build(BuildContext context) {
    return QNavigation(
      mode: QNavigationMode.nav0,
      menus: [
        NavigationMenu(
          icon: Icons.dashboard,
          label: "Dashboard",
          view: const HomeView(),
        ),
        NavigationMenu(
          icon: Icons.school,
          label: "Students",
          view: Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "Student Management",
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                    const Spacer(),
                    QButton(
                      label: "Add Student",
                      icon: Icons.add,
                      onPressed: () async {
                        await to(const StudentFormView());
                        loadStudents();
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                QTextField(
                  label: "Search students...",
                  prefixIcon: Icons.search,
                  value: studentSearch,
                  onChanged: (value) {
                    studentSearch = value;
                    loadStudents();
                  },
                ),
                const SizedBox(height: 20.0),
                if (studentsLoading)
                  const Center(child: CircularProgressIndicator())
                else
                  Expanded(
                    child: ListView.builder(
                      itemCount: students.length,
                      itemBuilder: (context, index) {
                        final student = students[index];
                        return rowAction(
                          onDismiss: () => deleteStudent(student),
                          child: Card(
                            margin: const EdgeInsets.only(bottom: 10.0),
                            child: InkWell(
                              onTap: () async {
                                await to(StudentFormView(item: student));
                                loadStudents();
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      student["name"],
                                      style: const TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8.0),
                                    Text(
                                      "Student ID: ${student["student_id"]}",
                                      style: const TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                    const SizedBox(height: 4.0),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0,
                                        vertical: 4.0,
                                      ),
                                      decoration: BoxDecoration(
                                        color: student["is_active"] == true
                                            ? Colors.green.withAlpha(30)
                                            : Colors.red.withAlpha(30),
                                        borderRadius:
                                            BorderRadius.circular(4.0),
                                      ),
                                      child: Text(
                                        student["is_active"] == true
                                            ? "Active"
                                            : "Inactive",
                                        style: TextStyle(
                                          color: student["is_active"] == true
                                              ? Colors.green.withAlpha(200)
                                              : Colors.red.withAlpha(200),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        ),
        NavigationMenu(
          icon: Icons.card_giftcard,
          label: "Invitations",
          view: Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "Graduation Invitations",
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                    const Spacer(),
                    QButton(
                      label: "Create Invitation",
                      icon: Icons.add,
                      onPressed: () async {
                        await to(const InvitationFormView());
                        loadInvitations();
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                Row(
                  children: [
                    Expanded(
                      child: QTextField(
                        label: "Search invitations...",
                        prefixIcon: Icons.search,
                        value: invitationSearch,
                        onChanged: (value) {
                          invitationSearch = value;
                          loadInvitations();
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                if (invitationsLoading)
                  const Center(child: CircularProgressIndicator())
                else
                  Expanded(
                    child: ListView.builder(
                      itemCount: invitations.length,
                      itemBuilder: (context, index) {
                        final invitation = invitations[index];
                        return rowAction(
                          onDismiss: () => deleteInvitation(invitation),
                          child: Card(
                            margin: const EdgeInsets.only(bottom: 10.0),
                            child: InkWell(
                              onTap: () async {
                                await to(InvitationFormView(item: invitation));
                                loadInvitations();
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          invitation["invitation_id"],
                                          style: const TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const Spacer(),
                                        if (invitation["is_vip"] == true)
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0,
                                              vertical: 4.0,
                                            ),
                                            decoration: BoxDecoration(
                                              color: primaryColor.withAlpha(30),
                                              borderRadius:
                                                  BorderRadius.circular(4.0),
                                            ),
                                            child: Text(
                                              "VIP",
                                              style: TextStyle(
                                                color:
                                                    primaryColor.withAlpha(200),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                    const SizedBox(height: 8.0),
                                    Text(
                                      invitation["guest_name"],
                                      style: const TextStyle(
                                        fontSize: 14.0,
                                      ),
                                    ),
                                    const SizedBox(height: 4.0),
                                    Text(
                                      "Seat: ${invitation["seat"]}",
                                      style: const TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        ),
        NavigationMenu(
          icon: Icons.person,
          label: "Profile",
          view: const ProfileView(),
        ),
      ],
    );
  }
}
