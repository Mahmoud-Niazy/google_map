import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_map/business_logic/home_cubit/home_cubit.dart';
import 'package:google_map/presentation/widgets/widgets.dart';

import '../../business_logic/home_cubit/home_states.dart';

class SearchedPlacesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocConsumer<HomeCubit, HomeStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = HomeCubit.get(context);
          return ListView.separated(
            itemBuilder: (context, index) =>
                SearchedPlaceModel(place: cubit.places[index]),
            separatorBuilder: (context, index) => SizedBox(
              height: 0,
            ),
            itemCount: cubit.places.length,
          );
        },
      ),
    );
  }
}
