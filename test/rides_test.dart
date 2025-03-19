

import '../lib/model/location/locations.dart';
import '../lib/model/ride/ride.dart';
import '../lib/model/ride/ride_pref.dart';
import '../lib/repository/mock/mock_rides_repository.dart';
import '../lib/service/rides_service.dart';

void main() {
  // 1 - Create a  ride services
  RidesService.initialize(MockRidesRepository());

  // FAKE LOCATIONS
  Location battambang = Location(name: "Battambang", country: Country.cambodia);

  Location siemReap = Location(name: "Siem Reap", country: Country.cambodia);

  // 2 - Create a ride preference
  RidePreference pref = RidePreference(
    departure: battambang,
    departureDate: DateTime.now(),
    arrival: siemReap,
    requestedSeats: 1,
  );

  List<Ride> availableRides = RidesService.instance.getRidesFor(pref, null);

  print(availableRides);
}
