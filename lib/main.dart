import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latihan_laraflutter/bloc/process_get_owner_bloc/process_get_owner_bloc.dart';
import 'bloc/employee/employee_bloc.dart';
import 'bloc/owner/owner_bloc.dart';
import 'repositories/employee_repository.dart';
import 'repositories/owner_repository.dart';
import 'pages/employee_page.dart';
import 'pages/owner_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => EmployeeBloc(EmployeeRepository()),
        ),
        BlocProvider(
          create: (context) => OwnerBloc(OwnerRepository())..add(LoadOwners()),
        ),
        BlocProvider(
          create: (context) => ProcessGetOwnerBloc(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter CRUD',
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: Colors.blue,
        ),
        home: HomePage(),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter CRUD'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EmployeePage()),
                );
              },
              child: Text('Manage Employees'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => OwnerPage()),
                );
              },
              child: Text('Manage Owners'),
            ),
          ],
        ),
      ),
    );
  }
}
