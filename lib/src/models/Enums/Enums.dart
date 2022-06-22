enum AuthStatus { Authenticated, UnAuthenticated }
enum RideType { Standard, Classic, Sedan, Suv, Luxury }
enum RideStatus { drafted, approved, onWay, reached, start, inRoute, end, cancel }
enum UserLocationType { Home, Office }
// enum RideStatus { approved, pending, rejected, start, end }



class RideStatusHelper{

  static RideStatus getValue(String status){
    switch(status){
      case "drafted":
        return RideStatus.drafted;
      case "approved":
        return RideStatus.approved;
      case "onWay":
        return RideStatus.onWay;
      case "reached":
        return RideStatus.reached;
      case "start":
        return RideStatus.start;
      case "inRoute":
        return RideStatus.inRoute;
      case "end":
        return RideStatus.end;
      default:
        return RideStatus.drafted;
    }
  }

}

