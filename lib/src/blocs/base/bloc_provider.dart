import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roadx/src/blocs/MapModel.dart';
import 'package:roadx/src/blocs/PermissionHandlerBloc.dart';
import 'package:roadx/src/blocs/SocketBloc.dart';
import 'package:roadx/src/blocs/UINotifiersBloc.dart';
import 'package:roadx/src/blocs/auth.bloc.dart';
import 'package:roadx/src/blocs/register.bloc.dart';
import 'package:roadx/src/blocs/validateRegister.bloc.dart';


class BlocProvider extends StatelessWidget {
  final Widget child;

  const BlocProvider({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Provider.debugCheckInvalidValueType = null;

    return MultiProvider(
        providers: [
          ChangeNotifierProvider<AuthBloc>(
            create: (_) => AuthBloc(),
          ),
          ChangeNotifierProvider<SocketBloc>(
            create: (_) => SocketBloc(),
          ),
          ChangeNotifierProvider<MapBloc>(
            create: (_) => MapBloc(),
          ),
          ChangeNotifierProvider<PermissionHandlerBloc>(
            create: (_) => PermissionHandlerBloc(),
          ),
          ChangeNotifierProvider<RegisterBloc>(
            create: (_) => RegisterBloc(),
          ),
          ChangeNotifierProvider<UINotifiersBloc>(
            create: (_) => UINotifiersBloc(),
          ),
          ChangeNotifierProvider<ValidateRegisterBloc>(
            create: (_) => ValidateRegisterBloc(),
          ),
          ChangeNotifierProxyProvider<SocketBloc, MapBloc>(
              create: (_) => MapBloc(),
              update: (_, socket, ma) => ma..socket = socket.socket,
          )
        ],
        child: child
    );
  }
}