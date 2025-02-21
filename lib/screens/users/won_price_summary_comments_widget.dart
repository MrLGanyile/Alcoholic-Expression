import 'package:alco/models/users/won_price_comment.dart';
import 'package:flutter/material.dart';

import 'won_price_comment_widget.dart';

class WonPriceSummaryCommentsWidgets extends StatelessWidget {
  List<WonPriceComment> comments = [
    WonPriceComment(
        wonPriceCommentId: '1',
        dateCreated: DateTime(2024, 12, 13, 12, 45),
        imageURL: 'alcoholics/profile_images/+27621234760.jpg',
        username: 'Mountain Mkhize Mhlongo',
        message:
            'Igijima Emaweni, Ayilali Nhlobo, Ayilambi Nhlobo, Ayikhathali Nhlobo, Inhliziyo Inhlabelela Ubusuku Nemini'),
    WonPriceComment(
        imageURL: 'alcoholics/profile_images/+27621234762.jpg',
        username: 'Yebo',
        wonPriceCommentId: '2',
        dateCreated: DateTime(2025, 2, 13, 5, 13),
        message:
            'Nomangabe Kuyashisa Iyahlanelela, Nomangabe Kuyabanga Iyahlabelela, Nomangabe Liyaduma Lishaya Umbani Oshayisa Ngovalo Yona Ayimi Nhlobo Iyahlabelela. '),
    WonPriceComment(
        imageURL: 'alcoholics/profile_images/+27621234763.jpg',
        username: 'Mountain Mkhize Mhlongo',
        wonPriceCommentId: '3',
        dateCreated: DateTime(2025, 2, 13, 23, 35),
        message: 'Iyazi Ibhekephi Futhi Ngeke Ivinjwe Lutho'),
    WonPriceComment(
        wonPriceCommentId: '4',
        dateCreated: DateTime(2025, 1, 31, 20, 12),
        imageURL: 'alcoholics/profile_images/+27621234765.jpg',
        username: 'Yebo',
        message: 'Uloyo'),
    WonPriceComment(
        wonPriceCommentId: '4',
        dateCreated: DateTime(2024, 11, 13, 12, 0),
        imageURL: 'alcoholics/profile_images/+27625446322.jpg',
        username: 'Zwe Captain',
        message: 'Naloyo Ophuma Umphefumulo Into Yokuqala Ayisho '),
    WonPriceComment(
        wonPriceCommentId: '5',
        dateCreated: DateTime(2025, 2, 16, 23, 44),
        imageURL: 'alcoholics/profile_images/+27625446353.jpg',
        username: 'Snathi',
        message:
            'Uma Efika Emazulwini Uthi Nami Ngiyavuma Akekho Ongaphezulu Kwayo. Oyazi Isencane Isakhula Uthi Nami Ngiyavuma Akekho Ongaphezulu Kwayo, Oyazi Isikhulile Isizazi Ukuthi Ingubani Izokwenzani Kulomhlaba Naye Uthi Nami Ngiyavuma Akekho Ongaphezulu Kwayo, Ongakaze Ayibona Nhlobo Oyizizwa Ngendaba Naye Ucula Iculo Elifanayo Nami Ngiyavuma Akekho Ongaphezulu Kwayo.'),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: comments.length,
        itemBuilder: ((context, index) =>
            WonPriceCommentWidget(wonPriceComment: comments[index])));
  }
}
