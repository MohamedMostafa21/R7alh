import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tourism_app/core/utils/constants_models.dart';
import 'package:tourism_app/features/home/data/models/plane_model.dart';
import 'package:tourism_app/features/home/manager/plans/cubit/plans_cubit.dart';
import 'package:tourism_app/features/home/plan/presentation/widgets/plane_card.dart';

class PlansSection extends StatelessWidget {
  const PlansSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlansCubit, PlansState>(
      builder: (context, state) {
        if (state is PlansLoading) {
          return SizedBox(
            height: 170,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (state is PlansError) {
          return SizedBox(
            height: 170,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 40,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Error loading plans',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  SizedBox(height: 4),
                  Text(
                    state.e,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.red,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        } else if (state is PlansSuccess && ConstantsModels.planModel != null && ConstantsModels.planModel!.isNotEmpty) {
          // Show only first 4 plans
          final displayPlans = ConstantsModels.planModel!.take(4).toList();
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: displayPlans.map((plan) {
                  return PlanCardHorizontal(planModel: plan);
                }).toList(),
              ),
            ),
          );
        } else {
          // Initial state or no data - show placeholder cards
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: List.generate(3, (index) {
                  return PlanCardHorizontal();
                }),
              ),
            ),
          );
        }
      },
    );
  }
}
