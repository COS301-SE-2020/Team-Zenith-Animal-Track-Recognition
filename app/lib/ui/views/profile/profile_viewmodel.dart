import 'package:ERP_RANGER/services/objects/id_cards.dart';
import 'package:stacked/stacked.dart';

class ProfileViewModel extends BaseViewModel{
  int _cardLength = 6;
  int get cardLength => _cardLength;
  List<IdCard> _cards;
  List<IdCard> get cards => _cards;

  IdCard card1 = new IdCard(
      'Elephant',
      'African Bush',
      'Kruger park',
      'Kagiso Ndlovu',
      '4m ago',
      '67%',
      'Dangerous',
      'assets/images/Elephant.jpeg');

  IdCard card2 = new IdCard(
    'Rhino',
    'White',
    'Kruger park',
    'Pricille Berlien',
    '4m ago',
    '92%',
    'Endangered',
    'assets/images/rhino.jpeg',
  );

  IdCard card3 = new IdCard(
      'Buffalo',
      'Cape Buffalo',
      'Kruger park',
      'Charles De Clarke',
      '4m ago',
      '56%',
      'tag1',
      'assets/images/buffalo.jpeg');

  IdCard card4 = new IdCard(
      'Springbok',
      'Antelope',
      'Kruger park',
      'Obakeng Seageng',
      '10m ago',
      '87%',
      'Abundant',
      'assets/images/springbok.jpg');

  IdCard card5 = new IdCard(
      'Blesbok',
      'Antelope',
      'Kruger park',
      'Zachary Christophers',
      '80m ago',
      '100%',
      'tag4',
      'assets/images/Blesbok.jpg');

  IdCard card6 = new IdCard(
      'Red hartebeest',
      'A. buselaphus',
      'Kruger park',
      'Kagiso Ndlovu',
      '1d ago',
      '23%',
      'tag4',
      'assets/images/Red_Hartebeest.jpg');

  ProfileViewModel        () {
    _cards = new List<IdCard>();
    _cards.add(card1);
    _cards.add(card2);
    _cards.add(card3);
    _cards.add(card4);
    _cards.add(card5);
    _cards.add(card6);
  }

  void updateCounter() {
    notifyListeners();
  }
}