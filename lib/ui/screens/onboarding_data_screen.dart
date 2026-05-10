import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OnboardingDataScreen extends StatefulWidget {
  const OnboardingDataScreen({super.key});

  @override
  State<OnboardingDataScreen> createState() => _OnboardingDataScreenState();
}

class _OnboardingDataScreenState extends State<OnboardingDataScreen> {
  double _progress = 0.1;
  String _status = "Initializing workspace...";

  @override
  void initState() {
    super.initState();
    _generateTestData();
  }

  Future<void> _generateTestData() async {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;
    
    try {
      final profileData = await supabase
          .from('profiles')
          .select('tenant_id')
          .eq('id', user!.id)
          .single();
      
      final String tenantId = profileData['tenant_id'];

      setState(() { _status = "Setting up catalogs..."; _progress = 0.3; });
      final catalog = await supabase.from('catalogs').insert({
        'tenant_id': tenantId,
        'catalog_name': 'General Inventory', 
      }).select().single();

      setState(() { _status = "Generating sample products..."; _progress = 0.6; });
      await supabase.from('products').insert([
        {
          'tenant_id': tenantId,
          'catalog_id': catalog['id'],
          'name': 'Chocolate Bar', 
          'description': 'Milk chocolate bar',
          'price': 0.80
        },
        {
          'tenant_id': tenantId,
          'catalog_id': catalog['id'],
          'name': 'Floor Cleaner', 
          'description': 'Pine floor cleaner',
          'price': 3.00
        },
      ]);

      await supabase.auth.updateUser(
        UserAttributes(data: {'onboarding_complete': true}),
      );

      setState(() { _progress = 1.0; _status = "Ready!"; });
      
      if (mounted) {
        await Future.delayed(const Duration(milliseconds: 500));
        Navigator.pushReplacementNamed(context, '/dashboard');
      }
    } catch (e) {
      debugPrint("Data Population Error: $e");
      setState(() { _status = "Setup error. Check database columns."; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 400,
          padding: const EdgeInsets.all(40),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 20)],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Populating your workspace", 
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 30),
              LinearProgressIndicator(value: _progress, minHeight: 8),
              const SizedBox(height: 20),
              Text(_status, style: TextStyle(color: Colors.grey[600])),
            ],
          ),
        ),
      ),
    );
  }
}