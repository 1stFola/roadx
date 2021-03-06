// import 'package:lenders/src/helpers/connection.helper.dart';
// import 'package:lenders/src/models/item_model.dart';
// import 'package:lenders/src/models/response.model.dart';
// import 'package:lenders/src/repositories/sources/network/news_api_provider.dart';
// import 'package:lenders/src/repositories/sources/network/news_db_provider.dart';
// import 'package:lenders/src/repositories/sources/network/auth.service.dart';
//
// class StoryRepository {
//   AuthService api = AuthService();
//
//   List<Source> sources = <Source>[
//     newsDBProvider,
//     NewsApiProvider(),
//   ];
//
//   List<Cache> caches = <Cache>[
//     newsDBProvider,
//   ];
//
//
//   Future<List<int>> fetchTopIds() {
//     return sources[1].fetchTopIds();
//   }
//
//   Future<ItemModel> fetchItem(int id) async {
//     ItemModel itemModel;
//     Source source;
//
//     for(source in sources) {
//       itemModel = await source.fetchItem(id);
//       if(itemModel != null) {
//         break;
//       }
//     }
//
//     for(var cache in caches) {
//       if(cache != source) {
//         cache.addItem(itemModel);
//       }
//     }
//
//     return itemModel;
//   }
//
//   clearCache() async {
//     for (var cache in caches) {
//       await cache.clear();
//     }
//   }
// }
//
// abstract class Source {
//   Future<List<int>> fetchTopIds();
//
//   Future<ItemModel> fetchItem(int id);
// }
//
// abstract class Cache {
//   Future<int> addItem(ItemModel itemModel);
//   Future<int> clear();
// }