import 'package:flutter/material.dart';

class welcome extends StatelessWidget {
  const welcome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/bg.jpg"), fit: BoxFit.fill),
        ),
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 500),
              Text(
                "Unlimited films,\n TV programmes\n & more",
                style: TextStyle(
                  fontSize: 40,
                  color: Colors.redAccent[700],
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Material(
                  borderRadius: BorderRadius.circular(10),
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, "/login");
                    },
                    child: Container(
                      width: 200,
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(color: Colors.redAccent[700]),
                      child: Center(
                        child: Text(
                          "Get Started",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5),
                        ),
                      ),
                    ),
                  )),
              SizedBox(
                height: 70,
              )
            ],
          ),
        ),
      ),
    ));
  }
}
