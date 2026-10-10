import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/coaching_profile.dart';
import '../../providers/user_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/progress_indicator.dart';
import 'goal_screen.dart';

class PersonalInfoScreen extends StatefulWidget {
  const PersonalInfoScreen({super.key});

  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _ageController = TextEditingController();

  final TextEditingController _heightController = TextEditingController();

  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  String? _selectedCountry;
  String? _selectedCountryCode;
  String? _selectedPhoneCode;

  @override
  void dispose() {
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _phoneController.dispose();

    super.dispose();
  }

  void _selectCountry() {
    showCountryPicker(
      context: context,
      showPhoneCode: true,
      showWorldWide: false,
      onSelect: (country) {
        final oldPhoneCode = _selectedPhoneCode;
        setState(() {
          _selectedCountry = country.name;
          _selectedCountryCode = country.countryCode;
          _selectedPhoneCode = country.phoneCode;
        });
        context.read<CoachingProfileProvider>().setCountry(country.name);
        _updatePhonePrefix(oldPhoneCode, country.phoneCode);
      },
    );
  }

  void _updatePhonePrefix(String? oldPhoneCode, String newPhoneCode) {
    final currentPhone = _phoneController.text.trim();
    final newPrefix = '+$newPhoneCode';
    String updatedPhone;

    if (currentPhone.isEmpty) {
      updatedPhone = newPrefix;
    } else if (oldPhoneCode != null &&
        currentPhone.startsWith('+$oldPhoneCode')) {
      updatedPhone =
          '$newPrefix${currentPhone.substring(oldPhoneCode.length + 1)}';
    } else if (currentPhone.startsWith('+')) {
      updatedPhone = currentPhone;
    } else {
      updatedPhone = '$newPrefix $currentPhone';
    }

    _phoneController.value = TextEditingValue(
      text: updatedPhone,
      selection: TextSelection.collapsed(offset: updatedPhone.length),
    );
  }

  // ==================================================
  // CONTINUER
  // ==================================================

  Future<void> _continue() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final coachingProvider = context.read<CoachingProfileProvider>();
    final country = _selectedCountry ?? coachingProvider.country;
    if (country == null || country.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez sélectionner votre pays.')),
      );

      return;
    }

    final int age = int.parse(_ageController.text.trim());

    final double height = double.parse(
      _heightController.text.trim().replaceAll(',', '.'),
    );

    final double weight = double.parse(
      _weightController.text.trim().replaceAll(',', '.'),
    );

    coachingProvider.setPersonalInformation(
      age: age,
      height: height,
      currentWeight: weight,
      country: country,
    );

    final userProvider = context.read<UserProvider>();
    final phone = _phoneController.text.trim();
    if (phone.isEmpty || phone == '+${_selectedPhoneCode ?? ''}') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez saisir votre numéro de téléphone.'),
        ),
      );
      return;
    }

    final created = await userProvider.createAccount(
      phone: phone,
      country: country,
    );
    if (!mounted) return;
    if (!created) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(userProvider.error ?? 'Création du compte impossible.'),
        ),
      );
      return;
    }

    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const GoalScreen()),
    );
  }

  // ==================================================
  // BUILD
  // ==================================================

  @override
  Widget build(BuildContext context) {
    final isCreatingAccount = context.watch<UserProvider>().isLoading;

    return Scaffold(
      appBar: AppBar(title: const Text('Votre profil')),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ProgressIndicatorWidget(currentStep: 2, totalSteps: 4),

                const SizedBox(height: 30),

                Text(
                  'Parlez-moi un peu de vous',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textDark,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  'Ces informations permettront de personnaliser votre accompagnement.',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: AppTheme.textMedium),
                ),

                const SizedBox(height: 30),

                // ======================================
                // ÂGE
                // ======================================
                CustomTextField(
                  controller: _ageController,
                  label: 'Âge',
                  hint: 'Ex : 25',
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Veuillez entrer votre âge';
                    }

                    final age = int.tryParse(value.trim());

                    if (age == null) {
                      return 'Veuillez entrer un âge valide';
                    }

                    if (age < 15 || age > 100) {
                      return 'Âge compris entre 15 et 100 ans';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // ======================================
                // TAILLE
                // ======================================
                CustomTextField(
                  controller: _heightController,
                  label: 'Taille',
                  hint: 'Ex : 175 cm',
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Veuillez entrer votre taille';
                    }

                    final height = double.tryParse(
                      value.trim().replaceAll(',', '.'),
                    );

                    if (height == null) {
                      return 'Veuillez entrer une taille valide';
                    }

                    if (height < 100 || height > 250) {
                      return 'Taille comprise entre 100 et 250 cm';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // ======================================
                // POIDS
                // ======================================
                CustomTextField(
                  controller: _weightController,
                  label: 'Poids actuel',
                  hint: 'Ex : 80 kg',
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Veuillez entrer votre poids';
                    }

                    final weight = double.tryParse(
                      value.trim().replaceAll(',', '.'),
                    );

                    if (weight == null) {
                      return 'Veuillez entrer un poids valide';
                    }

                    if (weight < 30 || weight > 300) {
                      return 'Poids compris entre 30 et 300 kg';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 20),

                FormField<String>(
                  validator: (_) =>
                      (_selectedCountry ??
                              context
                                  .read<CoachingProfileProvider>()
                                  .country) ==
                          null
                      ? 'Veuillez sélectionner votre pays'
                      : null,
                  builder: (fieldState) => InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'Pays',
                      errorText: fieldState.errorText,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 4,
                      ),
                    ),
                    child: InkWell(
                      onTap: _selectCountry,
                      child: SizedBox(
                        height: 48,
                        child: Row(
                          children: [
                            if (_selectedCountryCode != null) ...[
                              Text(
                                _selectedCountryCode!,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(width: 10),
                            ],
                            Expanded(
                              child: Text(
                                _selectedCountry ??
                                    context
                                        .read<CoachingProfileProvider>()
                                        .country ??
                                    'Sélectionner un pays',
                                style: TextStyle(
                                  color: _selectedCountry == null
                                      ? AppTheme.textMedium
                                      : AppTheme.textDark,
                                ),
                              ),
                            ),
                            const Icon(Icons.keyboard_arrow_down),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                CustomTextField(
                  label: 'Téléphone',
                  hint: _selectedPhoneCode == null
                      ? 'Choisissez un pays pour obtenir son indicatif'
                      : '+$_selectedPhoneCode 77 000 00 00',
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  prefixIcon: Icons.phone_outlined,
                ),

                const SizedBox(height: 15),

                const SizedBox(height: 35),

                // ======================================
                // BOUTON
                // ======================================
                PrimaryButton(
                  text: isCreatingAccount
                      ? 'Création du compte...'
                      : 'Continuer',
                  onPressed: _continue,
                  loading: isCreatingAccount,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
