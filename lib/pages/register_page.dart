import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:preloved/pages/login_page.dart';
import 'package:preloved/services/firebase_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _retypePasswordController = TextEditingController();
  final FirebaseService _firebaseService = FirebaseService();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _obscureText = true;
  bool _obscureRetypeText = true;

  String name = '';
  String email = '';
  String phoneNum = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xFF6DAAF7),
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset('assets/PrelovedLogo_White.svg', width: 30, height: 30),
                const SizedBox(height: 40.0),
                Container(
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F1F1),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Column(
                          children: [
                            const Text(
                              "Make a New Account",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w500,
                                color: Color(0xff1a1a1a),
                              ),
                            ),
                            RichText(
                              text: TextSpan(
                                text: 'Already have account? ',
                                style: const TextStyle(
                                  fontSize: 12.0,
                                  color: Color(0xff1a1a1a),
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: 'Login here',
                                    style: const TextStyle(
                                      fontSize: 12.0,
                                      color: Color(0xffFF9F2D),
                                      fontWeight: FontWeight.w500,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.pop(context);
                                      },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30.0),
                        TextFormField(
                          key: const ValueKey('name'),
                          controller: _nameController,
                          decoration: const InputDecoration(
                            labelText: "Name",
                            prefixIcon: Icon(Icons.person),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                          onSaved: (value){
                            setState(() {
                              name = value!;
                            });
                          },
                        ),
                        const SizedBox(height: 20.0),
                        TextFormField(
                          key: const ValueKey('phoneNum'),
                          controller: _phoneController,
                          decoration: const InputDecoration(
                            labelText: "Phone Number",
                            prefixIcon: Icon(Icons.phone),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your phone number';
                            }
                            return null;
                          },
                          onSaved: (value){
                            setState(() {
                              phoneNum = value!;
                            });
                          },
                        ),
                        const SizedBox(height: 20.0),
                        TextFormField(
                          key: const ValueKey('email'),
                          controller: _emailController,
                          decoration: const InputDecoration(
                            labelText: "Email",
                            prefixIcon: Icon(Icons.email),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            if (!value.contains('@')) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                          onSaved: (value){
                            setState(() {
                              email = value!;
                            });
                          },
                        ),
                        const SizedBox(height: 20.0),
                        TextFormField(
                          key: const ValueKey('password'),
                          controller: _passwordController,
                          decoration: InputDecoration(
                            labelText: "Password",
                            prefixIcon: const Icon(Icons.lock),
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              },
                              child: Icon(
                                _obscureText ? Icons.visibility_off : Icons.visibility,
                              ),
                            ),
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            ),
                          ),
                          obscureText: _obscureText,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                          onSaved: (value){
                            setState(() {
                              password = value!;
                            });
                          },
                        ),
                        const SizedBox(height: 20.0),
                        TextFormField(
                          controller: _retypePasswordController,
                          decoration: InputDecoration(
                            labelText: "Re-type Password",
                            prefixIcon: const Icon(Icons.lock),
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _obscureRetypeText = !_obscureRetypeText;
                                });
                              },
                              child: Icon(
                                _obscureRetypeText ? Icons.visibility_off : Icons.visibility,
                              ),
                            ),
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            ),
                          ),
                          obscureText: _obscureRetypeText,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please re-type your password';
                            }
                            if (value != _passwordController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 30),
                        _isLoading
                            ? const CircularProgressIndicator()
                            : ElevatedButton(
                                onPressed: () async{
                                  final scaffoldMessenger = ScaffoldMessenger.of(context);
                                  if(_formKey.currentState!.validate()){
                                    _formKey.currentState!.save();
                                  }
                                  var result = await _firebaseService.signUp(name, email, phoneNum, password);
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginPage()));
                                  scaffoldMessenger.showSnackBar(SnackBar(content: Text(result != null ? "Register Success" : "Register Failed")));
                                },
                                style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(double.infinity, 20),
                                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                                  backgroundColor: const Color(0xffFFD4A1),
                                  textStyle: const TextStyle(fontSize: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                                child: const Text(
                                  "Register",
                                  style: TextStyle(
                                    color: Color(0xff1A1A1A),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                      ],
                    ),
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
