import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tourism_app/core/component/app_bar_sharred.dart';
import 'package:tourism_app/core/utils/constants_models.dart';
import 'package:tourism_app/features/home/data/models/plane_model.dart';
import 'package:tourism_app/features/home/manager/plans/cubit/plans_cubit.dart';
import 'package:tourism_app/features/home/plan/presentation/widgets/plane_card.dart';

class AllPlansView extends StatelessWidget {
  const AllPlansView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: shareAppBar(
        context,
        nameAppBar: 'All Plans',
      ),
      body: SafeArea(
        child: BlocBuilder<PlansCubit, PlansState>(
          builder: (context, state) {
            if (state is PlansLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is PlansError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 60,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Error loading plans',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Text(
                        state.e,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.red,
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        PlansCubit.of(context).getPlans(context: context);
                      },
                      child: Text('Retry'),
                    ),
                  ],
                ),
              );
            } else if (state is PlansSuccess && ConstantsModels.planModel != null && ConstantsModels.planModel!.isNotEmpty) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.8,
                  ),
                  itemCount: ConstantsModels.planModel!.length,
                  itemBuilder: (context, index) {
                    final plan = ConstantsModels.planModel![index];
                    return PlanCardHorizontal(
                      planModel: plan,
                      isHorizontalScroll: false,
                    );
                  },
                ),
              );
            } else {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.map,
                      size: 60,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'No plans available',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Check back later for new travel plans',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey,
                          ),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
