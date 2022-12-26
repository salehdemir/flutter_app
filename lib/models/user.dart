import 'dart:io';

class User {
  final String id;
  final String title;
  final File image;
  final String job;
  final int age;
  final double salary;
  User({
    required this.id,
    required this.title,
    required this.image,
    required this.job,
    required this.age,
    required this.salary,
  });
}

// class Users with ChangeNotifier {
//   List<User> _users = [];
//   List<User> get users {
//     return [..._users];
//   }

//   User findById(String id) {
//     return _users.firstWhere((element) => element.id == id);
//   }

//   Future<void> addUser(
//     String pickedTitle,
//     File pickedImage,
//     String pickedJob,
//     int pickedAge,
//     double pickedSalary,
//   ) async {
//     final url = Uri.parse(
//         'https://my-firstdummy-app-default-rtdb.firebaseio.com/users.json');
//     try {
//       final response = await http.post(
//         url,
//         body: json.encode({
//           'title': pickedTitle,
//           'image': pickedImage.path,
//           'job': pickedJob,
//           'salary': pickedSalary,
//           'age': pickedAge,
//         }),
//       );
//       final newUser = User(
//           id: json.decode(response.body)['name'],
//           title: pickedTitle,
//           image: pickedImage,
//           job: pickedJob,
//           salary: pickedSalary,
//           age: pickedAge);
//       _users.add(newUser);
//       notifyListeners();
//       UserDatabase.insert('add_user', {
//         'id': newUser.id,
//         'title': newUser.title,
//         'image': newUser.image.path,
//         'job': newUser.job,
//         'salary': newUser.salary,
//         'age': newUser.age,
//       });
//     } catch (error) {
//       print(error);
//       throw error;
//     }
//   }

//   Future<void> fetchData() async {
//     final url = Uri.parse(
//         'https://my-firstdummy-app-default-rtdb.firebaseio.com/users.json');

//     try {
//       final response = await http.get(url);
//       final extractedData = json.decode(response.body) as Map<String, dynamic>;
//       final List<User> loadedProducts = [];
//       extractedData.forEach((userId, userData) {
//         loadedProducts.add(User(
//             id: userId,
//             title: userData['title'],
//             image: File(userData['image']),
//             job: userData['job'],
//             age: userData['age'],
//             salary: userData['salary']));
//       });
//       _users = loadedProducts;
//       notifyListeners();
//       final dataList = await UserDatabase.getData('add_user');
//       _users = dataList
//           .map(
//             (item) => User(
//               id: item['id'],
//               title: item['title'],
//               image: File(
//                 item['image'],
//               ),
//               job: item['job'],
//               salary: item['salary'],
//               age: item['age'],
//             ),
//           )
//           .toList();
//     } catch (error) {
//       print(error);
//       throw error;
//     }
//   }

//   Future<void> updateItem(String id, User newUser) async {
//     final userIndex = _users.indexWhere((element) => element.id == id);
//     if (userIndex >= 0) {
//       final url = Uri.parse(
//           'https://my-firstdummy-app-default-rtdb.firebaseio.com/users/$id.json');
//       await http.patch(url,
//           body: json.encode({
//             'title': newUser.title,
//             'image': newUser.image.path,
//             'job': newUser.job,
//             'salary': newUser.salary,
//             'age': newUser.age,
//           }));
//       _users[userIndex] = newUser;
//       notifyListeners();
//     } else {
//       print('...');
//     }
//     UserDatabase.updateData('add_user', {
//       'title': newUser.title,
//       'image': newUser.image.path,
//       'job': newUser.job,
//       'salary': newUser.salary,
//       'age': newUser.age,
//     });
//   }

//   Future<void> removeItem(String id) async {
//     final url = Uri.parse(
//         'https://my-firstdummy-app-default-rtdb.firebaseio.com/users/$id.json');
//     await http.delete(url);
//     _users.removeWhere((element) => element.id == id);
//     notifyListeners();
//     UserDatabase.removeData('add_user', id);
//   }
// }
