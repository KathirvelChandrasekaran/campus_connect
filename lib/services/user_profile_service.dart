import 'package:campus_connect/utils/constants.dart';

class UserProfileService {
  Future<int> isUserProfileFound(String id) async {
    final res =
        await supabase.from('profile').select().eq('id', id).select().execute();
    return res.data ?? 0;
  }
}
