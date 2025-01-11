class UserData {
  // Singleton instance
  static final UserData _instance = UserData._internal();
  factory UserData() => _instance;
  UserData._internal();

  // Common properties for both users and service providers
  String? token; // JWT token for authenticated requests
  String? phoneNumber; // Phone number used for login
  String? userType; // 'U' for User, 'P' for Service Provider
  bool? isAdmin; // Indicates if the user is an admin (only for users)
  int? id; // Unique ID for the user or service provider

  // Additional properties for users
  String? userName; // Name of the user

  // Additional properties for service providers
  String? providerName; // Name of the service provider
  String? serviceType; // Type of service provided (e.g., plumbing, electrician)

  // Method to save user data
  void saveUserData(Map<String, dynamic> responseData) {
    token = responseData['token'];
    phoneNumber = responseData['phoneNumber'];
    userType = responseData['userType'];
    isAdmin = responseData['isAdmin'] ?? false;
    id = responseData['id']; // Save the ID

    // Save user-specific data
    if (userType == 'U') {
      userName = responseData['userName'];
    }
    // Save service provider-specific data
    else if (userType == 'P') {
      providerName = responseData['providerName'];
      serviceType = responseData['serviceType'];
    }
  }

  // Method to clear user data (e.g., on logout)
  void clearUserData() {
    token = null;
    phoneNumber = null;
    userType = null;
    isAdmin = null;
    id = null;
    userName = null;
    providerName = null;
    serviceType = null;
  }
}