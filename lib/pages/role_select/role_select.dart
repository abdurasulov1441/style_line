import 'package:flutter/material.dart';
import 'package:style_line/pages/client/home_page.dart';
import 'package:style_line/pages/role_select/model/role_card_model.dart';

class RoleSelectionPage extends StatefulWidget {
  const RoleSelectionPage({super.key});

  @override
  _RoleSelectionPageState createState() => _RoleSelectionPageState();
}

class _RoleSelectionPageState extends State<RoleSelectionPage> {
  int? selectedRole;

  void selectRole(int roleId) {
    setState(() {
      selectedRole = roleId;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rolingizni Tanlang'),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  RoleCard(
                    imagePath: 'assets/images/client.png',
                    label: 'Mijoz',
                    description:
                        'Goʻzallik xizmatlarini ko\'rish uchun tanlang.',
                    roleId: 1,
                    isSelected: selectedRole == 1,
                    onTap: () => selectRole(1),
                  ),
                  SizedBox(height: 20),
                  RoleCard(
                    imagePath: 'assets/images/stylist.png',
                    label: 'Stylist',
                    description:
                        'Sizning xizmatlaringizni boshqarish uchun tanlang.',
                    roleId: 2,
                    isSelected: selectedRole == 2,
                    onTap: () => selectRole(2),
                  ),
                  SizedBox(height: 20),
                  RoleCard(
                    imagePath: 'assets/images/create_salon.png',
                    label: 'Salon Yaratish',
                    description: 'O\'z saloningizni boshqarish uchun tanlang.',
                    roleId: 3,
                    isSelected: selectedRole == 3,
                    onTap: () => selectRole(3),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: selectedRole != null
                  ? () {
                      if (selectedRole == 1) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ClientHomePage(),
                          ),
                        );
                      } else if (selectedRole == 2) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StylistRegistrationPage(),
                          ),
                        );
                      } else if (selectedRole == 3) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CreateSalonPage(),
                          ),
                        );
                      }
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                padding: EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              child: Text('Davom eting'),
            ),
          ],
        ),
      ),
    );
  }
}

class StylistRegistrationPage extends StatelessWidget {
  const StylistRegistrationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stylist Registration'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Ismingizni kiriting',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                labelText: 'Xizmatlar sohasi (masalan, manikyur)',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                labelText: 'Oʻrtacha vaqt (daqiqa)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                labelText: 'Ish vaqti (masalan, 9:00 - 18:00)',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                labelText:
                    'Dam olish kunlari (masalan, yakshanba yoki qisqa shanba kuni)',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                labelText: 'Salon nomini kiriting yoki ID orqali qidiring',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text(
                          'Maʼlumotlar yuborildi! Oʻz profilingizni boshlang.')),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              child: Text('Boshlash'),
            ),
          ],
        ),
      ),
    );
  }
}

class CreateSalonPage extends StatefulWidget {
  const CreateSalonPage({super.key});

  @override
  _CreateSalonPageState createState() => _CreateSalonPageState();
}

class _CreateSalonPageState extends State<CreateSalonPage> {
  bool isAlsoStylist = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Salon'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Salon nomini kiriting',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                labelText: 'Salon manzilini kiriting',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                labelText: 'Salon rasmi (URL yoki yuklash)',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Siz ham stilistmisiz?'),
                Switch(
                  value: isAlsoStylist,
                  onChanged: (value) {
                    setState(() {
                      isAlsoStylist = value;
                    });
                  },
                ),
              ],
            ),
            if (isAlsoStylist) ...[
              SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Ismingizni kiriting',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Xizmatlar sohasi',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Oʻrtacha vaqt (daqiqa)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Ish vaqti (masalan, 9:00 - 18:00)',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Dam olish kunlari',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Salon muvaffaqiyatli yaratildi!')),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              child: Text('Yaratish'),
            ),
          ],
        ),
      ),
    );
  }
}
