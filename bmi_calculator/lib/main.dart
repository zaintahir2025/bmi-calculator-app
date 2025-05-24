import 'package:flutter/material.dart';

void main() {
  runApp(const BMICalculatorApp());
}

class BMICalculatorApp extends StatelessWidget {
  const BMICalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF00695C),
          primary: const Color(0xFF00695C),
          secondary: const Color(0xFF26A69A),
          background: const Color(0xFFF1F1F1),
        ),
        textTheme: const TextTheme(
          headlineMedium: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            fontFamily: 'Roboto',
            color: Color(0xFF004D40),
          ),
          bodyLarge: TextStyle(
            fontSize: 20,
            fontFamily: 'Roboto',
            color: Color(0xFF004D40),
          ),
          bodyMedium: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            fontFamily: 'Roboto',
            color: Color(0xFF004D40),
          ),
        ),
      ),
      home: const BMICalculatorScreen(),
    );
  }
}

class BMICalculatorScreen extends StatefulWidget {
  const BMICalculatorScreen({super.key});

  @override
  State<BMICalculatorScreen> createState() => _BMICalculatorScreenState();
}

class _BMICalculatorScreenState extends State<BMICalculatorScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();

  String _bmiResult = '';
  String _bmiCategory = '';
  Color _bmiCategoryColor = Colors.black;
  bool _showResult = false;

  late AnimationController _buttonAnimationController;
  late Animation<double> _buttonScaleAnimation;

  @override
  void initState() {
    super.initState();
    _buttonAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _buttonScaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(
        parent: _buttonAnimationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  void _calculateBMI() {
    if (!_formKey.currentState!.validate()) return;

    _buttonAnimationController.forward().then((_) {
      _buttonAnimationController.reverse();
    });

    final double weight = double.parse(_weightController.text);
    final double height = double.parse(_heightController.text);
    final bmi = weight / ((height / 100) * (height / 100));
    final result = _getBMICategory(bmi);

    setState(() {
      _bmiResult = bmi.toStringAsFixed(1);
      _bmiCategory = result['category'];
      _bmiCategoryColor = result['color'];
      _showResult = true;
    });
  }

  void _resetFields() {
    setState(() {
      _weightController.clear();
      _heightController.clear();
      _bmiResult = '';
      _bmiCategory = '';
      _bmiCategoryColor = Colors.black;
      _showResult = false;
    });
  }

  Map<String, dynamic> _getBMICategory(double bmi) {
    if (bmi < 18.5) {
      return {'category': 'Underweight', 'color': Colors.orange};
    } else if (bmi < 25) {
      return {'category': 'Normal', 'color': Colors.green};
    } else if (bmi < 30) {
      return {'category': 'Overweight', 'color': Colors.amber[800]};
    } else {
      return {'category': 'Obese', 'color': Colors.red};
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('BMI Calculator'),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
                child: Card(
                  elevation: 12.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.health_and_safety,
                              size: 60, color: Color(0xFF00695C)),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: _weightController,
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            decoration: InputDecoration(
                              labelText: 'Weight (kg)',
                              prefixIcon: const Icon(Icons.fitness_center),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            validator: (value) {
                              final num? val = num.tryParse(value ?? '');
                              if (val == null || val <= 0) {
                                return 'Enter valid weight';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: _heightController,
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            decoration: InputDecoration(
                              labelText: 'Height (cm)',
                              prefixIcon: const Icon(Icons.height),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            validator: (value) {
                              final num? val = num.tryParse(value ?? '');
                              if (val == null || val <= 0) {
                                return 'Enter valid height';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 25),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ScaleTransition(
                                scale: _buttonScaleAnimation,
                                child: ElevatedButton(
                                  onPressed: _calculateBMI,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: theme.colorScheme.primary,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 30.0, vertical: 18.0),
                                  ),
                                  child: const Text(
                                    'Calculate BMI',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: _resetFields,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey[600],
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30.0, vertical: 18.0),
                                ),
                                child: const Text(
                                  'Reset',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),
                          AnimatedOpacity(
                            opacity: _showResult ? 1.0 : 0.0,
                            duration: const Duration(milliseconds: 500),
                            child: Column(
                              children: [
                                Text(
                                  'BMI: $_bmiResult',
                                  style: theme.textTheme.headlineMedium,
                                  semanticsLabel:
                                      'Your Body Mass Index is $_bmiResult',
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'Category: $_bmiCategory',
                                  style: TextStyle(
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.w600,
                                    color: _bmiCategoryColor,
                                  ),
                                  semanticsLabel: 'Category is $_bmiCategory',
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _weightController.dispose();
    _heightController.dispose();
    _buttonAnimationController.dispose();
    super.dispose();
  }
}
