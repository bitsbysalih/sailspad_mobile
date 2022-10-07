class User {
  String? id;
  String? firstName;
  String? lastName;
  String? email;
  String? jobTitle;
  String? password;
  String? profilePhoto;
  String? accessToken;
  String? refreshToken;
  String? monthlySubscriptionStatus;
  String? subscriptionTier;

  User({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.jobTitle,
    this.password,
    this.profilePhoto,
    this.accessToken,
    this.refreshToken,
    this.monthlySubscriptionStatus,
    this.subscriptionTier,
  });

  User.fromJson(dynamic data) {
    id = data['id'];
    firstName = data['firstName'];
    lastName = data['lastName'];
    email = data['email'];
    jobTitle = data['jobTitle'];
    password = data['password'];
    profilePhoto = data['profilePhoto'];
    accessToken = data['accessToken'];
    refreshToken = data['refreshToken'];
    monthlySubscriptionStatus = data['monthlySubscriptionStatus'];
    subscriptionTier = data['subscriptionTier'];
  }

  toJson() => {
        'id': id,
        "firstName": firstName,
        "lastName": lastName,
        'email': email,
        'jobTitle': jobTitle,
        'password': password,
        'profilePhoto': profilePhoto,
        'accessToken': accessToken,
        'refreshToken': refreshToken,
        'monthlySubscriptionStatus': monthlySubscriptionStatus,
        'subscriptionTier': subscriptionTier,
      };
}
