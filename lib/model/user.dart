class UserData {
  String firstName;
  String lastName;
  String email;
  String contact;
  String addressLine1;
  String addressLine2;
  String city;
  String state;
  String country;
  String pictureUrl;
  String pincode;
  List<String> interest;
  var verificationId;

  UserData({
    this.email,
    this.addressLine1,
    this.addressLine2,
    this.city,
    this.contact,
    this.country,
    this.firstName,
    this.interest,
    this.lastName,
    this.pictureUrl,
    this.state,
    this.pincode,
    this.verificationId,
  });
}
