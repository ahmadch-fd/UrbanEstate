// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:urban_estate/controllers/add_property_screen_controller.dart';
// import 'package:urban_estate/view/screens/page_view/home_screen/add_property.dart/widgets/custom_app_bar.dart';
// import 'package:urban_estate/view/screens/page_view/home_screen/add_property.dart/widgets/custom_primary_button.dart';
// import 'package:urban_estate/view/screens/page_view/home_screen/add_property.dart/widgets/input_field.dart';
// import 'package:urban_estate/view/screens/page_view/home_screen/add_property.dart/widgets/primary_selection_button.dart';
// import 'package:urban_estate/view/screens/page_view/home_screen/add_property.dart/widgets/property_stepper_indicator.dart';

// class AddProperty extends StatelessWidget {
//   const AddProperty({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final ctrl = Get.put(AddProperty1Controller());

//     return Scaffold(
//       backgroundColor: const Color(0xFFF5F7F5),
//       appBar: _buildAppBar(),
//       body: Column(
//         children: [
//           const PropertyStepperIndicator(current: 1, total: 4),
//           Expanded(
//             child: SingleChildScrollView(
//               //   physics: const BouncingScrollPhysics(),
//               padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // ── Basic Details ──────────────────────────────────────
//                   const PropertySectionLabel(title: 'Basic Details'),

//                   Obx(
//                     () => PropertyDropdownField(
//                       label: 'Available From',
//                       options: ctrl.availableFromOptions,
//                       value: ctrl.availableFrom.value,
//                       onChanged: ctrl.setAvailableFrom,
//                     ),
//                   ),

//                   Obx(
//                     () => PropertyDropdownField(
//                       label: 'Type of Property',
//                       options: ctrl.propertyTypeOptions,
//                       value: ctrl.propertyType.value,
//                       onChanged: ctrl.setPropertyType,
//                     ),
//                   ),

//                   // ── Room Configuration ─────────────────────────────────
//                   const PropertySectionLabel(title: 'Room Configuration'),

//                   Obx(
//                     () => PropertyDropdownField(
//                       label: 'Bedrooms',
//                       options: ctrl.bedroomsOptions,
//                       value: ctrl.bedrooms.value,
//                       onChanged: ctrl.setBedrooms,
//                     ),
//                   ),

//                   Obx(
//                     () => PropertyDropdownField(
//                       label: 'Bathrooms',
//                       options: ctrl.bathroomsOptions,
//                       value: ctrl.bathrooms.value,
//                       onChanged: ctrl.setBathrooms,
//                     ),
//                   ),

//                   Obx(
//                     () => PropertyDropdownField(
//                       label: 'Balcony',
//                       options: ctrl.balconyOptions,
//                       value: ctrl.balcony.value,
//                       onChanged: ctrl.setBalcony,
//                     ),
//                   ),

//                   // ── Location & Size ────────────────────────────────────
//                   const PropertySectionLabel(title: 'Location & Size'),

//                   Obx(
//                     () => PropertyDropdownField(
//                       label: 'Floor No',
//                       options: ctrl.floorNoOptions,
//                       value: ctrl.floorNo.value,
//                       onChanged: ctrl.setFloorNo,
//                     ),
//                   ),

//                   PropertyInputField(
//                     hint: 'Size (sq ft) – Optional',
//                     keyboardType: TextInputType.number,
//                     inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//                     initialValue: ctrl.size.value.isEmpty
//                         ? null
//                         : ctrl.size.value,
//                     onChanged: ctrl.setSize,
//                   ),

//                   const SizedBox(height: 12),

//                   PropertyPrimaryButton(label: 'Next', onPressed: ctrl.onNext),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   PreferredSizeWidget _buildAppBar() {
//     return AppBar(
//       backgroundColor: Colors.white,
//       elevation: 0,
//       systemOverlayStyle: SystemUiOverlayStyle.dark,
//       leading: IconButton(
//         icon: const Icon(
//           Icons.chevron_left_rounded,
//           color: Colors.black87,
//           size: 28,
//         ),
//         onPressed: () => Get.back(),
//       ),
//       title: const Text(
//         'Post Your Property',
//         style: TextStyle(
//           color: Colors.black87,
//           fontSize: 17,
//           fontWeight: FontWeight.w600,
//           letterSpacing: 0.1,
//         ),
//       ),
//       centerTitle: true,
//       bottom: PreferredSize(
//         preferredSize: const Size.fromHeight(1),
//         child: Divider(height: 1, color: Colors.grey.shade200),
//       ),
//     );
//   }
// }
