import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
class UnbordingContent {
  String image;
  String title;
  String discription;

  UnbordingContent({this.image, this.title, this.discription});
}

List<UnbordingContent> contents = [
  UnbordingContent(
      title: 'Forms',
      image: 'assets/quality.svg',
      discription: "simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the "

  ),
  UnbordingContent(
      title: 'Article',
      image: 'assets/person.svg',
      discription: "simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the "

  ),
  UnbordingContent(
      title: 'Reward',
      image: 'assets/reward.svg',
      discription: "simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the "

  ),
];