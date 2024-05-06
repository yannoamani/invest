import 'package:invest_mobile/model/role.dart';
import 'package:invest_mobile/model/user.dart';

class RoleUser {
  int id;
  Role role;
  User person;

  RoleUser({required this.id, required this.role, required this.person});
}
