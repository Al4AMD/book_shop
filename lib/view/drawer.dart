import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './fontprovider.dart';
import './themeprovider.dart';

class AppDrawer extends StatelessWidget {
  AppDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = Provider.of<ThemeProvider>(context).isDark
        ? Color(0xFF062C65)
        : Color(0xFFE7B4B4);
    bool theme = context.watch<ThemeProvider>().isDark;
    String selectedFont = context.watch<FontProvider>().selectedFont;

    return Drawer(
      backgroundColor: backgroundColor,
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Row(
                children: [
                  Icon(
                    Icons.menu,
                    color: theme ? Colors.white : Colors.black,
                    size: 28,
                  ),
                  SizedBox(width: 25),
                  Text(
                    "Drawer",
                    style: TextStyle(
                      fontFamily: selectedFont,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: theme ? Colors.white : Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 5),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                theme ? 'Light Mode' : 'Dark Mode',
                style: TextStyle(
                  fontFamily: selectedFont,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: theme ? Colors.white : Colors.black,
                ),
              ),
              Switch(
                value: theme,
                onChanged: (value) {
                  context.read<ThemeProvider>().changeTheme();
                },
                activeColor: theme ? Color(0xFFE7B4B4) : Color(0xFF062C65),
                inactiveTrackColor: Color(0xFF749FEC),
                inactiveThumbColor: Color(0xFF062C65),
              ),
            ],
          ),
          const SizedBox(height: 22),
          _buildFontItem(context, "  Font 1", "Vazir", theme, selectedFont),
          const SizedBox(height: 12),
          _buildFontItem(
              context, "  Font 2", "Ordibehesht", theme, selectedFont),
          const SizedBox(height: 12),
          _buildFontItem(context, "  Font 3", "Samim", theme, selectedFont),
          const SizedBox(height: 12),
          _buildFontItem(context, "  Font 4", "Sahel", theme, selectedFont),

          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Image.asset(
              'assets/images/library.png',
              height: 250,
              width: double.infinity,
              fit: BoxFit.fitWidth,
            ),
          ),

          // Button below the image
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/mypurchases');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: theme ? Colors.white : Colors.black,
                padding: EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                "My Purchases",
                style: TextStyle(
                  fontFamily: selectedFont,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: theme ? Colors.black : Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFontItem(BuildContext context, String fontName,
      String fontFamily, bool isDarkTheme, String selectedFont) {
    return MouseRegion(
      cursor: SystemMouseCursors.none,
      child: GestureDetector(
        onTap: () {
          context.read<FontProvider>().setFont(fontFamily);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '$fontName selected',
                style: TextStyle(fontFamily: fontFamily),
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 17.0),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 17, horizontal: 10),
            decoration: BoxDecoration(
              color: isDarkTheme ? Color(0xFF424242) : Color(0xFFF0F0F0),
              borderRadius: BorderRadius.circular(50),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  fontName,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDarkTheme ? Colors.white : Colors.black,
                  ),
                ),
                Text(
                  "Sample Text  ",
                  style: TextStyle(
                    fontFamily: fontFamily,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: isDarkTheme ? Colors.white : Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
