import 'package:flutter/material.dart';
import 'package:location_permissions/location_permissions.dart';
import 'package:zeus/Navbar/navbar.dart';
import 'location_request_screen.dart';

class LocationPermissionStatus {
  handlePermission () {
    return StreamBuilder<bool>(
      stream: LocationPermissions().serviceStatus.map((s) => s == ServiceStatus.enabled ? true : false),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active && snapshot.hasData)
          {
            if (snapshot.data)
              return NavBar();
            else
              return LocationRequestScreen();
          }
        return LocationRequestScreen();
      },
    );
  }
}