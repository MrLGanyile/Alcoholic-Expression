import '/models/competitions/competition_state.dart';

import 'section_name.dart';
import '../stores/store_draw_state.dart';

// groups_crud -> group_resources_crud ->  create_group_resources_front_end
class Converter {
  // Branch : competition_resources_crud ->  create_competition_resources_front_end
  static StoreDrawState toStoreDrawState(String state) {
    switch (state) {
      case "converted-to-competition":
        return StoreDrawState.convertedToCompetition;
      default:
        return StoreDrawState.notConvertedToCompetition;
    }
  }

  // Branch : competition_resources_crud ->  create_competition_resources_front_end
  static String fromStoreDrawStateToString(StoreDrawState storeDrawState) {
    switch (storeDrawState) {
      case StoreDrawState.convertedToCompetition:
        return "converted-to-competition";
      default:
        return "not-converted-to-competition";
    }
  }

  // Branch : competition_resources_crud ->  create_competition_resources_front_end
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

  // Branch : competition_resources_crud ->  create_competition_resources_front_end
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

  // Branch : supported_locations_resources_crud ->  create_supported_locations_front_end
  // Convert any section string to a section name constant.
  static SectionName toSectionName(String section) {
    switch (section) {
      case "Cato Crest-Mayville-Durban-Kwa Zulu Natal-South Africa":
        return SectionName.catoCrestMayvilleDurbanKwaZuluNatalSouthAfrica;
      case "Cato Manor-Mayville-Durban-Kwa Zulu Natal-South Africa":
        return SectionName.catoManorMayvilleDurbanKwaZuluNatalSouthAfrica;
      case "Dunbar-Mayville-Durban-Kwa Zulu Natal-South Africa":
        return SectionName.dunbarMayvilleDurbanKwaZuluNatalSouthAfrica;
      case "Masxha-Mayville-Durban-Kwa Zulu Natal-South Africa":
        return SectionName.masxhaMayvilleDurbanKwaZuluNatalSouthAfrica;
      case "Bonela-Mayville-Durban-Kwa Zulu Natal-South Africa":
        return SectionName.bonelaMayvilleDurbanKwaZuluNatalSouthAfrica;
      case "Nkanini-Mayville-Durban-Kwa Zulu Natal-South Africa":
        return SectionName.nkaniniMayvilleDurbanKwaZuluNatalSouthAfrica;
      case "Sherwood-Mayville-Durban-Kwa Zulu Natal-South Africa":
        return SectionName.sherwoodMayvilleDurbanKwaZuluNatalSouthAfrica;
      case "Richview-Mayville-Durban-Kwa Zulu Natal-South Africa":
        return SectionName.richviewMayvilleDurbanKwaZuluNatalSouthAfrica;
      case "Mathayini-Mayville-Durban-Kwa Zulu Natal-South Africa":
        return SectionName.mathayiniMayvilleDurbanKwaZuluNatalSouthAfrica;
      case "Shayamoya-Mayville-Durban-Kwa Zulu Natal-South Africa":
        return SectionName.shayamoyaMayvilleDurbanKwaZuluNatalSouthAfrica;
      case "Fastrack-Mayville-Durban-Kwa Zulu Natal-South Africa":
        return SectionName.fastrackMayvilleDurbanKwaZuluNatalSouthAfrica;
      case "Nsimbini-Mayville-Durban-Kwa Zulu Natal-South Africa":
        return SectionName.nsimbiniMayvilleDurbanKwaZuluNatalSouthAfrica;

      case 'A Section-Umlazi-Durban-Kwa Zulu Natal-South Africa':
        return SectionName.aSectionUmlaziDurbanKwaZuluNatalSouthAfrica;

      case 'AA Section-Umlazi-Durban-Kwa Zulu Natal-South Africa':
        return SectionName.aaSectionUmlaziDurbanKwaZuluNatalSouthAfrica;

      case 'B Section-Umlazi-Durban-Kwa Zulu Natal-South Africa':
        return SectionName.bSectionUmlaziDurbanKwaZuluNatalSouthAfrica;
      case 'BB Section-Umlazi-Durban-Kwa Zulu Natal-South Africa':
        return SectionName.bbSectionUmlaziDurbanKwaZuluNatalSouthAfrica;
      case 'C Section-Umlazi-Durban-Kwa Zulu Natal-South Africa':
        return SectionName.cSectionUmlaziDurbanKwaZuluNatalSouthAfrica;
      case 'CC Section-Umlazi-Durban-Kwa Zulu Natal-South Africa':
        return SectionName.ccSectionUmlaziDurbanKwaZuluNatalSouthAfrica;
      case 'D Section-Umlazi-Durban-Kwa Zulu Natal-South Africa':
        return SectionName.dSectionUmlaziDurbanKwaZuluNatalSouthAfrica;
      case 'E Section-Umlazi-Durban-Kwa Zulu Natal-South Africa':
        return SectionName.eSectionUmlaziDurbanKwaZuluNatalSouthAfrica;
      case 'F Section-Umlazi-Durban-Kwa Zulu Natal-South Africa':
        return SectionName.fSectionUmlaziDurbanKwaZuluNatalSouthAfrica;
      case 'G Section-Umlazi-Durban-Kwa Zulu Natal-South Africa':
        return SectionName.gSectionUmlaziDurbanKwaZuluNatalSouthAfrica;
      case 'H Section-Umlazi-Durban-Kwa Zulu Natal-South Africa':
        return SectionName.hSectionUmlaziDurbanKwaZuluNatalSouthAfrica;
      case 'J Section-Umlazi-Durban-Kwa Zulu Natal-South Africa':
        return SectionName.jSectionUmlaziDurbanKwaZuluNatalSouthAfrica;
      case 'K Section-Umlazi-Durban-Kwa Zulu Natal-South Africa':
        return SectionName.kSectionUmlaziDurbanKwaZuluNatalSouthAfrica;
      case 'L Section-Umlazi-Durban-Kwa Zulu Natal-South Africa':
        return SectionName.lSectionUmlaziDurbanKwaZuluNatalSouthAfrica;
      case 'M Section-Umlazi-Durban-Kwa Zulu Natal-South Africa':
        return SectionName.mSectionUmlaziDurbanKwaZuluNatalSouthAfrica;
      case 'N Section-Umlazi-Durban-Kwa Zulu Natal-South Africa':
        return SectionName.nSectionUmlaziDurbanKwaZuluNatalSouthAfrica;
      case 'P Section-Umlazi-Durban-Kwa Zulu Natal-South Africa':
        return SectionName.pSectionUmlaziDurbanKwaZuluNatalSouthAfrica;
      case 'Q Section-Umlazi-Durban-Kwa Zulu Natal-South Africa':
        return SectionName.qSectionUmlaziDurbanKwaZuluNatalSouthAfrica;
      case 'R Section-Umlazi-Durban-Kwa Zulu Natal-South Africa':
        return SectionName.rSectionUmlaziDurbanKwaZuluNatalSouthAfrica;
      case 'S Section-Umlazi-Durban-Kwa Zulu Natal-South Africa':
        return SectionName.sSectionUmlaziDurbanKwaZuluNatalSouthAfrica;
      case 'U Section-Umlazi-Durban-Kwa Zulu Natal-South Africa':
        return SectionName.uSectionUmlaziDurbanKwaZuluNatalSouthAfrica;
      case 'V Section-Umlazi-Durban-Kwa Zulu Natal-South Africa':
        return SectionName.vSectionUmlaziDurbanKwaZuluNatalSouthAfrica;
      case 'W Section-Umlazi-Durban-Kwa Zulu Natal-South Africa':
        return SectionName.wSectionUmlaziDurbanKwaZuluNatalSouthAfrica;
      case 'Malukazi-Umlazi-Durban-Kwa Zulu Natal-South Africa':
        return SectionName.malukaziUmlaziDurbanKwaZuluNatalSouthAfrica;
      case 'Y Section-Umlazi-Durban-Kwa Zulu Natal-South Africa':
        return SectionName.ySectionUmlaziDurbanKwaZuluNatalSouthAfrica;
      case 'Z Section-Umlazi-Durban-Kwa Zulu Natal-South Africa':
        return SectionName.zSectionUmlaziDurbanKwaZuluNatalSouthAfrica;
      case 'Philani-Umlazi-Durban-Kwa Zulu Natal-South Africa':
        return SectionName.philaniUmlaziDurbanKwaZuluNatalSouthAfrica;

      // ===================Institutions=========================
      case 'MUT-Umlazi-Durban-Kwa Zulu Natal-South Africa':
        return SectionName.mutUmlaziDurbanKwaZuluNatalSouthAfrica;
      case 'Westville Campus UKZN-Westville-Durban-Kwa Zulu Natal-South Africa':
        return SectionName
            .westvilleCampusWestvilleDurbanKwaZuluNatalSouthAfrica;
      case 'Edgewood Campus UKZN-Westmead-Pinetown-Kwa Zulu Natal-South Africa':
        return SectionName.edgewoodCampusPinetownKwaZuluNatalSouthAfrica;
      case 'DUT-Durban Central-Durban-Kwa Zulu Natal-South Africa':
        return SectionName.dutDurbanCentralDurbanKwaZuluNatalSouthAfrica;
      case 'Berea Tech-Durban Central-Durban-Kwa Zulu Natal-South Africa':
        return SectionName.bereaTechDurbanCentralDurbanKwaZuluNatalSouthAfrica;
      case 'DCC-Durban Central-Durban-Kwa Zulu Natal-South Africa':
        return SectionName.dccDurbanCentralDurbanKwaZuluNatalSouthAfrica;
      case 'ICESA-Durban Central-Durban-Kwa Zulu Natal-South Africa':
        return SectionName.icesaDurbanCentralDurbanKwaZuluNatalSouthAfrica;
      case 'PC Training-Durban Central-Durban-Kwa Zulu Natal-South Africa':
        return SectionName.pcTrainingDurbanCentralDurbanKwaZuluNatalSouthAfrica;
      case 'Damelin-Durban Central-Durban-Kwa Zulu Natal-South Africa':
        return SectionName.damelinDurbanCentralDurbanKwaZuluNatalSouthAfrica;

      default:
        return SectionName.howardCollegeCampusUKZNDurbanKwaZuluNatalSouthAfrica;
    }
  }

  // Branch : supported_locations_resources_crud ->  create_supported_locations_front_end
  static String asString(SectionName sectionName) {
    switch (sectionName) {
      // ==============================Mayville==============================
      case SectionName.catoCrestMayvilleDurbanKwaZuluNatalSouthAfrica:
        return 'Cato Crest-Mayville-Durban-Kwa Zulu Natal-South Africa';
      case SectionName.catoManorMayvilleDurbanKwaZuluNatalSouthAfrica:
        return 'Cato Manor-Mayville-Durban-Kwa Zulu Natal-South Africa';
      case SectionName.dunbarMayvilleDurbanKwaZuluNatalSouthAfrica:
        return 'Dunbar-Mayville-Durban-Kwa Zulu Natal-South Africa';
      case SectionName.masxhaMayvilleDurbanKwaZuluNatalSouthAfrica:
        return 'Masxha-Mayville-Durban-Kwa Zulu Natal-South Africa';
      case SectionName.bonelaMayvilleDurbanKwaZuluNatalSouthAfrica:
        return 'Bonela-Mayville-Durban-Kwa Zulu Natal-South Africa';
      case SectionName.nkaniniMayvilleDurbanKwaZuluNatalSouthAfrica:
        return 'Nkanini-Mayville-Durban-Kwa Zulu Natal-South Africa';
      case SectionName.sherwoodMayvilleDurbanKwaZuluNatalSouthAfrica:
        return 'Sherwood-Mayville-Durban-Kwa Zulu Natal-South Africa';
      case SectionName.richviewMayvilleDurbanKwaZuluNatalSouthAfrica:
        return 'Richview-Mayville-Durban-Kwa Zulu Natal-South Africa';
      case SectionName.mathayiniMayvilleDurbanKwaZuluNatalSouthAfrica:
        return 'Mathayini-Mayville-Durban-Kwa Zulu Natal-South Africa';
      case SectionName.shayamoyaMayvilleDurbanKwaZuluNatalSouthAfrica:
        return 'Shayamoya-Mayville-Durban-Kwa Zulu Natal-South Africa';
      case SectionName.fastrackMayvilleDurbanKwaZuluNatalSouthAfrica:
        return 'Fastrack-Mayville-Durban-Kwa Zulu Natal-South Africa';
      case SectionName.nsimbiniMayvilleDurbanKwaZuluNatalSouthAfrica:
        return 'Nsimbini-Mayville-Durban-Kwa Zulu Natal-South Africa';

      // ===================Umlazi=========================
      case SectionName.aSectionUmlaziDurbanKwaZuluNatalSouthAfrica:
        return 'A Section-Umlazi-Durban-Kwa Zulu Natal-South Africa';
      case SectionName.aaSectionUmlaziDurbanKwaZuluNatalSouthAfrica:
        return 'AA Section-Umlazi-Durban-Kwa Zulu Natal-South Africa';
      case SectionName.bSectionUmlaziDurbanKwaZuluNatalSouthAfrica:
        return 'B Section-Umlazi-Durban-Kwa Zulu Natal-South Africa';
      case SectionName.bbSectionUmlaziDurbanKwaZuluNatalSouthAfrica:
        return 'BB Section-Umlazi-Durban-Kwa Zulu Natal-South Africa';
      case SectionName.cSectionUmlaziDurbanKwaZuluNatalSouthAfrica:
        return 'C Section-Umlazi-Durban-Kwa Zulu Natal-South Africa';
      case SectionName.ccSectionUmlaziDurbanKwaZuluNatalSouthAfrica:
        return 'CC Section-Umlazi-Durban-Kwa Zulu Natal-South Africa';
      case SectionName.dSectionUmlaziDurbanKwaZuluNatalSouthAfrica:
        return 'D Section-Umlazi-Durban-Kwa Zulu Natal-South Africa';
      case SectionName.eSectionUmlaziDurbanKwaZuluNatalSouthAfrica:
        return 'E Section-Umlazi-Durban-Kwa Zulu Natal-South Africa';
      case SectionName.fSectionUmlaziDurbanKwaZuluNatalSouthAfrica:
        return 'F Section-Umlazi-Durban-Kwa Zulu Natal-South Africa';
      case SectionName.gSectionUmlaziDurbanKwaZuluNatalSouthAfrica:
        return 'G Section-Umlazi-Durban-Kwa Zulu Natal-South Africa';
      case SectionName.hSectionUmlaziDurbanKwaZuluNatalSouthAfrica:
        return 'H Section-Umlazi-Durban-Kwa Zulu Natal-South Africa';
      case SectionName.jSectionUmlaziDurbanKwaZuluNatalSouthAfrica:
        return 'J Section-Umlazi-Durban-Kwa Zulu Natal-South Africa';
      case SectionName.kSectionUmlaziDurbanKwaZuluNatalSouthAfrica:
        return 'K Section-Umlazi-Durban-Kwa Zulu Natal-South Africa';
      case SectionName.lSectionUmlaziDurbanKwaZuluNatalSouthAfrica:
        return 'L Section-Umlazi-Durban-Kwa Zulu Natal-South Africa';
      case SectionName.mSectionUmlaziDurbanKwaZuluNatalSouthAfrica:
        return 'M Section-Umlazi-Durban-Kwa Zulu Natal-South Africa';
      case SectionName.nSectionUmlaziDurbanKwaZuluNatalSouthAfrica:
        return 'N Section-Umlazi-Durban-Kwa Zulu Natal-South Africa';
      case SectionName.pSectionUmlaziDurbanKwaZuluNatalSouthAfrica:
        return 'P Section-Umlazi-Durban-Kwa Zulu Natal-South Africa';
      case SectionName.qSectionUmlaziDurbanKwaZuluNatalSouthAfrica:
        return 'Q Section-Umlazi-Durban-Kwa Zulu Natal-South Africa';
      case SectionName.rSectionUmlaziDurbanKwaZuluNatalSouthAfrica:
        return 'R Section-Umlazi-Durban-Kwa Zulu Natal-South Africa';
      case SectionName.sSectionUmlaziDurbanKwaZuluNatalSouthAfrica:
        return 'S Section-Umlazi-Durban-Kwa Zulu Natal-South Africa';
      case SectionName.uSectionUmlaziDurbanKwaZuluNatalSouthAfrica:
        return 'U Section-Umlazi-Durban-Kwa Zulu Natal-South Africa';
      case SectionName.vSectionUmlaziDurbanKwaZuluNatalSouthAfrica:
        return 'V Section-Umlazi-Durban-Kwa Zulu Natal-South Africa';
      case SectionName.wSectionUmlaziDurbanKwaZuluNatalSouthAfrica:
        return 'W Section-Umlazi-Durban-Kwa Zulu Natal-South Africa';
      case SectionName.malukaziUmlaziDurbanKwaZuluNatalSouthAfrica:
        return 'Malukazi-Umlazi-Durban-Kwa Zulu Natal-South Africa';
      case SectionName.ySectionUmlaziDurbanKwaZuluNatalSouthAfrica:
        return 'Y Section-Umlazi-Durban-Kwa Zulu Natal-South Africa';
      case SectionName.zSectionUmlaziDurbanKwaZuluNatalSouthAfrica:
        return 'Z Section-Umlazi-Durban-Kwa Zulu Natal-South Africa';
      case SectionName.philaniUmlaziDurbanKwaZuluNatalSouthAfrica:
        return 'Philani-Umlazi-Durban-Kwa Zulu Natal-South Africa';

      // ===================Institutions=========================
      case SectionName.mutUmlaziDurbanKwaZuluNatalSouthAfrica:
        return 'MUT-Umlazi-Durban-Kwa Zulu Natal-South Africa';
      case SectionName.westvilleCampusWestvilleDurbanKwaZuluNatalSouthAfrica:
        return 'Westville Campus UKZN-Westville-Durban-Kwa Zulu Natal-South Africa';
      case SectionName.edgewoodCampusPinetownKwaZuluNatalSouthAfrica:
        return 'Edgewood Campus UKZN-Westmead-Pinetown-Kwa Zulu Natal-South Africa';
      case SectionName.dutDurbanCentralDurbanKwaZuluNatalSouthAfrica:
        return 'DUT-Durban Central-Durban-Kwa Zulu Natal-South Africa';
      case SectionName.bereaTechDurbanCentralDurbanKwaZuluNatalSouthAfrica:
        return 'Berea Tech-Durban Central-Durban-Kwa Zulu Natal-South Africa';
      case SectionName.dccDurbanCentralDurbanKwaZuluNatalSouthAfrica:
        return 'DCC-Durban Central-Durban-Kwa Zulu Natal-South Africa';
      case SectionName.icesaDurbanCentralDurbanKwaZuluNatalSouthAfrica:
        return 'ICESA-Durban Central-Durban-Kwa Zulu Natal-South Africa';
      case SectionName.pcTrainingDurbanCentralDurbanKwaZuluNatalSouthAfrica:
        return 'PC Training-Durban Central-Durban-Kwa Zulu Natal-South Africa';
      case SectionName.damelinDurbanCentralDurbanKwaZuluNatalSouthAfrica:
        return 'Damelin-Durban Central-Durban-Kwa Zulu Natal-South Africa';

      default:
        return 'Howard College UKZN-Mayville-Durban-Kwa Zulu Natal-South Africa';
    }
  }
}
