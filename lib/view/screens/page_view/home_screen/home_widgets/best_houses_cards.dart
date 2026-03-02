import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// class BestHousesCards extends StatelessWidget {
//   const BestHousesCards({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final double height = MediaQuery.of(context).size.height;
//     final double width = MediaQuery.of(context).size.width;
//     return SizedBox(
//       height: height * 0.4,
//       child: ListView.builder(
//         scrollDirection: Axis.vertical,
//         itemCount: 3,
//         itemBuilder: (context, index) {
//           return Padding(
//             padding: const EdgeInsets.only(left: 13),
//             child: Stack(
//               children: [

//                 Container(
//                   height: height * 0.34,
//                   width: width * 0.92,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(20),
//                     color: const Color.fromARGB(255, 150, 93, 93),
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
class BestForYouCard extends StatelessWidget {
  const BestForYouCard({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> networkImagelength = [
      'https://images.unsplash.com/photo-1564013799919-ab600027ffc6?q=80&w=800',
      'https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?q=80&w=800',
      'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?q=80&w=800',
    ];
    List<String> housetype = [
      'Dreamsville House',
      'Sunset Villa',
      'Oceanview Apartment',
    ];
    List<String> priceshouse = ['\$3,850', '\$4,200', '\$2,950'];
    List<String> locationshouse = [
      'Jl. Sultan Iskandar Muda',
      'Jl. Pantai Indah Kapuk',
      'Jl. Kemang Raya',
    ];
    List<String> buytype = ['Monthly Rent', 'For Sale', 'Monthly Rent'];
    return ListView.builder(
      itemCount: 3,
      shrinkWrap: true,

      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Main Property Image
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  networkImagelength[index],
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 12),
              // Property Title and Price
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    housetype[index],
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    priceshouse[index],
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: const Color(0xFF004D40), // Forest Green
                    ),
                  ),
                ],
              ),
              // Location and Action Button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    locationshouse[index],
                    style: GoogleFonts.poppins(
                      color: Colors.black54,
                      fontSize: 12,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFC6FF00), // Lime Green
                      foregroundColor: const Color(0xFF004D40),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('See Details'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
