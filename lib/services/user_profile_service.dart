import 'package:campus_connect/utils/constants.dart';
import 'package:supabase/supabase.dart';

class UserProfileService {
  isUserProfileFound(String id) async {
    final res = await supabase
        .from('profiles')
        .select()
        .eq('id', id)
        .select()
        .execute(count: CountOption.exact);
    return res.count;
  }
}
