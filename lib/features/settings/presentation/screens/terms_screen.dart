import 'package:flutter/material.dart';
import 'package:ride_spot/theme/custom_colors.dart';

class TermsAndConditionsPage extends StatelessWidget {
  const TermsAndConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColor.lightpurple,
        iconTheme: IconThemeData(color: Colors.white),
        title: const Text(
          'Terms & Conditions',
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
Welcome to Rider Spot Admin! By using this app, you agree to comply with our Terms & Conditions.  

2. Eligibility  
• You must be an authorized admin of the Rider Spot platform.  
• You are responsible for maintaining the security of your account.  

3. Responsibilities  
• Ensure the accuracy of product listings and order details.  
• Handle customer orders and queries responsibly.  
• Prevent unauthorized data access or modifications.  

4. Prohibited Activities  
You agree NOT to:  
• Share unauthorized information.  
• Engage in fraudulent activities or misuse admin privileges.  
• Copy, modify, or distribute app data without permission.  

5. Intellectual Property  
All trademarks, logos, and software used in Rider Spot Admin belong to us. Unauthorized copying or modification is prohibited.  

6. Termination  
We reserve the right to terminate your access if you violate any terms.  

7. Limitation of Liability  
We are not responsible for:  
• Data entry errors or system downtimes.  
• Any losses caused by third-party actions.  

8. Updates to Terms  
These Terms may be updated from time to time, and you will be notified of any significant changes.  

For queries, contact: adilcp8590@gmail.com  
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
