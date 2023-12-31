import 'package:my_app/domain/model/user/user.model.dart';
import 'package:my_app/repository/user/user.repository.dart';

import '../../core/response/response.dart';
import '../base/remote.usecase.dart';

class SearchUserByNicknameUsecase extends RemoteUsecase<UserRepository> {
  SearchUserByNicknameUsecase(this.nickname);

  final String nickname;

  @override
  Future call(UserRepository repository) async {
    if (nickname.isEmpty) {
      return const Response<List<UserModel>>(
          status: Status.warning, message: 'keyword is empty');
    }
    return await repository.findUserByNickname(nickname);
  }
}
