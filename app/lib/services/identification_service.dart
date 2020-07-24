import 'package:injectable/injectable.dart';
import 'package:observable_ish/observable_ish.dart';
import 'package:stacked/stacked.dart';
import 'datamodels/api_models.dart';

@lazySingleton
class IdentificationService with ReactiveServiceMixin{
  RxValue<SpoorModel> confident = RxValue<SpoorModel>(initial: null);
  RxList<SpoorModel> recentIdentifications = RxList<SpoorModel>();

  SpoorModel get confidentGetter => confident.value;
  List<SpoorModel> get recentIdentificationGetter => recentIdentifications;

  IdentificationService(){
    listenToReactiveValues([confident,recentIdentifications]);
  }

  void setConfident(SpoorModel _confident){
    this.confident.value = _confident;
  }

  void setRecentIdentifications(List<SpoorModel> _recentIdentifications){
    this.recentIdentifications.clear();
    this.recentIdentifications.addAll(_recentIdentifications);
  }
  
  void reclassify(int index){
    print("$index========");
    print(confident.value.name);
    recentIdentifications.add(confident.value);
    confident.value = recentIdentifications[index];
    print(confident.value.name);
    recentIdentifications.removeAt(index);
  }
}