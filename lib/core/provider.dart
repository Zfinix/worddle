import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'viewmodels/viewmodels.dart';

final gameVM = ChangeNotifierProvider((_) => GameVM(_.read));
