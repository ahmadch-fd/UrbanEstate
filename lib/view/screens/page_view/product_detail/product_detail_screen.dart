import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/utils.dart';
import 'package:google_fonts/google_fonts.dart';

class PropertyDetailsScreen extends StatefulWidget {
  const PropertyDetailsScreen({super.key});

  @override
  State<PropertyDetailsScreen> createState() => _PropertyDetailsScreenState();
}

class _PropertyDetailsScreenState extends State<PropertyDetailsScreen> {
  int _currentPage = 0;
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    final Color forestGreen = const Color(0xFF004D40);
    final Color limeGreen = const Color(0xFFC6FF00);

    return SafeArea(
      child: Scaffold(
        backgroundColor: forestGreen,
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Header Image Section
                  _buildHeaderImage(),

                  // 2. Details Content
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTitleAndLocation(limeGreen),
                        const SizedBox(height: 20),
                        _buildDescription(),
                        const SizedBox(height: 20),
                        _buildAmenitiesRow(),
                        const SizedBox(height: 25),
                        _buildOwnerSection(),
                        const SizedBox(height: 20),
                        // 3. Map Section
                        _buildMapPreview(limeGreen),
                        const SizedBox(height: 100), // Space for bottom bar
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // 4. Floating Top Buttons
            _buildFloatingTopButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderImage() {
    final List<String> imageUrls = [
      'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?q=80&w=800',
      'https://images.unsplash.com/photo-1618221195710-dd6b41faaea6?q=80&w=1400',
      'https://images.unsplash.com/photo-1522771739844-6a9f6d5f14af?q=80&w=1400',
      'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?q=80&w=1400',
    ];

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        // SWIPEABLE IMAGE SECTION
        SizedBox(
          height: 350,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            itemCount: imageUrls.length,
            itemBuilder: (context, index) {
              return Image.network(
                imageUrls[index],
                fit: BoxFit.cover,
                width: double.infinity,
                // Adding an error builder to prevent the 404 issue we!
                errorBuilder: (context, error, stackTrace) =>
                    const Center(child: Icon(Icons.broken_image, size: 50)),
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child; // The image is fully loaded, return it!
                  }
                  return Center(
                    child: CircularProgressIndicator(
                      color: const Color(0xFFC6FF00),
                       // Using your limeGreen cirlcular indictor color
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
              );
            },
          ),
        ),

        // INDICATOR DOTS
        Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              imageUrls.length,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                // Logical Fix: Check index against _currentPage
                width: _currentPage == index ? 20 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _currentPage == index
                      ? const Color(0xFFC6FF00) // Active color
                      : Colors.white70, // Inactive color
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTitleAndLocation(Color lime) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Prestige Grand Apartment',
                style: GoogleFonts.poppins(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _iconText(Icons.location_on, 'San Francisco, CA', lime),
            const SizedBox(height: 8),
            _iconText(Icons.square_foot, '3480 Sq. Ft', lime),
          ],
        ),
      ],
    );
  }

  Widget _iconText(IconData icon, String label, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 16),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome to Your New Home! This Modern and Spacious 2-Bedroom apartment is located in the heart of San Francisco...',
          style: GoogleFonts.poppins(color: Colors.white70, height: 1.5),
        ),
        Text(
          'Read More..',
          style: TextStyle(
            color: const Color(0xFFC6FF00),
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildAmenitiesRow() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _amenityChip(Icons.king_bed, '2 Bedroom'),
          _amenityChip(Icons.bathtub, '3 Bathroom'),
          _amenityChip(Icons.local_parking, 'Parking'),
        ],
      ),
    );
  }

  Widget _amenityChip(IconData icon, String label) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFFC6FF00), size: 20),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  Widget _buildOwnerSection() {
    return Row(
      children: [
        const CircleAvatar(
          radius: 25,
          backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=owner'),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'William Henry',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text('Owner', style: TextStyle(color: Colors.white60)),
          ],
        ),
        const Spacer(),
        circleIconButton(Icons.phone),
        const SizedBox(width: 10),
        circleIconButton(Icons.chat_bubble),
      ],
    );
  }

  Widget _buildMapPreview(Color lime) {
    return Container(
      height: 180,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: const DecorationImage(
          image: NetworkImage(
            'https://miro.medium.com/v2/resize:fit:1400/1*q66upYI1o16f2Q8eYnS79w.png',
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            colors: [Colors.black.withValues(alpha: 0.4), Colors.transparent],
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '\$4,659',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'Monthly Rent',
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: lime,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 15,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                'Contact',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingTopButtons() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            circleIconButton(
              ontap: () {
                Get.back();
              },
              Icons.arrow_back_ios_new,
              bgColor: Colors.white.withValues(alpha: 0.3),
            ),
            circleIconButton(
              ontap: () {},
              Icons.bookmark_border,
              bgColor: Colors.white.withValues(alpha: 0.3),
            ),
          ],
        ),
      ),
    );
  }

  Widget circleIconButton(
    IconData icon, {
    Color bgColor = const Color(0xFF004D40),
    void Function()? ontap,
  }) {
    return InkWell(
      onTap: ontap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: bgColor,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white24),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
