import 'package:alco/models/locations/section_name.dart';
import 'package:alco/models/users/group.dart' as alias;
import 'package:flutter_test/flutter_test.dart';

void main() {
  late final alias.Group validGroup;
  //Pre-Tests
  setUp(() => null); // Called Prior Each Test [Multiple Times]

  setUpAll(() {
    validGroup = alias.Group(
        groupName: 'Izinja',
        groupImageURL: '/groups_specific_locations/+27612345678.jpg',
        groupSectionName:
            SectionName.catoManorMayvilleDurbanKwaZuluNatalSouthAfrica,
        groupSpecificArea: 'Ringini',
        groupCreatorPhoneNumber: '+27612345678',
        groupCreatorImageURL: '/alcoholics/profile_images/+27612345678.jpg',
        groupCreatorUsername: 'Sebenzile',
        groupMembers: ['+27612345678', '+27712345678', '+27812345678'],
        maxNoOfMembers: 5);
  }); // Called Prior All Test [One Time]

  // Test Description Guide - Given, When, Then.
  // Test Body Guide - Arrange, Action, Assert.

  // Groups Can Be Nasted.
  group('Group Class -', () {
    test(
        'Given A Group Class, When It Is Created, Then maxNoOfMembers Equals 5.',
        () {
      // Act
      final maxNoOfMembers = validGroup.maximumNoOfMembers;

      // Assert
      expect(maxNoOfMembers, 5);
    });

    test(
        'Given A Group Class, When It Creator Member Is Removed, Then The Operation Should Fail.',
        () {
      // Act
      final result = validGroup.removeMember('+27612345678');

      // Assert
      expect(result, false);
    });
  });

  // Post-Tests
  tearDown(() => null); // Called After Each Test [Multiple Times]
  tearDownAll(() => null); // // Called After All Test [One Time]
}
