import 'package:better_hm/home/dashboard/dashboard_card.dart';
import 'package:better_hm/home/dashboard/dashboard_section.dart';
import 'package:flutter/material.dart';

class MvgSection extends StatelessWidget {
  const MvgSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const DashboardSection(
      title: 'MVG',
      height: 200,
      right: SelectStationWidget(),
      child: Expanded(
        child: DashboardCard(
          child: Text("Hi"),
        ),
      ),
    );
  }
}

class SelectStationWidget extends StatefulWidget {
  const SelectStationWidget({super.key});

  @override
  State<SelectStationWidget> createState() => _SelectStationWidgetState();
}

class _SelectStationWidgetState extends State<SelectStationWidget> {
  late bool useLiveLocation = false;

  @override
  void initState() {
    super.initState();
    useLiveLocation = false;
  }

  liveLocationIndicator() =>
      const [Icon(Icons.my_location_rounded, size: 16), SizedBox(width: 6)];

  showStationSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      enableDrag: true,
      showDragHandle: true,
      useRootNavigator: true,
      builder: (context) => ListView(
        shrinkWrap: true,
        children: const [
          ListTile(
            title: Text("HELLO"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        TextButton(
          onPressed: () => showStationSelector(context),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.fromLTRB(12, 2, 2, 2),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            minimumSize: Size.zero,
          ),
          child: Row(
            children: [
              if (useLiveLocation) ...liveLocationIndicator(),
              const Text("Lothstraße"),
              const SizedBox(width: 4),
              const Icon(Icons.arrow_drop_down_rounded),
            ],
          ),
        ),
      ],
    );
  }
}
