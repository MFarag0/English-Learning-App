import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kalimati_app/core/services/data_services.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _visible = true;
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: true, 
      appBar: AppBar(
        toolbarHeight: screenHeight * 0.10,
        leading: InkWell(
          onTap: () => context.pop(),
          child: const Icon(
            Icons.keyboard_arrow_left,
            color: Colors.black,
            size: 40,
          ),
        ),
      ),

     
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              

              SizedBox(
                height: screenHeight * 0.20,
                child: Column(
                  children: const [
                    Text(
                      "Teachers' Portal",
                      style: TextStyle(
                        fontSize: 38,
                        fontFamily: 'cursive',
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      "Manage your students' learning packages",
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'serif',
                        color: Color.fromARGB(255, 86, 85, 85),
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.7,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 93, 146, 239),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          Row(
                            children: const [
                              Text(
                                "Login",
                                style: TextStyle(
                                  fontSize: 35,
                                  fontFamily: 'cursive',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Spacer(), 
                              Icon(Icons.school, color: Colors.white, size: 35),
                            ],
                          ),
                          const SizedBox(height: 50),
                          TextField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              hintText: "Email",
                              prefixIcon: const Icon(
                                Icons.mail_outline,
                                color: Colors.blue,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Colors.transparent,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  width: 3,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: _passwordController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              hintText: "Password",
                              prefixIcon: const Icon(
                                Icons.lock_outline,
                                color: Colors.blue,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Colors.transparent,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  width: 3,
                                  color: Colors.blue,
                                ),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _visible
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Colors.grey,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _visible = !_visible;
                                  });
                                },
                              ),
                            ),
                            obscureText: _visible,
                          ),
                          const SizedBox(height: 50),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton(
                                onPressed: () async {
                                  final email = _emailController.text.trim();
                                  final password = _passwordController.text;
                                  try {
                                    await DataServices().initialize();
                                  } catch (e) {
                                    if (mounted) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text('Data load failed: $e'),
                                        ),
                                      );
                                    }
                                    return;
                                  }

                                  final user = DataServices().authenticate(
                                    email,
                                    password,
                                  );

                                  if (user != null) {
                                    final destination =
                                        '/teacher-packages/$email';
                                    if (mounted) context.go(destination);
                                  } else {
                                    if (mounted) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text('Invalid credentials'),
                                        ),
                                      );
                                    }
                                  }
                                },
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                child: const SizedBox(
                                  width: 200,
                                  child: Text(
                                    "Login",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
