import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurnt_rms/bloc/menu_bloc/menu_event.dart';
import 'package:restaurnt_rms/bloc/menu_bloc/menu_state.dart';
import 'package:restaurnt_rms/model/menu_item.dart';
import 'package:restaurnt_rms/repositories/menu_repository.dart';

class MenuBloc extends Bloc<MenuEvent, MenuState> {
  final MenuRepository repository;

  MenuBloc({required this.repository}) : super(MenuInitial()) {
    on<LoadMenu>((event, emit) async {
      emit(MenuLoading());
      try {
        List<MenuItem> items = await repository.getMenuItems();
        emit(MenuLoaded(items: items));
      } catch (e) {
        emit(MenuError(message: e.toString().replaceFirst('Exception:', '')));
      }
    });
  }
}
