import 'package:data_messaging/viewmodels/notification_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> get appProviders => [
      ChangeNotifierProvider(
        create: (context) => NotificationViewModel(),
      ),
    ];
