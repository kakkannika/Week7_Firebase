import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../model/ride/ride_filter.dart';
import 'widgets/ride_pref_bar.dart';
import '../../../service/rides_service.dart';
import '../../../model/ride/ride.dart';
import '../../../model/ride/ride_pref.dart';
import '../../theme/theme.dart';
import '../../../utils/animations_util.dart';
import 'widgets/ride_pref_modal.dart';
import 'widgets/rides_tile.dart';
import '../../Provider/ride_preference_provider.dart';

///
///  The Ride Selection screen allow user to select a ride, once ride preferences have been defined.
///  The screen also allow user to re-define the ride preferences and to activate some filters.
///
class RidesScreen extends StatelessWidget {
  const RidesScreen({super.key});

  void onRidePrefSelected(BuildContext context, RidePreference newPreference) async {
    // 1 - Update the current preference using the provider
    Provider.of<RidesPreferencesProvider>(context, listen: false)
        .setCurrentPreferrence(newPreference);

    // 2 - Navigate to the rides screen (with a bottom to top animation)
    await Navigator.of(context)
        .push(AnimationUtils.createBottomToTopRoute(RidesScreen()));
  }

  void onPreferencePressed(BuildContext context) async {
    final ridePreferencesProvider = Provider.of<RidesPreferencesProvider>(context, listen: false);
    RidePreference currentPreference = ridePreferencesProvider.currentPreference!;

    // Open a modal to edit the ride preferences
    RidePreference? newPreference = await Navigator.of(
      context,
    ).push<RidePreference>(
      AnimationUtils.createTopToBottomRoute(
        RidePrefModal(initialPreference: currentPreference),
      ),
    );

    if (newPreference != null) {
      // 1 - Update the current preference using the provider
      ridePreferencesProvider.setCurrentPreferrence(newPreference);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Watch the RidesPreferencesProvider
    final ridePreferencesProvider = Provider.of<RidesPreferencesProvider>(context);
    // Get the current preference
    RidePreference currentPreference = ridePreferencesProvider.currentPreference!;
    // Get the list of available rides regarding the current ride preference
    RideFilter currentFilter = RideFilter();
    List<Ride> matchingRides = RidesService.instance.getRidesFor(currentPreference, currentFilter);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(
          left: BlaSpacings.m,
          right: BlaSpacings.m,
          top: BlaSpacings.s,
        ),
        child: Column(
          children: [
            // Top search Search bar
            RidePrefBar(
              ridePreference: currentPreference,
              onBackPressed: () => Navigator.of(context).pop(),
              onPreferencePressed: () => onPreferencePressed(context),
              onFilterPressed: () {},
            ),

            Expanded(
              child: ListView.builder(
                itemCount: matchingRides.length,
                itemBuilder: (ctx, index) =>
                    RideTile(ride: matchingRides[index], onPressed: () {}),
              ),
            ),
          ],
        ),
      ),
    );
  }
}