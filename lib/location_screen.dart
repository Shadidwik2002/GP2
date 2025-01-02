import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationScreen extends StatefulWidget {
  final LatLng initialLocation;
  final String? title;
  final Color primaryColor;
  final Color secondaryColor;

  const LocationScreen({
    super.key,
    required this.initialLocation,
    this.title = 'Select Location',
    this.primaryColor = const Color(0xFF2196F3), // Material Blue
    this.secondaryColor = Colors.white,
  });

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  late GoogleMapController _mapController;
  late LatLng _selectedLocation;
  bool _isMapLoading = true;
  double _currentZoom = 15.0;

  @override
  void initState() {
    super.initState();
    _selectedLocation = widget.initialLocation;
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    setState(() => _isMapLoading = false);
  }

  void _onMapTap(LatLng position) {
    setState(() {
      _selectedLocation = position;
    });
    _animateToPosition(position);
  }

  Future<void> _animateToPosition(LatLng position) async {
    await _mapController.animateCamera(
      CameraUpdate.newLatLngZoom(position, _currentZoom),
    );
  }

  Future<void> _zoomIn() async {
    _currentZoom = _currentZoom + 1;
    await _mapController.animateCamera(
      CameraUpdate.newLatLngZoom(_selectedLocation, _currentZoom),
    );
  }

  Future<void> _zoomOut() async {
    _currentZoom = _currentZoom - 1;
    await _mapController.animateCamera(
      CameraUpdate.newLatLngZoom(_selectedLocation, _currentZoom),
    );
  }

  void _saveLocation() {
    Navigator.pop(context, _selectedLocation);
  }

  void _centerOnCurrentLocation() {
    _animateToPosition(_selectedLocation);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title!,
          style: TextStyle(
            color: widget.secondaryColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: widget.primaryColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.my_location, color: widget.secondaryColor),
            onPressed: _centerOnCurrentLocation,
          ),
        ],
      ),
      body: Stack(
        children: [
          // Map
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _selectedLocation,
              zoom: _currentZoom,
            ),
            onTap: _onMapTap,
            markers: {
              Marker(
                markerId: const MarkerId("selectedLocation"),
                position: _selectedLocation,
                icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueAzure,
                ),
              ),
            },
            mapType: MapType.normal,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            compassEnabled: true,
          ),

          // Loading Indicator
          if (_isMapLoading)
            Container(
              color: Colors.white70,
              child: Center(
                child: CircularProgressIndicator(
                  color: widget.primaryColor,
                ),
              ),
            ),

          // Zoom Controls
          Positioned(
            right: 16,
            bottom: 100,
            child: Column(
              children: [
                FloatingActionButton(
                  heroTag: "zoomIn",
                  onPressed: _zoomIn,
                  mini: true,
                  backgroundColor: widget.primaryColor,
                  child: Icon(Icons.add, color: widget.secondaryColor),
                ),
                const SizedBox(height: 8),
                FloatingActionButton(
                  heroTag: "zoomOut",
                  onPressed: _zoomOut,
                  mini: true,
                  backgroundColor: widget.primaryColor,
                  child: Icon(Icons.remove, color: widget.secondaryColor),
                ),
              ],
            ),
          ),

          // Save Button
          Positioned(
            bottom: 24,
            left: 16,
            right: 16,
            child: ElevatedButton(
              onPressed: _saveLocation,
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.primaryColor,
                foregroundColor: widget.secondaryColor,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
              child: const Text(
                'Confirm Location',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }
}