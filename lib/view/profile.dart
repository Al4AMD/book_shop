import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:libraryproject/apis/user_Api/userApis.dart';
import 'package:libraryproject/models/user/userModel.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? user;
  bool isLoading = true;
  final UserApi api = UserApi();

  void getUserInfo() async {
    final data = await api.getUserInfo();
    setState(() {
      user = User.fromJson(data);
    });
    log("User: ${user?.toJson().toString()}");
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        centerTitle: true,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  CircleAvatar(
                    minRadius: 10,
                    maxRadius: 50,
                    backgroundImage: NetworkImage(
                        'http://172.20.10.3:3000/api/v1${user!.profilePicture!.path}'),
                    // Placeholder for profile image
                    backgroundColor: Colors.grey[300],
                  ),
                  SizedBox(height: 16),
                  ProfileField(label: 'Username', value: user!.username),
                  ProfileField(label: 'Email', value: user!.email),
                  ProfileField(label: 'Full Name', value: user!.fullName),
                  ProfileField(
                      label: 'Phone', value: '+98${user!.phoneNumber}'),
                  ProfileField(label: 'Address', value: user!.address),
                  ProfileField(
                      label: 'BirthDate',
                      value:
                          "${user!.birth?.year}-${user!.birth?.month}-${user!.birth?.day}"),
                  SizedBox(height: 20),
                  // ElevatedButton(
                  //   onPressed: () {
                  //     Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //           builder: (context) => EditProfilePage()),
                  //     );
                  //   },
                  //   child: Text('Edit Profile'),
                  // ),
                ],
              ),
            ),
    );
  }
}

class ProfileField extends StatelessWidget {
  final String label;
  final String value;

  const ProfileField({
    Key? key,
    required this.label,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
