import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tentang Kami'),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/background.png',
            fit: BoxFit.cover,
          ),
          Center(
            child: SingleChildScrollView(
              child: Card(
                color: Colors.white.withOpacity(0.85),
                margin: const EdgeInsets.symmetric(horizontal: 20),
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Prominent photo
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset('assets/images/FOTO KUU.jpg',
                            height: 180, fit: BoxFit.cover),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'd’ÉTOILE WEAR',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Chez ÉTOILE WEAR, nous croyons que la mode est plus qu’un vêtement — c’est une expression de lumière intérieure. Inspirée par le mot étoile, notre marque célèbre la beauté de l’authenticité et le courage d’être soi-même. Chaque collection naît d’un équilibre entre minimalisme, créativité et mouvement, reflétant l’harmonie subtile entre élégance et liberté. Nous ne suivons pas les tendances : nous traçons notre propre voie, guidés par l’éclat de ceux qui osent briller différemment..',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                      const SizedBox(height: 16),
                      const Divider(),
                      const SizedBox(height: 8),
                      const ListTile(
                        leading: Icon(Icons.email, color: Colors.pinkAccent),
                        title: Text('Email'),
                        subtitle: Text('24111814108@mhs.unesa.ac.id'),
                      ),
                      ListTile(
                        leading:
                            const Icon(Icons.phone, color: Colors.pinkAccent),
                        title: const Text('Telepon'),
                        subtitle: const Text('+62 857 8571 4197'),
                        onTap: () async {
                          // Open WhatsApp chat using wa.me with international number (no +, no spaces)
                          const phone = '6285785714197';
                          final uri = Uri.parse('https://wa.me/$phone');
                          if (await canLaunchUrl(uri)) {
                            await launchUrl(uri,
                                mode: LaunchMode.externalApplication);
                          } else {
                            // If can't open, show a simple SnackBar as fallback
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text('Tidak dapat membuka WhatsApp')),
                            );
                          }
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.language,
                            color: Colors.pinkAccent),
                        title: const Text('Github'),
                        subtitle: const Text('https://github.com/SultanTnn'),
                        onTap: () async {
                          final url = Uri.parse('https://github.com/SultanTnn');
                          if (await canLaunchUrl(url)) {
                            await launchUrl(url,
                                mode: LaunchMode.externalApplication);
                          }
                        },
                      ),
                      const SizedBox(height: 8),
                      const Divider(),
                      const SizedBox(height: 8),
                      const Text('Team',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      const ListTile(
                        leading: CircleAvatar(child: Text('SR')),
                        title: Text('Sultan Raffi'),
                        subtitle: Text('Founder & Designer'),
                      ),
                      const ListTile(
                        leading: CircleAvatar(child: Text('IN')),
                        title: Text('Sultan Raff1'),
                        subtitle: Text('Support'),
                      ),
                      const SizedBox(height: 12),
                      const Text('Versi aplikasi 1.0.0',
                          style: TextStyle(color: Colors.black54)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
