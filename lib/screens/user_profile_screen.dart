import 'package:flutter/material.dart';
import 'package:airbnb_app/models/user.dart';

class UserProfileScreen extends StatelessWidget {
  final UserModel user;

  UserProfileScreen({required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CircleAvatar(
                  radius: 70,
                  backgroundImage: NetworkImage(user.photoURL),
                  backgroundColor: Colors.grey[200],
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: Text(
                  user.displayName,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              SizedBox(height: 5),
              Center(
                child: Text(
                  user.email,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Divider(
                thickness: 1,
                color: Colors.grey[300],
              ),
              SizedBox(height: 20),
              _buildProfileDetail(
                "Role",
                user.role,
                icon: Icons.account_circle,
              ),
              SizedBox(height: 15),
              if (user.profession != null)
                _buildProfileDetail(
                  "Profession",
                  user.profession!,
                  icon: Icons.work,
                ),
              if (user.profession != null) SizedBox(height: 15),
              if (user.yearsOfHosting != null)
                _buildProfileDetail(
                  "Years of Hosting",
                  user.yearsOfHosting.toString(),
                  icon: Icons.calendar_today,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileDetail(String title, String value, {IconData? icon}) {
    return Row(
      children: [
        if (icon != null) Icon(icon, color: Colors.deepPurple, size: 24),
        SizedBox(width: 10),
        Text(
          "$title:",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
