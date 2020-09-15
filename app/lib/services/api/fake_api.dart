import 'package:ERP_RANGER/services/api/api.dart';
import 'package:ERP_RANGER/services/datamodels/api_models.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api.dart';

@lazySingleton
class FakeApi implements Api {
  @override
  Future<List<AnimalModel>> getAnimalModel(String category) async {
    List<AnimalModel> animalList = new List();

    if (category == "BIG CATS") {
      print("pppppp");
      AnimalModel lion = AnimalModel(
        animalName: "Katanga Lion",
        diet: "Carnivore",
        gestation: "4 Months",
        sizeM: "3.1",
        sizeF: "2.5",
        weightF: "181",
        weightM: "258",
        image: "assets/images/animal/Big_Cats/lion/a1.jpeg",
        description:
            "The lion is known as the ‘king of the jungle’ and is one of the five big cats of the genus Panthera. They are the only cats that live in groups, called ‘prides’, which are made up of family units. Male lions have manes (fringes of long hair that encircle their heads) and they defend the pride’s territory. Female lions are the pride’s primary hunters and often work together. Young lions do not help to hunt until they are about one year old.",
        behaviour:
            "Lions are highly territorial and occupy the same area for generations. Females actively defend their territories against other females, while resident males protect prides from rival coalitions. Territory size depends on prey abundance, as well as access to water and denning sites.",
        habitats:
            "They are found in southwestern Africa in Angola, Namibia, western Zimbabwe and Zambia, Zaire, and northern Botswana. They are one of the largest lions of all the lion species.",
      );

      AnimalModel leopard = AnimalModel(
        animalName: "African Leopard",
        diet: "Herbivore",
        gestation: "24 Months",
        sizeM: "0.7",
        sizeF: "0.64",
        weightF: "27",
        weightM: "31",
        image: "assets/images/animal/Big_Cats/leopard/a1.jpg",
        description:
            "Leopards are large cats, with light-colored fur, and black spots and rosettes across their entire body. The rosettes look somewhat like hollowed-out spots, and are smaller than those of the jaguar. Males of the species are larger than the females, and can stand up to 28 in. tall at the shoulder",
        behaviour:
            "Search Results Featured snippet from the web Leopards are solitary creatures that only spend time with others when they are mating or raising young. They are also nocturnal and spend their nights hunting instead of sleeping. Leopards spend a lot of their time in trees. Their spotted coat camouflages them, making them blend in with the leaves of the tree.",
        habitats:
            "These large cats can live in almost any type of habitat, including rainforests, deserts, woodlands, grassland savannas, forests, mountain habitats, coastal scrubs, shrub lands and swampy areas. In fact, leopards live in more places than any other large",
      );

      AnimalModel cheetah = AnimalModel(
        animalName: "South African Cheetah",
        diet: "Carnivore",
        gestation: "3 months",
        sizeM: "0.9",
        sizeF: "0.9",
        weightF: "45",
        weightM: "63",
        image: "assets/images/animal/Big_Cats/cheetah/a1.jpg",
        description:
            "They are mainly found in savannah grassland, open flat areas and sometimes in wooded areas. The Cheetah is the fastest of all mammals and can run at a speed of more than 100 km/h when charging over a short distance. They are mainly solitary hunters, although sometimes they hunt in small groups.",
        behaviour:
            "Although more sociable than Leopards, adult Cheetahs are solitary animals. They are the fastest quadrupeds, reaching speeds of more than 100 kilometers per hour, in short bursts. ... At a kill Cheetahs tend to eat as quick as they can, always on the alert for other carnivores, to whom they very often loose their prey",
        habitats:
            "Search Results Featured snippet from the web Image result for south african cheetah habitat The Southern African cheetah lives mainly in the lowland areas and deserts of the Kalahari, the savannahs of Okavango Delta, and the grasslands of the Transvaal region in South Africa. In Namibia, cheetahs are mostly found in farmlands.",
      );

      animalList.add(lion);
      animalList.add(leopard);
      animalList.add(cheetah);
      return animalList;
    } else if (category == "BIG FIVE") {
      print("oooooo");
      AnimalModel lion = AnimalModel(
        animalName: "Katanga Lion",
        diet: "Carnivore",
        gestation: "4 Months",
        sizeM: "3.1",
        sizeF: "2.5",
        weightF: "181",
        weightM: "258",
        image: "assets/images/animal/Big_Cats/lion/a1.jpeg",
        description:
            "The lion is known as the ‘king of the jungle’ and is one of the five big cats of the genus Panthera. They are the only cats that live in groups, called ‘prides’, which are made up of family units. Male lions have manes (fringes of long hair that encircle their heads) and they defend the pride’s territory. Female lions are the pride’s primary hunters and often work together. Young lions do not help to hunt until they are about one year old.",
        behaviour:
            "Lions are highly territorial and occupy the same area for generations. Females actively defend their territories against other females, while resident males protect prides from rival coalitions. Territory size depends on prey abundance, as well as access to water and denning sites.",
        habitats:
            "They are found in southwestern Africa in Angola, Namibia, western Zimbabwe and Zambia, Zaire, and northern Botswana. They are one of the largest lions of all the lion species.",
      );

      AnimalModel elephant = AnimalModel(
        animalName: "AFRICAN BUSH ELEPHANT",
        diet: "Herbivore",
        gestation: "24 Months",
        sizeM: "3.2",
        sizeF: "2.6",
        weightF: "3000",
        weightM: "5800",
        image: "assets/images/appearance/elephant/p1.jpg",
        description:
            "The African bush elephant is the largest land mammal in the world and the largest of the three elephant species. ",
        behaviour:
            "African Bush Elephants are nomadic animals meaning that they are constantly on the move in search of food, so moving within these family herds allows them to have greater protection both from predators and from the elements.",
        habitats:
            "African elephants live in sub-Saharan Africa, the rain forests of Central and West Africa and the Sahel desert in Mali.",
      );

      AnimalModel buffalo = AnimalModel(
        animalName: "Cape Buffalo",
        diet: "Herbivore",
        gestation: "13 Months",
        sizeM: "1.7",
        sizeF: "1.0",
        weightF: "300",
        weightM: "900",
        image: "assets/images/appearance/buffalo/p1.jpg",
        description:
            "Depending on the subspecies, African buffalo range in color from dark brown or black (in savannah-living races) to bright red (forest buffalo). ",
        behaviour:
            "African buffalo may be active throughout the day and night; on average, 18 hours per day are spent foraging and moving.",
        habitats:
            "One of the most successful of Africa's wild ruminants, the Cape buffalo thrives in virtually all types of grassland habitat in sub-Saharan Africa, from dry savanna to swamp and from lowland floodplains to montane mixed forest and glades, as long as it is within commuting distance of water (up to 20 km [12 miles]).",
      );

      animalList.add(lion);
      animalList.add(buffalo);
      animalList.add(elephant);
      return animalList;
    } else if (category == "LARGE ANTELOPE") {
      print("ppppppkkkkkkkkkkkkk");
      AnimalModel eland = AnimalModel(
        animalName: "Common Eland",
        diet: "Herbivore",
        gestation: "9 Months",
        sizeM: "1.6",
        sizeF: "1.5",
        weightF: "600",
        weightM: "940",
        image: "assets/images/animal/Antelopes/eland/a1.jpg",
        description:
            "The dominant male can mate with more than one female. Females have a gestation period of 9 months, and give birth to only one calf each time. Males, females and juveniles each form separate social groups. The male groups are the smallest; the members stay together and search for food or water sources.",
        behaviour:
            "The dominant male can mate with more than one female. Females have a gestation period of 9 months, and give birth to only one calf each time. Males, females and juveniles each form separate social groups. The male groups are the smallest; the members stay together and search for food or water sources.",
        habitats:
            "Common elands live on the open plains of southern Africa and along the foothills of the great southern African plateau. The species extends north into Ethiopia and most arid zones of South Sudan, west into eastern Angola and Namibia, and south to South Africa.",
      );

      AnimalModel kudu = AnimalModel(
        animalName: "Greater Kudu",
        diet: "Herbivore",
        gestation: "8 Months",
        sizeM: "1.6",
        sizeF: "1.5",
        weightF: "190",
        weightM: "270",
        image: "assets/images/animal/Antelopes/kudu/a1.jpg",
        description:
            "The Great kudu is a large antelope with tawny coloring and thin, white, sparse vertical stripes. Greater kudu may be distinguished from a similar species, the lesser kudu (Tragelaphus imberbis), by the presence of a throat mane. Approximately 1.2 to 1.5 m (4 to 5 ft.) Male: 225 to 357.7 kg (495 to 787 lbs.)",
        behaviour:
            "They may be active throughout the 24-hour day. Herds disperse during the rainy season when food is plentiful. During the dry season, there are only a few concentrated areas of food so the herds will congregate. Greater kudu are not territorial; they have home areas instead.",
        habitats:
            "Their habitat includes mixed scrub woodlands (the greater kudu is one of the few largest mammals that prefer living in settled areas – in scrub woodland and bush on abandoned fields and degraded pastures, mopane bush and acacia in lowlands, hills and mountains.",
      );

      AnimalModel hartebeest = AnimalModel(
        animalName: "Red Hartebeest",
        diet: "Herbivore",
        gestation: "24 Months",
        sizeM: "1.3",
        sizeF: "1.2",
        weightF: "120",
        weightM: "150",
        image: "assets/images/animal/Antelopes/hartebeest/a1.jpg",
        description:
            "The Red Hartebeest is a large, reddish-fawn antelope with sloping back and long narrow face. Both sexes have heavily ringed horns. Of the 12 subspecies described in Africa, the Red Hartebeest is the only one which occurs in South Africa. Due to its re-introduction onto game farms and nature reserves, it has a wider distribution today. Adult bulls weigh 150 kg and measure 1.3 m at the shoulders, while cows only weigh 120 kg.",
        behaviour:
            "Territorial bulls often present themselves on prominent mounds and mark their territories with dung piles. The Red Hartebeest is swift on foot and gregarious, occurring in herds of up to 30. To see an unusual encounter of a Red Hartebeest with a cyclist.",
        habitats:
            "Preferred habitat is the dry, arid regions of Namibia, the Kalahari, southern Botswana, and north-western South Africa.",
      );

      animalList.add(eland);
      animalList.add(kudu);
      animalList.add(hartebeest);
      return animalList;
    }
  }

  @override
  Future<List<SearchModel>> getSearchModel() async {
    List<SearchModel> searchList = new List();
    SearchModel searchModel = SearchModel(
        commonName: "Elephant",
        species: "African Bush Elephant",
        image:
            "https://images.unsplash.com/photo-1551316679-9c6ae9dec224?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60");
    SearchModel searchModel1 = SearchModel(
        commonName: "Wildebeest",
        species: "Black Wildebeest",
        image:
            "https://images.unsplash.com/photo-1516729445616-0393420f6089?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1050&q=80");
    SearchModel searchModel2 = SearchModel(
        commonName: "Jackal",
        species: "Black-Backed Jackal",
        image:
            "https://images.unsplash.com/photo-1576313966078-951c6cdd8866?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1050&q=80");
    SearchModel searchModel3 = SearchModel(
        commonName: "Hippopotamus",
        species: "Common Hippopotamus",
        image:
            "https://images.unsplash.com/photo-1553521306-9387d3795516?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1050&q=80");
    SearchModel searchModel4 = SearchModel(
        commonName: "Antelope",
        species: "Blesbok",
        image:
            "https://images.unsplash.com/photo-1590692462025-f84292449cbe?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1051&q=80");
    SearchModel searchModel5 = SearchModel(
        commonName: "Antelope",
        species: "Red Hartebeest",
        image:
            "https://images.unsplash.com/photo-1593735962887-bef0731874bd?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1225&q=80");
    SearchModel searchModel6 = SearchModel(
        commonName: "Antelope",
        species: "Waterbuck",
        image:
            "https://images.unsplash.com/photo-1581262100228-02ce45aa5074?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1050&q=80");
    SearchModel searchModel7 = SearchModel(
        commonName: "Buffalo",
        species: "Cape Buffalo",
        image:
            "https://images.unsplash.com/photo-1508605375977-9fe795aea86a?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1148&q=80");

    searchList.add(searchModel);
    searchList.add(searchModel1);
    searchList.add(searchModel2);
    searchList.add(searchModel3);
    searchList.add(searchModel4);
    searchList.add(searchModel5);
    searchList.add(searchModel6);
    searchList.add(searchModel7);
    return searchList;
  }

  @override
  Future<GalleryModel> getGalleryModel(String i) async {
    List<String> appearance = new List();
    List<String> tracks = new List();
    List<String> droppings = new List();
    List<List<String>> gallery = new List();
    String name;

    if (i == "elephant") {
      appearance.add("assets/images/appearance/elephant/p1.jpg");
      appearance.add("assets/images/appearance/elephant/p2.jpg");
      appearance.add("assets/images/appearance/elephant/p3.jpg");
      appearance.add("assets/images/appearance/elephant/p4.jpg");

      tracks.add("assets/images/print/elephant/print1.jpg");
      tracks.add("assets/images/print/elephant/print2.jpg");
      tracks.add("assets/images/print/elephant/print3.jpg");
      tracks.add("assets/images/print/elephant/print4.jpg");

      droppings.add("assets/images/droppings/elephant/drop1.jpg");
      droppings.add("assets/images/droppings/elephant/drop2.jpg");
      droppings.add("assets/images/droppings/elephant/drop3.jpg");
      droppings.add("assets/images/droppings/elephant/drop4.jpg");

      name = "African Bush Elephant";
    } else if (i == "buffalo") {
      appearance.add("assets/images/appearance/buffalo/p1.jpg");
      appearance.add("assets/images/appearance/buffalo/p2.jpg");
      appearance.add("assets/images/appearance/buffalo/p3.jpg");
      appearance.add("assets/images/appearance/buffalo/p4.jpg");

      tracks.add("assets/images/print/buffalo/print1.jpg");
      tracks.add("assets/images/print/buffalo/print2.jpg");
      tracks.add("assets/images/print/buffalo/print3.jpg");
      tracks.add("assets/images/print/buffalo/print4.jpg");

      droppings.add("assets/images/droppings/buffalo/drop1.jpg");
      droppings.add("assets/images/droppings/buffalo/drop2.jpg");
      droppings.add("assets/images/droppings/buffalo/drop3.jpg");
      droppings.add("assets/images/droppings/buffalo/drop4.jpg");

      name = "Cape Buffalo";
    } else if (i == "rhino") {
      appearance.add("assets/images/appearance/rhino/p1.jpg");
      appearance.add("assets/images/appearance/rhino/p2.jpg");
      appearance.add("assets/images/appearance/rhino/p3.jpg");
      appearance.add("assets/images/appearance/rhino/p4.jpg");

      tracks.add("assets/images/print/rhino/print1.jpg");
      tracks.add("assets/images/print/rhino/print2.jpg");
      tracks.add("assets/images/print/rhino/print3.jpg");
      tracks.add("assets/images/print/rhino/print4.jpg");

      droppings.add("assets/images/droppings/rhino/drop1.jpg");
      droppings.add("assets/images/droppings/rhino/drop2.jpg");
      droppings.add("assets/images/droppings/rhino/drop3.jpg");
      name = "Black Rhinoceroses";
    } else if (i == "lion") {
      appearance.add("assets/images/animal/Big_Cats/lion/a1.jpeg");
      appearance.add("assets/images/animal/Big_Cats/lion/a2.jpg");
      appearance.add("assets/images/animal/Big_Cats/lion/a3.jpg");
      appearance.add("assets/images/animal/Big_Cats/lion/a4.jpg");

      tracks.add("assets/images/print/lion/print1.jpg");
      tracks.add("assets/images/print/lion/print2.jpg");
      tracks.add("assets/images/print/lion/print3.jpg");
      tracks.add("assets/images/print/lion/print4.jpg");

      droppings.add("assets/images/droppings/lion/drop1.jpg");
      droppings.add("assets/images/droppings/lion/drop2.jpg");
      droppings.add("assets/images/droppings/lion/drop3.jpg");
      name = "Katanga Lion";
    } else if (i == "leopard") {
      appearance.add("assets/images/appearance/leopard/p1.jpg");
      appearance.add("assets/images/appearance/leopard/p2.jpg");
      appearance.add("assets/images/appearance/leopard/p3.jpg");
      appearance.add("assets/images/appearance/leopard/p4.jpg");

      tracks.add("assets/images/print/leopard/print1.jpg");
      tracks.add("assets/images/print/leopard/print2.jpg");
      tracks.add("assets/images/print/leopard/print3.jpg");

      droppings.add("assets/images/droppings/leopard/drop1.jpg");
      droppings.add("assets/images/droppings/leopard/drop2.jpg");
      droppings.add("assets/images/droppings/leopard/drop3.jpg");
      name = "African Leopard";
    } else if (i == "cheetah") {
      appearance.add("assets/images/appearance/cheetah/p1.jpg");
      appearance.add("assets/images/appearance/cheetah/p2.jpg");
      appearance.add("assets/images/appearance/cheetah/p3.jpg");
      appearance.add("assets/images/appearance/cheetah/p4.jpg");

      tracks.add("assets/images/print/cheetah/print1.jpg");
      tracks.add("assets/images/print/cheetah/print2.jpg");
      tracks.add("assets/images/print/cheetah/print3.jpg");

      droppings.add("assets/images/droppings/cheetah/drop1.jpg");

      name = "South African Cheetah";
    } else if (i == "blesbok") {
      appearance.add("assets/images/appearance/blesbok/p1.jpg");
      appearance.add("assets/images/appearance/blesbok/p2.jpg");
      appearance.add("assets/images/appearance/blesbok/p3.jpg");
      appearance.add("assets/images/appearance/blesbok/p4.jpg");

      tracks.add("assets/images/print/blesbok/print1.jpg");

      droppings.add("assets/images/droppings/blesbok/drop1.jpg");

      name = "Blesbok";
    } else if (i == "springbok") {
      appearance.add("assets/images/appearance/springbok/p1.jpg");
      appearance.add("assets/images/appearance/springbok/p2.jpg");
      appearance.add("assets/images/appearance/springbok/p3.jpg");
      appearance.add("assets/images/appearance/springbok/p4.jpg");

      tracks.add("assets/images/print/springbok/print1.jpg");

      droppings.add("assets/images/droppings/springbok/drop1.jpg");

      name = "Springbok";
    } else if (i == "hartebeest") {
      appearance.add("assets/images/appearance/hartebeest/p1.jpg");
      appearance.add("assets/images/appearance/hartebeest/p2.jpg");
      appearance.add("assets/images/appearance/hartebeest/p3.jpg");
      appearance.add("assets/images/appearance/hartebeest/p4.jpg");

      tracks.add("assets/images/print/blesbok/print1.jpg");

      droppings.add("assets/images/droppings/blesbok/drop1.jpg");

      name = "Red Hartebeest";
    } else {
      appearance.add("assets/images/appearance/blesbok/p1.jpg");
      appearance.add("assets/images/appearance/blesbok/p2.jpg");
      appearance.add("assets/images/appearance/blesbok/p3.jpg");
      appearance.add("assets/images/appearance/blesbok/p4.jpg");

      tracks.add("assets/images/print/blesbok/print1.jpg");

      droppings.add("assets/images/droppings/blesbok/drop1.jpg");
    }

    gallery.add(appearance);
    gallery.add(tracks);
    gallery.add(droppings);
    return GalleryModel(galleryList: gallery, name: name);
  }

  @override
  Future<List<SpoorModel>> getSpoorModel(String name) async {
    SpoorModel card1 = new SpoorModel(
        '',
        'Elephant',
        'African Bush',
        'Kruger park',
        'Kagiso Ndlovu',
        '4m ago',
        '67%',
        'Dangerous',
        'assets/images/Elephant.jpeg');

    SpoorModel card2 = new SpoorModel(
      '',
      'Rhino',
      'White',
      'Kruger park',
      'Pricille Berlien',
      '4m ago',
      '92%',
      'Endangered',
      'assets/images/rhino.jpeg',
    );

    SpoorModel card3 = new SpoorModel(
        '',
        'Buffalo',
        'Cape Buffalo',
        'Kruger park',
        'Charles De Clarke',
        '4m ago',
        '56%',
        'tag1',
        'assets/images/buffalo.jpeg');

    SpoorModel card4 = new SpoorModel(
        '',
        'Springbok',
        'Antelope',
        'Kruger park',
        'Obakeng Seageng',
        '10m ago',
        '87%',
        'Abundant',
        'assets/images/springbok.jpg');

    SpoorModel card5 = new SpoorModel(
        '',
        'Blesbok',
        'Antelope',
        'Kruger park',
        'Zachary Christophers',
        '80m ago',
        '100%',
        'tag4',
        'assets/images/Blesbok.jpg');

    SpoorModel card6 = new SpoorModel(
        '',
        'Red hartebeest',
        'A. buselaphus',
        'Kruger park',
        'Kagiso Ndlovu',
        '1d ago',
        '23%',
        'tag4',
        'assets/images/Red_Hartebeest.jpg');

    List<SpoorModel> _cards = new List();
    if (name == "elephant") {
      _cards.add(card1);
      _cards.add(card2);
      _cards.add(card3);
      _cards.add(card4);
      _cards.add(card5);
      _cards.add(card6);
    } else if (name == "rhino") {
      _cards.add(card2);
      _cards.add(card1);
      _cards.add(card3);
      _cards.add(card4);
      _cards.add(card5);
      _cards.add(card6);
    } else if (name == "buffalo") {
      _cards.add(card3);
      _cards.add(card1);
      _cards.add(card2);
      _cards.add(card4);
      _cards.add(card5);
      _cards.add(card6);
    } else {
      _cards.add(card4);
      _cards.add(card5);
      _cards.add(card6);
      _cards.add(card3);
      _cards.add(card1);
      _cards.add(card2);
    }

    return _cards;
  }

  @override
  Future<SimilarSpoorModel> getSpoorSimilarModel(String animal) async {
    List<String> similarSpoor = new List();
    if (animal == "elephant") {
      similarSpoor.add('assets/images/print/elephant/print1.jpg');
      similarSpoor.add('assets/images/print/elephant/print2.jpg');
      similarSpoor.add('assets/images/print/elephant/print3.jpg');
      similarSpoor.add('assets/images/print/elephant/print4.jpg');
    } else if (animal == "buffalo") {
      similarSpoor.add('assets/images/print/buffalo/print1.jpg');
      similarSpoor.add('assets/images/print/buffalo/print2.jpg');
      similarSpoor.add('assets/images/print/buffalo/print3.jpg');
      similarSpoor.add('assets/images/print/buffalo/print4.jpg');
    } else if (animal == "rhino") {
      similarSpoor.add('assets/images/print/rhino/print1.jpg');
      similarSpoor.add('assets/images/print/rhino/print2.jpg');
      similarSpoor.add('assets/images/print/rhino/print3.jpg');
      similarSpoor.add('assets/images/print/rhino/print4.jpg');
    } else {
      similarSpoor.add('assets/images/print/rhino/print1.jpg');
      similarSpoor.add('assets/images/print/rhino/print2.jpg');
      similarSpoor.add('assets/images/print/rhino/print3.jpg');
      similarSpoor.add('assets/images/print/rhino/print4.jpg');
    }

    SimilarSpoorModel similarSpoorModel = new SimilarSpoorModel(similarSpoor);
    return similarSpoorModel;
  }

  @override
  Future<List<HomeModel>> getHomeModel() async {
    HomeModel card1 = new HomeModel(
        '',
        'Elephant',
        'African Bush',
        'Kruger park',
        'Kagiso Ndlovu',
        '4m ago',
        '67%',
        'Dangerous',
        'assets/images/Elephant.jpeg');

    HomeModel card2 = new HomeModel(
      '',
      'Rhino',
      'White',
      'Kruger park',
      'Pricille Berlien',
      '4m ago',
      '92%',
      'Endangered',
      'assets/images/rhino.jpeg',
    );

    HomeModel card3 = new HomeModel(
        '',
        'Buffalo',
        'Cape Buffalo',
        'Kruger park',
        'Charles De Clarke',
        '4m ago',
        '56%',
        'Abundant',
        'assets/images/buffalo.jpeg');

    HomeModel card4 = new HomeModel(
        '',
        'Springbok',
        'Antelope',
        'Kruger park',
        'Obakeng Seageng',
        '10m ago',
        '87%',
        'Abundant',
        'assets/images/springbok.jpg');

    HomeModel card5 = new HomeModel(
        '',
        'Blesbok',
        'Antelope',
        'Kruger park',
        'Zachary Christophers',
        '80m ago',
        '100%',
        'Abundant',
        'assets/images/Blesbok.jpg');

    HomeModel card6 = new HomeModel(
        '',
        'Hartebeest',
        'A. buselaphus',
        'Kruger park',
        'Kagiso Ndlovu',
        '1d ago',
        '23%',
        'Abundant',
        'assets/images/Red_Hartebeest.jpg');

    List<HomeModel> _cards = new List();
    _cards.add(card1);
    _cards.add(card2);
    _cards.add(card3);
    _cards.add(card4);
    _cards.add(card5);
    _cards.add(card6);

    return _cards;
  }

  @override
  Future<InfoModel> getInfoModel(String name) async {
    InfoModel infoModel;
    List<String> appearance = new List();
    String species;
    String commonName;
    String gestation;
    String diet;
    String overview;
    String description;
    String behaviour;
    String habitat;
    String threat;
    String heightF;
    String heightM;
    String weightF;
    String weightM;
    if (name == "elephant") {
      appearance.add("assets/images/appearance/elephant/p1.jpg");
      appearance.add("assets/images/appearance/elephant/p2.jpg");
      appearance.add("assets/images/appearance/elephant/p3.jpg");
      appearance.add("assets/images/appearance/elephant/p4.jpg");

      species = "African Bush Elephant";
      commonName = "Elephant";
      gestation = "22 months";
      diet = "Herbivore";
      overview =
          "The African bush elephant is the largest land mammal in the world and the largest of the three elephant species.";
      description =
          "The African bush elephant is the largest land mammal in the world and the largest of the three elephant species. Adults reach up to 24 feet in length and 13 feet in height and weigh up to 11 tons. As herbivores, they spend much of their days foraging and eating grass, leaves, bark, fruit, and a variety of foliage. They need to eat about 350 pounds of vegetation every day. African bush elephants are also known as African savanna elephants. Their range spans a variety of habitats, from the open savanna to the desert, and can be found in most African countries. African elephants live up to 70 years—longer than any other mammal except humans. Elephant herds are matriarchal, consisting of related females and their young and are led by the eldest female, called the matriarch. Adult male elephants rarely join a herd and often lead a solitary life, only approaching herds for mating. Females give birth to a single calf after a 22 month gestation, the longest gestation period among mammals.";
      behaviour =
          "African Bush Elephants are nomadic animals meaning that they are constantly on the move in search of food, so moving within these family herds allows them to have greater protection both from predators and from the elements.";
      habitat =
          "African elephants live in sub-Saharan Africa, the rain forests of Central and West Africa and the Sahel desert in Mali. Their Asian contemporaries can be found in Nepal, India and Southeast Asia in scrub forests and rain forests.";
      threat =
          "Escalating poaching, or illegal killing, for the commercial trade in ivory and meat. Growing demands of exploding human populations and poverty. Increasing loss and fragmentation of natural habitats and lack of land-use planning.";
      heightF = "2.4";
      heightM = "3.1";
      weightF = "2.8";
      weightM = "5.8";

      infoModel = new InfoModel(
          species: species,
          commonName: commonName,
          gestation: gestation,
          diet: diet,
          overview: overview,
          description: description,
          behaviour: behaviour,
          habitat: habitat,
          threat: threat,
          heightF: heightF,
          heightM: heightM,
          weightF: weightF,
          weightM: weightM,
          carouselImages: appearance);
      return infoModel;
    } else if (name == "buffalo") {
      appearance.add("assets/images/appearance/buffalo/p1.jpg");
      appearance.add("assets/images/appearance/buffalo/p2.jpg");
      appearance.add("assets/images/appearance/buffalo/p3.jpg");
      appearance.add("assets/images/appearance/buffalo/p4.jpg");

      overview =
          "Cape buffalo, (Syncerus caffer caffer), also called African buffalo, the largest and most formidable of Africa's wild bovids (family Bovidae) and a familiar sight to visitors of African parks and reserves. The Cape buffalo is the only member of the buffalo and cattle tribe (Bovini) that occurs naturally in Africa.";
      description =
          "Depending on the subspecies, African buffalo range in color from dark brown or black (in savannah-living races) to bright red (forest buffalo). The body is heavy-set, with stocky legs, a large head, and short neck. There are no distinct markings on the body, although forest buffalo tend to darken with age and may thus have dark patches mingled with the red base color. The ears are large and tend to droop; they are edged by a long fringe of hairs, including two white tufts in forest buffalo. Both male and female African buffalo have horns; in savannah buffalo, these are hook-shaped, curving first downwards and then hooking up and inwards, and growing up to 160 cm long. The horns of males are larger than females, and in males the bases of the horns expand into a known as a 'boss'. Forest buffalo have much shorter horns (no more than 40 cm long) which are relatively straight and which sweep backwards in line with the forehead.";
      behaviour =
          "African buffalo may be active throughout the day and night; on average, 18 hours per day are spent foraging and moving. Herds usually occupy a stable home range; in savannah buffalo, these areas may be 126 to 1,075 square kilometers in size.";
      habitat =
          "One of the most successful of Africa's wild ruminants, the Cape buffalo thrives in virtually all types of grassland habitat in sub-Saharan Africa, from dry savanna to swamp and from lowland floodplains to montane mixed forest and glades, as long as it is within commuting distance of water (up to 20 km [12 miles]).";
      threat =
          "THREATS: Cape Buffalo are very large animals and apart from big predators, they are not really threatened by other animal species. It usually takes an entire lion pride to catch and kill an adult Cape Buffalo.";

      species = "Cape Buffalo";
      commonName = "Buffalo";
      gestation = "12 months";
      diet = "Herbivore";

      heightF = "2.4";
      heightM = "3.1";
      weightF = "2.8";
      weightM = "5.8";
      infoModel = new InfoModel(
          species: species,
          commonName: commonName,
          gestation: gestation,
          diet: diet,
          overview: overview,
          description: description,
          behaviour: behaviour,
          habitat: habitat,
          threat: threat,
          heightF: heightF,
          heightM: heightM,
          weightF: weightF,
          weightM: weightM,
          carouselImages: appearance);
      return infoModel;
    } else if (name == "rhino") {
      appearance.add("assets/images/appearance/rhino/p1.jpg");
      appearance.add("assets/images/appearance/rhino/p2.jpg");
      appearance.add("assets/images/appearance/rhino/p3.jpg");
      appearance.add("assets/images/appearance/rhino/p4.jpg");

      species = "Black Rhinoceroses ";
      commonName = "Rhino";
      gestation = "16 months";
      diet = "Herbivore";

      overview =
          "Rhinoceroses are large, herbivorous mammals identified by their characteristic horned snouts. The word 'rhinoceros' comes from the Greek 'rhino' (nose) and 'ceros' (horn). There are five species and 11 subspecies of rhino; some have two horns, while others have one.";
      description =
          "Rhinoceroses are large, herbivorous mammals identified by their characteristic horned snouts. The word 'rhinoceros' comes from the Greek 'rhino' (nose) and 'ceros' (horn). There are five species and 11 subspecies of rhino; some have two horns, while others have one.Because the animals' horns are used in folk medicine for their supposed healing properties, rhinos have been hunted nearly to extinction. Their horns are sometimes sold as trophies or decorations, but more often they are ground up and used in traditional Chinese medicine. The powder is often added to food or brewed in a tea in the belief that the horns are a powerful aphrodisiac, a hangover cure and treatment for fever, rheumatism, gout and other disorders, according to the International Rhino Foundation.";
      behaviour =
          "Except for females and their offspring, black rhinos are solitary. Females reproduce only every two and a half to five years. Their single calf does not live on its own until it is about three years old. Black rhinos feed at night and during the gloaming hours of dawn and dusk.";
      habitat =
          "White rhinos and black rhinos live in the grasslands and floodplains of eastern and southern Africa. Greater one-horned rhinos can be found in the swamps and rain forests of northern India and southern Nepal. Sumatran and Javan rhinos are found only in small areas of Malaysian and Indonesian swamps and rain forests.Rhinos spend their days and nights grazing and only sleep during the hottest parts of the day. During the rare times when they aren't eating, they can be found enjoying a cooling mud soak. These soaks also help to protect the animals from bugs, and the mud is a natural sunblock";
      threat =
          "Of all the threats facing black rhinos, poaching is the deadliest. Black rhinos have two horns which make them lucrative targets for the illegal trade in rhino horn A wave of poaching for rhino horn rippled through Kenya and Tanzania, continued south through Zambia's Luangwa Valley as far as the Zambezi River, and spread into Zimbabwe. Political instability and wars have greatly hampered rhino conservation work in Africa, notably in Angola, Rwanda, Somalia, and Sudan. This situation has exacerbated threats such as trade in rhino horn and increased poaching due to poverty.";

      heightF = "2.4";
      heightM = "3.1";
      weightF = "2.8";
      weightM = "5.8";
      infoModel = new InfoModel(
          species: species,
          commonName: commonName,
          gestation: gestation,
          diet: diet,
          overview: overview,
          description: description,
          behaviour: behaviour,
          habitat: habitat,
          threat: threat,
          heightF: heightF,
          heightM: heightM,
          weightF: weightF,
          weightM: weightM,
          carouselImages: appearance);
      return infoModel;
    } else {
      appearance.add("assets/images/animal/Big_Cats/lion/a1.jpeg");
      appearance.add("assets/images/animal/Big_Cats/lion/a2.jpg");
      appearance.add("assets/images/animal/Big_Cats/lion/a3.jpg");
      appearance.add("assets/images/animal/Big_Cats/lion/a4.jpg");

      species = "Katanga Lion ";
      commonName = "Lion";
      diet = "Carnivore";
      gestation = "4 Months";

      overview =
          "Katanga Lion (Southwest Africa Lion) The lion is known as the 'king of the jungle' and is one of the five big cats of the genus Panthera. ... The Katanga lions are found in Namibia, Zaire, Angola, Botswana and Zambia. Their prey mostly include zebras, warthogs, wildebeests and antelopes.";
      description =
          "Panthera leo melanochaita is a lion subspecies in Southern and East Africa. In this part of Africa, lion populations are regionally extinct in Lesotho, Djibouti and Eritrea, and threatened by loss of habitat and prey base, killing by local people in retaliation for loss of livestock, and in several countries also by trophy hunting. Since the turn of the 21st century, lion populations in intensively managed protected areas in Botswana, Namibia, South Africa and Zimbabwe have increased, but declined in East African range countries.In 2005, a Lion Conservation Strategy was developed for East and Southern Africa.";
      behaviour =
          "Lions are highly territorial and occupy the same area for generations. Females actively defend their territories against other females, while resident males protect prides from rival coalitions. Territory size depends on prey abundance, as well as access to water and denning sites.";
      habitat =
          "They are found in southwestern Africa in Angola, Namibia, western Zimbabwe and Zambia, Zaire, and northern Botswana. They are one of the largest lions of all the lion species.";
      threat =
          "Unfortunately, all threats to lions are human based with the top four being habitat loss, trophy hunting, poaching and human-lion conflict. There are currently more lions in captivity than there are in the wild. Unless urgent action is taken, one day there may be none left.";

      heightF = "2.4";
      heightM = "3.1";
      weightF = "2.8";
      weightM = "5.8";
      infoModel = new InfoModel(
          species: species,
          commonName: commonName,
          gestation: gestation,
          diet: diet,
          overview: overview,
          description: description,
          behaviour: behaviour,
          habitat: habitat,
          threat: threat,
          heightF: heightF,
          heightM: heightM,
          weightF: weightF,
          weightM: weightM,
          carouselImages: appearance);
      return infoModel;
    }
  }

  @override
  Future<LoginResponse> getLoginModel(String email, String password) async {
    // TODO: implement getLoginModel
    throw UnimplementedError();
  }

  @override
  Future<List<ProfileModel>> getProfileModel() async {
    ProfileModel card1 = new ProfileModel(
        'Elephant',
        'African Bush',
        'Kruger park',
        'Kagiso Ndlovu',
        '4m ago',
        '67%',
        'Dangerous',
        'assets/images/Elephant.jpeg',
        '1');

    ProfileModel card2 = new ProfileModel(
        'Rhino',
        'White',
        'Kruger park',
        'Pricille Berlien',
        '4m ago',
        '92%',
        'Endangered',
        'assets/images/rhino.jpeg',
        '1');

    ProfileModel card3 = new ProfileModel(
        'Buffalo',
        'Cape Buffalo',
        'Kruger park',
        'Charles De Clarke',
        '4m ago',
        '56%',
        'tag1',
        'assets/images/buffalo.jpeg',
        '1');

    ProfileModel card4 = new ProfileModel(
        'Springbok',
        'Antelope',
        'Kruger park',
        'Obakeng Seageng',
        '10m ago',
        '87%',
        'Abundant',
        'assets/images/springbok.jpg',
        '1');

    ProfileModel card5 = new ProfileModel(
        'Blesbok',
        'Antelope',
        'Kruger park',
        'Zachary Christophers',
        '80m ago',
        '100%',
        'tag4',
        'assets/images/Blesbok.jpg',
        '1');

    ProfileModel card6 = new ProfileModel(
        'Red hartebeest',
        'A. buselaphus',
        'Kruger park',
        'Kagiso Ndlovu',
        '1d ago',
        '23%',
        'tag4',
        'assets/images/Red_Hartebeest.jpg',
        '1');

    List<ProfileModel> _cards = new List();
    _cards.add(card1);
    _cards.add(card2);
    _cards.add(card3);
    _cards.add(card4);
    _cards.add(card5);
    _cards.add(card6);

    return _cards;
  }

  @override
  Future<List<ConfirmModel>> getConfirmModel(
      String pic, String lat, String long) async {
    List<ConfirmModel> identifiedList = new List();
    ConfirmModel identifiedAnimal = ConfirmModel(
        accuracyScore: 82,
        type: "Track",
        animalName: "Elephant",
        species: "African Bush",
        image: "assets/images/Elephant.jpeg");
    ConfirmModel identifiedAnimal1 = ConfirmModel(
        accuracyScore: 32,
        type: "Track",
        animalName: "Antelope",
        species: "Red Hartebeest",
        image: "assets/images/Red_Hartebeest.jpg");
    ConfirmModel identifiedAnimal2 = ConfirmModel(
        accuracyScore: 59,
        type: "Track",
        animalName: "Rhino",
        species: "Black Rhinoceros",
        image: "assets/images/rhino.jpeg");
    ConfirmModel identifiedAnimal3 = ConfirmModel(
        accuracyScore: 32,
        type: "Track",
        animalName: "Springbok",
        species: "Antelope",
        image: "assets/images/springbok.jpg");
    ConfirmModel identifiedAnimal4 = ConfirmModel(
        accuracyScore: 11,
        type: "Track",
        animalName: "Antelope",
        species: "Blesbok",
        image: "assets/images/Blesbok.jpg");

    identifiedList.add(identifiedAnimal);
    identifiedList.add(identifiedAnimal1);
    identifiedList.add(identifiedAnimal2);
    identifiedList.add(identifiedAnimal3);
    identifiedList.add(identifiedAnimal4);
    return identifiedList;
  }

  @override
  Future<TabModel> getTabModel() async {
    List<String> categories = new List();
    categories.add("Appearance");
    categories.add("Tracks");
    categories.add("Droppings");

    return TabModel(categories: categories, length: categories.length);
  }

  @override
  Future<List<String>> getTags() async {
    List<String> tags = new List();
    for (int i = 0; i < 5; i++) {
      int j = i + 1;
      tags.add("Tag $j");
    }
    return tags;
  }

  @override
  Future<int> getUserLevel() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt("accessLevel");
  }

  @override
  void sendConfirmationSpoor(List<ConfirmModel> list, String tag) {
    // TODO: implement sendConfirmationSpoor
  }

  @override
  Future<ProfileInfoModel> getProfileInfoData() async {
    ProfileInfoModel profileInfo = new ProfileInfoModel(
        name: "",
        number: "",
        email: "",
        picture: "",
        animalsTracked: "17",
        spoorIdentified: "150",
        speciesTracked: "38");
    return profileInfo;
  }

  @override
  Future<List<ConfirmModel>> identifyImage(
      String pic, String lat, String long) {
    if (true) {
      return getConfirmModel("", "", "");
    } else {
      return null;
    }
  }

  @override
  Future<List<String>> getAnimalTags() {
    // TODO: implement getAnimalTags
    throw UnimplementedError();
  }

  @override
  Future<ConfirmModel> manualClassification(
      String pic, double lat, double long, double animalID, List<String> tags) {
    // TODO: implement manualClassification
    throw UnimplementedError();
  }

  @override
  Future<double> getAnimalID(String animalName) {
    // TODO: implement getAnimalID
    throw UnimplementedError();
  }

  @override
  Future<List<TrophyModel>> getTrophies() async {
    List<TrophyModel> trophies = new List();
    List<String> trophyTitled = [
      'Trophy 1',
      'Trophy 2',
      'Trophy 3',
      'Trophy 4',
      'Trophy 5',
      'Trophy 6',
      'Trophy 7',
      'Trophy 8',
      'Trophy 9',
      'Trophy 10'
    ];

    List<String> descriptions = [
      'Trophy 1',
      'Trophy 2',
      'Trophy 3',
      'Trophy 4',
      'Trophy 5',
      'Trophy 6',
      'Trophy 7',
      'Trophy 8',
      'Trophy 9',
      'Trophy 10'
    ];

    List<String> images = [
      'assets/images/image.jpg',
      'assets/images/image.jpg',
      'assets/images/image.jpg',
      'assets/images/image.jpg',
      'assets/images/image.jpg',
      'assets/images/image.jpg',
      'assets/images/image.jpg',
      'assets/images/image.jpg',
      'assets/images/image.jpg',
      'assets/images/image.jpg'
    ];
    for (int i = 0; i < trophyTitled.length; i++) {
      trophies.add(new TrophyModel(
          image: images[i],
          descrption: descriptions[i],
          title: trophyTitled[i]));
    }
    return trophies;
  }
}
