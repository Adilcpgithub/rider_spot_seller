import 'package:flutter/material.dart';
import 'package:ride_spot/theme/custom_colors.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColor.lightpurple,
        iconTheme: IconThemeData(color: Colors.white),
        title: const Text(
          'Privacy Policy',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text(
            '''
Last Updated: 04/03/25  

1. Introduction  
Your privacy is important to us. This Privacy Policy explains how we collect, use, and protect your personal information when using Rider Spot Admin.  

2. Information We Collect  
• Admin Details: Name, email, phone number.  
• Business Data: Order details, customer interactions.  
• Device Information: IP address, app usage stats.  

3. How We Use Your Data  
We use your data to:  
• Manage and process orders and inventory.  
• Provide customer support and analytics.  
• Enhance security and prevent fraud.  

4. Data Sharing & Security  
• We do NOT sell or share your data except as required by law.  
• Your data is encrypted and securely stored.  

5. Your Rights  
You can:  
• Access, update, or delete your data.  
• Opt-out of marketing messages.  
• Request data deletion at any time.  

6. Updates to This Policy  
We may update this Privacy Policy periodically and notify you of significant changes.  

For privacy-related concerns, contact adilcp8590@gmail.com  
''',
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              height: 1.8,
            ),
          ),
        ),
      ),
    );
  }
}
