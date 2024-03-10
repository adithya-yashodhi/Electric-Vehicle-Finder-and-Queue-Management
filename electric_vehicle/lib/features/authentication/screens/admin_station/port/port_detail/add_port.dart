import 'package:electric_vehicle/features/authentication/screens/admin_station/port/controller/port_controller.dart';
import 'package:electric_vehicle/features/authentication/screens/admin_station/port/port_detail/port_collection.dart';
import 'package:flutter/material.dart';

import '../../../../../../common/widgets/appbar/appbar.dart';
import '../../../../../../utils/constants/image_strings.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../../utils/validation/validator.dart';

class AddPortScreen extends StatefulWidget {
  const AddPortScreen({super.key});

  @override
  State<AddPortScreen> createState() => _AddPortScreenState();
}

class _AddPortScreenState extends State<AddPortScreen> {

  @override
  Widget build(BuildContext context) {
    final controller = PortController.instance;
    return Scaffold(
      appBar: EVAppBar(showBackArrow: true, title: Text('Add new Port',style: Theme.of(context).textTheme.headlineSmall)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(EVSizes.defaultSpace),
          child: Column(
            children: [
              PortCollection(
                onItemClicked: (title) {
                  setState(() {
                    controller.portType.text = title;
                  });
                },
                images: const [
                  EVImages.type1,
                  EVImages.type2,
                  EVImages.chadeMO,
                  EVImages.superCharger
                ],
              ),
              Form(
                key: controller.portFormKey,
                child: Column(
                  children: [
                    TextFormField(
                        controller: controller.portType,
                        validator: (value) => EVValidator.validateEmptyText('Port', value),
                        decoration: const InputDecoration(labelText: 'Port')),
                    const SizedBox(height: EVSizes.spaceBtwInputFields),
                    TextFormField(
                        controller: controller.noOfPorts,
                        validator: (value) => EVValidator.validateEmptyText('Number of Ports', value),
                        decoration: const InputDecoration(labelText: 'Number of Ports')),
                    const SizedBox(height: EVSizes.spaceBtwInputFields),
                    TextFormField(
                        controller: controller.capacity,
                        validator: (value) => EVValidator.validateEmptyText('Capacity', value),
                        decoration: const InputDecoration(labelText: 'Capacity')),
                    const SizedBox(height: EVSizes.spaceBtwInputFields),
                    TextFormField(
                        controller: controller.charge,
                        validator: (value) => EVValidator.validateEmptyText('Fee for Charging (LKR)', value),
                        decoration: const InputDecoration(labelText: 'Fee for Charging (LKR)')),
                    const SizedBox(height: EVSizes.spaceBtwInputFields),
                    TextFormField(
                        controller: controller.speed,
                        validator: (value) => EVValidator.validateEmptyText('Charging Speed', value),
                        decoration: const InputDecoration(labelText: 'Charging Speed')),
                    const SizedBox(height: EVSizes.spaceBtwInputFields),
                    Row(
                      children: [
                        Expanded(child: ElevatedButton(onPressed: () => controller.savePortDetail(), child: const Text('Save'))),
                        const SizedBox(width: EVSizes.spaceBtwInputFields),
                        Expanded(child: OutlinedButton(onPressed: () => controller.cancel(),style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.red),),
                            child: const Text('Cancel', style: TextStyle(color: Colors.red)))),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
