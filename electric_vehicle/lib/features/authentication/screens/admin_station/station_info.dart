import 'package:electric_vehicle/common/widgets/custom_shapes/container/rounded_container.dart';
import 'package:electric_vehicle/common/widgets/images/ev_rounded_image.dart';
import 'package:electric_vehicle/features/authentication/screens/admin_station/port/controller/port_controller.dart';
import 'package:electric_vehicle/features/authentication/screens/admin_station/update/port/change_port_detail.dart';
import 'package:electric_vehicle/features/authentication/screens/admin_station/update/station/change_station_detail.dart';
import 'package:electric_vehicle/features/authentication/screens/admin_station/widgets/circular_fab_widget.dart';
import 'package:electric_vehicle/features/authentication/screens/station/station_title_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../common/widgets/effect/shimmer.dart';
import '../../../../common/widgets/heading/section_heading.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/text_strings.dart';
import '../../../../utils/helpers/helper_functions.dart';
import 'controller/station_controller.dart';

class StationInformationScreen extends StatelessWidget {
  const StationInformationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(StationController());
    final portController = Get.put(PortController());
    final dark = EVHelperFunctions.isDarkMode(context);

    return Scaffold(
        appBar:
            EVAppBar(showBackArrow: false, title: Text('Station Information', style: Theme.of(context).textTheme.headlineMedium,)),
        floatingActionButton: CircularFabButton(key: UniqueKey()),
        body: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.all(EVSizes.defaultSpace),
              child: Obx(() {
                final station = controller.station.value;

                return Column(
                    children: [
                SizedBox(
                child: Stack(
                alignment: Alignment.topRight,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Obx(() {
                          final networkImage = controller.station.value.profilePicture;
                          final image = networkImage.isNotEmpty ? networkImage : EVImages.stationInfo;
                          return controller.imageUploading.value
                              ? const EVShimmerEffect(width: 80, height: 80, radius: 80)
                              : EVRoundedImage(
                            width: double.infinity,
                            imageUrl: image,
                            applyImageRadius: true,
                            isNetworkImage: networkImage.isNotEmpty,
                          );
                        }),
                      ],
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: IconButton(
                        onPressed: () => controller.uploadStationProfilePicture(),
                        icon: const Icon(Iconsax.camera,
                            color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
                ),
                  const SizedBox(height: EVSizes.spaceBtwSections),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          EVSectionHeading(
                              title: station.stationName,
                              showActionButton: false),
                          IconButton(
                              onPressed: () =>
                                  Get.to(() => const ChangeStationDetail()),
                              icon: const Icon(Iconsax.edit)),
                        ],
                      ),
                      const SizedBox(height: EVSizes.spaceBtwItems/2),
                      Row(
                        children: [
                          Text(station.description,
                              style: Theme.of(context).textTheme.bodyMedium),
                        ],
                      ),
                      const SizedBox(height: EVSizes.spaceBtwItems),
                      Column(
                        children: [
                          Row(
                            children: [
                              const EVStationTitleText(title: 'Register No: '),
                              const SizedBox(width: EVSizes.spaceBtwItems),
                              Text(station.registerNumber,
                                  style:
                                      Theme.of(context).textTheme.bodyMedium),
                            ],
                          ),
                          const SizedBox(height: EVSizes.spaceBtwItems),
                          Row(
                            children: [
                              const EVStationTitleText(title: 'Phone No:'),
                              const SizedBox(width: EVSizes.spaceBtwItems),
                              Text(station.stationPhoneNumber,
                                  style:
                                      Theme.of(context).textTheme.bodyMedium),
                            ],
                          ),
                          const SizedBox(height: EVSizes.spaceBtwItems),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            // Align children to the top
                            children: [
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment
                                    .start, // Align children to the start
                                children: [
                                  EVStationTitleText(title: 'Address:'),
                                  SizedBox(height: EVSizes.spaceBtwItems),
                                  // Adjust spacing as needed
                                ],
                              ),
                              const SizedBox(width: EVSizes.spaceBtwItems),
                              // Adjust spacing as needed
                              Flexible(
                                child: Text(
                                  station.stationAddress,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: EVSizes.spaceBtwItems),
                          Row(
                            children: [
                              const Expanded(
                                child:
                                    EVStationTitleText(title: 'Open Hours: '),
                              ),
                              Obx(() {
                                return Text(
                                  controller.is24HourOpen.value == true
                                      ? 'Open 24 Hours'
                                      : 'Not Open 24 Hours',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                );
                              }),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: EVSizes.spaceBtwSections),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(EVTexts.availablePorts,
                          style: Theme.of(context).textTheme.titleLarge),
                      ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: portController.availablePorts.length,
                          itemBuilder: (BuildContext context, int index) {
                            final port = portController.availablePorts[index];

                            return Padding(
                              padding:
                                  const EdgeInsets.all(EVSizes.defaultSpace),
                              child: EVRoundedContainer(
                                showBorder: true,
                                padding:
                                    const EdgeInsets.all(EVSizes.defaultSpace),
                                backgroundColor:
                                    dark ? EVColors.dark : EVColors.white,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(port.portType,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge),
                                        Text('.',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge),
                                        Text(port.capacity,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge),
                                      ],
                                    ),
                                    const SizedBox(height: EVSizes.spaceBtwItems),
                                    Row(
                                      children: [
                                        const Text('Total: '),
                                        const SizedBox(width: EVSizes.spaceBtwItems),
                                        Text(port.noOfPort, style: Theme.of(context).textTheme.bodyLarge),
                                        const Spacer(),
                                        IconButton(onPressed: () => Get.to(() => const ChangePortDetail(),
                                          arguments: port,
                                        ),
                                            icon: const Icon(Iconsax.edit)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                      const SizedBox(height: EVSizes.spaceBtwSections / 2),
                    ],
                  ),
                ]
                );
              })
          ),
        )
    );
  }
}
