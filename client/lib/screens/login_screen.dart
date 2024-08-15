import 'package:flutter/material.dart';
import 'package:client/providers/auth_provider.dart';
import 'package:client/screens/register_screen.dart';
import 'package:provider/provider.dart';

final _formkey = GlobalKey<FormState>();
final name = TextEditingController();
final password = TextEditingController();

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<AuthProvider>().isLoading;

    return Scaffold(
      appBar: AppBar(
        title: Text('FLUTTER BLOG'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'FLUTTER LOGIN',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(
              height: 20.0,
            ),
            Form(
                key: _formkey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: name,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Username',
                          hintText: 'Enter Username'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "* Required";
                        } else
                          return null;
                      },
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    TextFormField(
                      obscureText: true,
                      controller: password,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Password',
                          hintText: 'Enter secure password'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "* Required";
                        } else if (value.length < 6) {
                          return "Password should be atleast 6 characters";
                        } else if (value.length > 15) {
                          return "Password should not be greater than 15 characters";
                        } else
                          return null;
                      },
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AbsorbPointer(
                          absorbing: isLoading,
                          child: TextButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => RegisterScreen()));
                            },
                            child: Text('Not Registered Yet ?'),
                          ),
                        ),
                        AbsorbPointer(
                          absorbing: isLoading,
                          child: ElevatedButton(
                            onPressed: () async {
                              if (_formkey.currentState!.validate()) {
                                context
                                    .read<AuthProvider>()
                                    .login(name.text, password.text);
                              }
                            },
                            child: isLoading
                                ? Container(
                                    constraints: BoxConstraints(
                                        maxHeight: 20.0, maxWidth: 20.0),
                                    child: CircularProgressIndicator(
                                      backgroundColor: Colors.white,
                                    ),
                                  )
                                : Text('Login'),
                          ),
                        ),
                      ],
                    )
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
