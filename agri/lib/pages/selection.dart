import 'package:agri/pages/consumer.dart';
import 'package:agri/pages/farmer.dart';
import 'package:agri/pages/public_profile.dart';
import 'package:flutter/material.dart';

class SelectionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Select User Type'),
      //   backgroundColor: const Color.fromARGB(255, 119, 228, 124), // Darker green shade for the AppBar
      // ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('assets/background.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.green.withOpacity(0.2),
              BlendMode.darken,
            ),
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _buildElevatedButton(
                  context: context,
                  label: 'Farmer',
                  color: Colors.green[800]!,
                  icon: Icons.agriculture,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const FarmerPage()),
                    );
                  },
                ),
                const SizedBox(height: 20),
                _buildElevatedButton(
                  context: context,
                  label: 'Consumer',
                  color: Colors.green[800]!,
                  icon: Icons.person,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ConsumerPage()),
                    );
                  },
                ),
                  const SizedBox(height: 20),
                _buildElevatedButton(
                  context: context,
                  label: 'Public',
                  color: Colors.green[800]!,
                  icon: Icons.public,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>  PublicProfilePage()),
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

 Widget _buildElevatedButton({
  required BuildContext context,
  required String label,
  required Color color,
  required IconData icon,
  required VoidCallback onPressed,
}) {
  return SizedBox(
    width: 200, // Set a fixed width for the buttons
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white, backgroundColor: color, // Text color
        padding: const EdgeInsets.symmetric(vertical: 20), // Adjusted padding to fit the fixed width
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 10,
        shadowColor: Colors.black45,
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center, // Center the content within the fixed width
        children: [
          Icon(icon, size: 28),
          const SizedBox(width: 10),
          Text(
            label,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    ),
  );
}

}
