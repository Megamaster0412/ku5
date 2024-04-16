// import 'package:flutter/material.dart';
// import 'package:permission_handler/permission_handler.dart';
//
// class PermissionHandlerExample extends StatefulWidget {
//   @override
//   _PermissionHandlerExampleState createState() => _PermissionHandlerExampleState();
// }
//
// class _PermissionHandlerExampleState extends State<PermissionHandlerExample> {
//   @override
//   void initState() {
//     super.initState();
//     _requestLocationPermission();
//   }
//
//   Future<void> _requestLocationPermission() async {
//     final PermissionStatus status = await Permission.location.request();
//     if (status == PermissionStatus.denied) {
//       // The user denied access to the location.
//       // Handle this case accordingly.
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Permission Handler Example'),
//       ),
//       body: Center(
//         child: Text('Location permission requested!'),
//       ),
//     );
//   }
// }
