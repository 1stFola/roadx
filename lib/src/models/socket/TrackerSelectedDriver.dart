//
// class TrackerSelectedUser {
//   double latitude;
//   double longitude;
//   int user_id;
//   bool isDriver;
//   String first_name;
//   String last_name;
//
//   TrackerSelectedUser({
//     this.latitude,
//     this.longitude,
//     this.user_id,
//     this.isDriver,
//     this.first_name,
//     this.last_name,
//   });
//
//   factory TrackerSelectedUser.fromJson(Map<String, dynamic> json) {
//     return TrackerSelectedUser(
//       latitude: json['latitude'],
//       longitude: json['longitude'],
//       user_id: json['user_id'],
//       isDriver: json['isDriver'],
//       first_name: json['first_name'],
//       last_name: json['last_name'],
//     );
//   }
//
//   Map<String, dynamic> toJson() => {
//         'latitude': latitude,
//         'longitude': longitude,
//         'user_id': user_id,
//         'isDriver': isDriver,
//         'first_name': first_name,
//         'last_name': last_name,
//       };
// }
//
