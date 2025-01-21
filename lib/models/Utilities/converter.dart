import '/models/competitions/competition_state.dart';

import 'section_name.dart';
import '../stores/store_draw_state.dart';

// Branch : user_models_creation
class Converter {
  static StoreDrawState toStoreDrawState(String state) {
    switch (state) {
      case "converted-to-competition":
        return StoreDrawState.convertedToCompetition;
      default:
        return StoreDrawState.notConvertedToCompetition;
    }
  }

  static String fromStoreDrawStateToString(StoreDrawState storeDrawState) {
    switch (storeDrawState) {
      case StoreDrawState.convertedToCompetition:
        return "converted-to-competition";
      default:
        return "not-converted-to-competition";
    }
  }

  static CompetitionState toCompetitionState(String state) {
    switch (state) {
      case "on-count-down":
        return CompetitionState.onCountDown;
      case "picking-won-grand-price":
        return CompetitionState.pickingWonGrandPrice;
      default:
        return CompetitionState.pickingWonGroup;
    }
  }

  static String fromCompetitionStateToString(
      CompetitionState competitionState) {
    switch (competitionState) {
      case CompetitionState.onCountDown:
        return "on-count-down";
      case CompetitionState.pickingWonGrandPrice:
        return "picking-won-grand-price";
      default:
        return "picking-won-group";
    }
  }

  // Convert any section string to a section name constant.
  static SectionName toSectionName(String section) {
    switch (section) {
      case "Cato Manor-Mayville-Durban-Kwa Zulu Natal-South Africa":
        return SectionName.catoManorMayvilleDurbanKwaZuluNatalSouthAfrica;
      case "Dunbar-Mayville-Durban-Kwa Zulu Natal-South Africa":
        return SectionName.dunbarMayvilleDurbanKwaZuluNatalSouthAfrica;
      case "Masxha-Mayville-Durban-Kwa Zulu Natal-South Africa":
        return SectionName.masxhaMayvilleDurbanKwaZuluNatalSouthAfrica;
      case "Bonela-Mayville-Durban-Kwa Zulu Natal-South Africa":
        return SectionName.bonelaMayvilleDurbanKwaZuluNatalSouthAfrica;
      case "Sherwood-Mayville-Durban-Kwa Zulu Natal-South Africa":
        return SectionName.sherwoodMayvilleDurbanKwaZuluNatalSouthAfrica;
      case "Richview-Mayville-Durban-Kwa Zulu Natal-South Africa":
        return SectionName.richviewMayvilleDurbanKwaZuluNatalSouthAfrica;
      case "Nsimbini-Mayville-Durban-Kwa Zulu Natal-South Africa":
        return SectionName.nsimbiniMayvilleDurbanKwaZuluNatalSouthAfrica;
      case "Manor Gardens-Mayville-Durban-Kwa Zulu Natal-South Africa":
        return SectionName.manorGardensMayvilleDurbanKwaZuluNatalSouthAfrica;

      case "MUT-Umlazi-Kwa Zulu Natal-South Africa":
        return SectionName.mutUmlaziDurbanKwaZuluNatalSouthAfrica;

      case "Haward College Campus-UKZN-Durban-Kwa Zulu Natal-South Africa":
        return SectionName.hawardCollegeCampusUKZNDurbanKwaZuluNatalSouthAfrica;
      case "Westville Campus-UKZN-Durban-Kwa Zulu Natal-South Africa":
        return SectionName.westvilleCampusUKZNDurbanKwaZuluNatalSouthAfrica;
      case "Edgewood Campus-UKZN-Pinetown-Kwa Zulu Natal-South Africa":
        return SectionName.edgewoodCampusUKZNPinetownKwaZuluNatalSouthAfrica;

      case "Steve Biko Campus-DUT-Durban-Kwa Zulu Natal-South Africa":
        return SectionName.steveBikoCampusDutDurbanKwaZuluNatalSouthAfrica;

      default:
        return SectionName.catoCrestMayvilleDurbanKwaZuluNatalSouthAfrica;
    }
  }

  static String asString(SectionName sectionName) {
    switch (sectionName) {
      // ==============================Mayville==============================
      case SectionName.catoManorMayvilleDurbanKwaZuluNatalSouthAfrica:
        return 'Cato Manor-Mayville-Durban-Kwa Zulu Natal-South Africa';
      case SectionName.dunbarMayvilleDurbanKwaZuluNatalSouthAfrica:
        return 'Dunbar-Mayville-Durban-Kwa Zulu Natal-South Africa';
      case SectionName.masxhaMayvilleDurbanKwaZuluNatalSouthAfrica:
        return 'Masxha-Mayville-Durban-Kwa Zulu Natal-South Africa';
      case SectionName.bonelaMayvilleDurbanKwaZuluNatalSouthAfrica:
        return 'Bonela-Mayville-Durban-Kwa Zulu Natal-South Africa';
      case SectionName.sherwoodMayvilleDurbanKwaZuluNatalSouthAfrica:
        return 'Sherwood-Mayville-Durban-Kwa Zulu Natal-South Africa';
      case SectionName.richviewMayvilleDurbanKwaZuluNatalSouthAfrica:
        return 'Richview-Mayville-Durban-Kwa Zulu Natal-South Africa';
      case SectionName.nsimbiniMayvilleDurbanKwaZuluNatalSouthAfrica:
        return 'Nsimbini-Mayville-Durban-Kwa Zulu Natal-South Africa';
      case SectionName.manorGardensMayvilleDurbanKwaZuluNatalSouthAfrica:
        return 'Manor Gardens-Mayville-Durban-Kwa Zulu Natal-South Africa';

      // ===================Tertiary Students=========================
      case SectionName.mutUmlaziDurbanKwaZuluNatalSouthAfrica:
        return "MUT-Umlazi-Durban-Kwa Zulu Natal-South Africa";
      case SectionName.hawardCollegeCampusUKZNDurbanKwaZuluNatalSouthAfrica:
        return "Haward College Campus-UKZN-Durban-Kwa Zulu Natal-South Africa";
      case SectionName.westvilleCampusUKZNDurbanKwaZuluNatalSouthAfrica:
        return "Westville Campus-UKZN-Durban-Kwa Zulu Natal-South Africa";
      case SectionName.edgewoodCampusUKZNPinetownKwaZuluNatalSouthAfrica:
        return "Edgewood Campus-UKZN-Pinetown-Kwa Zulu Natal-South Africa";

      case SectionName.steveBikoCampusDutDurbanKwaZuluNatalSouthAfrica:
        return "Steve Biko Campus-DUT-Durban-Kwa Zulu Natal-South Africa";
      default:
        return 'Cato Crest-Mayville-Durban-Kwa Zulu Natal-South Africa';
    }
  }
}
