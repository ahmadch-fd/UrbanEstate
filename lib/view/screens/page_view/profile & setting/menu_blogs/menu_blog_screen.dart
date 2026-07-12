import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:urban_estate/utils/app_colors.dart';
import 'package:urban_estate/utils/app_const.dart';
import 'package:urban_estate/utils/responsive.dart';

class MenuBlogScreen extends StatelessWidget {
  const MenuBlogScreen({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.sections,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final List<MenuBlogSection> sections;

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.forestGreen.withValues(alpha: 0.08),
        elevation: 0,
        leading: IconButton(
          onPressed: Get.back,
          icon: const Icon(LucideIcons.arrowLeft, color: AppColors.forestGreen),
        ),
        title: Text(
          title,
          style: poppinsSemiBold.copyWith(
            color: AppColors.mainTextColor,
            fontSize: responsive.font(18),
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          responsive.pagePadding,
          responsive.space(18),
          responsive.pagePadding,
          responsive.bottomNavSpace,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(responsive.space(18)),
              decoration: BoxDecoration(
                color: AppColors.forestGreen,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                children: [
                  Container(
                    height: responsive.scale(48),
                    width: responsive.scale(48),
                    decoration: const BoxDecoration(
                      color: AppColors.primaryButtonColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: AppColors.forestGreen),
                  ),
                  SizedBox(width: responsive.space(14)),
                  Expanded(
                    child: Text(
                      subtitle,
                      style: poppinsRegular.copyWith(
                        color: Colors.white.withValues(alpha: 0.88),
                        fontSize: responsive.font(13),
                        height: 1.45,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: responsive.space(18)),
            ...sections.map(
              (section) => Padding(
                padding: EdgeInsets.only(bottom: responsive.space(14)),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(responsive.space(16)),
                  decoration: BoxDecoration(
                    color: AppColors.forestGreen.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.forestGreen.withValues(alpha: 0.08),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        section.heading,
                        style: poppinsSemiBold.copyWith(
                          color: AppColors.forestGreen,
                          fontSize: responsive.font(15),
                        ),
                      ),
                      SizedBox(height: responsive.space(8)),
                      Text(
                        section.body,
                        style: poppinsRegular.copyWith(
                          color: Colors.black.withValues(alpha: 0.66),
                          fontSize: responsive.font(13),
                          height: 1.55,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MenuBlogSection {
  const MenuBlogSection({required this.heading, required this.body});

  final String heading;
  final String body;
}

class MenuBlog {
  const MenuBlog({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.sections,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final List<MenuBlogSection> sections;

  factory MenuBlog.security() {
    return const MenuBlog(
      title: 'Security',
      subtitle:
          'Simple habits that help keep your Urban Estate account and property data protected.',
      icon: LucideIcons.shieldCheck,
      sections: [
        MenuBlogSection(
          heading: 'Use a strong password',
          body:
              'Choose a password that is difficult to guess and avoid using the same password on multiple apps. A strong password protects your profile, posted properties, and chat history.',
        ),
        MenuBlogSection(
          heading: 'Keep your account private',
          body:
              'Do not share your login details with anyone. If another person can access your account, they may edit your profile, post fake properties, or message other users from your name.',
        ),
        MenuBlogSection(
          heading: 'Verify property communication',
          body:
              'When someone contacts you about a property, keep the conversation professional and avoid sharing sensitive documents before confirming the person and purpose.',
        ),
      ],
    );
  }

  factory MenuBlog.privacy() {
    return const MenuBlog(
      title: 'Privacy',
      subtitle:
          'How your profile, contact information, and property details are used inside the app.',
      icon: LucideIcons.lock,
      sections: [
        MenuBlogSection(
          heading: 'Profile information',
          body:
              'Your name, phone number, email, and profile photo are used to identify you as a property owner or buyer. This makes property communication clearer and more trustworthy.',
        ),
        MenuBlogSection(
          heading: 'Property information',
          body:
              'When you post a property, details such as city, province, price, area, purpose, and contact number may be shown to users who view your listing.',
        ),
        MenuBlogSection(
          heading: 'Control what you share',
          body:
              'Only upload information that you are comfortable sharing with interested users. Avoid adding personal documents, private addresses, or unnecessary sensitive data in descriptions.',
        ),
      ],
    );
  }

  factory MenuBlog.unlockProperties() {
    return const MenuBlog(
      title: 'Unlock Properties',
      subtitle:
          'A guide for future premium property visibility and buyer access features.',
      icon: LucideIcons.unlock,
      sections: [
        MenuBlogSection(
          heading: 'What unlocking means',
          body:
              'Unlocking properties can be used for premium access, featured listings, or special property details. This section is prepared for future monetization and advanced visibility features.',
        ),
        MenuBlogSection(
          heading: 'For property owners',
          body:
              'Owners may later be able to highlight their listings, reach more users, or unlock extra promotion tools to improve property visibility.',
        ),
        MenuBlogSection(
          heading: 'For buyers',
          body:
              'Buyers may later get access to additional filters, verified listings, or saved premium property collections. The current app keeps this section informational until the feature is enabled.',
        ),
      ],
    );
  }

  factory MenuBlog.reportProblem() {
    return const MenuBlog(
      title: 'Report a Problem',
      subtitle:
          'What to do when you find fake listings, incorrect data, or suspicious user behavior.',
      icon: LucideIcons.alertTriangle,
      sections: [
        MenuBlogSection(
          heading: 'Report fake listings',
          body:
              'If a property appears fake, misleading, copied, or uses incorrect photos, report it with the property title, owner name, and the reason you believe it is incorrect.',
        ),
        MenuBlogSection(
          heading: 'Report account issues',
          body:
              'If your profile information is wrong or someone is misusing your identity, contact support with your registered email and phone number so the issue can be reviewed.',
        ),
        MenuBlogSection(
          heading: 'Report technical bugs',
          body:
              'If something is not working, note the screen name, action you performed, and any error message. Clear details help the development team fix issues faster.',
        ),
      ],
    );
  }

  factory MenuBlog.helpSupport() {
    return const MenuBlog(
      title: 'Help & Support',
      subtitle:
          'Quick help for posting properties, browsing listings, messaging owners, and managing your profile.',
      icon: LucideIcons.helpCircle,
      sections: [
        MenuBlogSection(
          heading: 'Posting a property',
          body:
              'Go to the add property tab, complete all steps, upload clear photos, calculate the AI predicted price, and submit the listing. Complete details improve buyer trust.',
        ),
        MenuBlogSection(
          heading: 'Finding properties',
          body:
              'Use filters such as province and city to narrow the feed. Open a property to view images, area, purpose, price, owner details, and contact options.',
        ),
        MenuBlogSection(
          heading: 'Managing your profile',
          body:
              'Keep your name, phone number, profile photo, and location updated. Your posted properties appear on your profile so you can review your own listings easily.',
        ),
      ],
    );
  }

  factory MenuBlog.termsPolicies() {
    return const MenuBlog(
      title: 'Terms & Policies',
      subtitle:
          'The basic rules for using Urban Estate safely and responsibly.',
      icon: LucideIcons.fileText,
      sections: [
        MenuBlogSection(
          heading: 'Accurate information',
          body:
              'Users should provide correct profile and property information. Fake prices, false locations, copied photos, or misleading descriptions can reduce trust and may be removed.',
        ),
        MenuBlogSection(
          heading: 'Responsible communication',
          body:
              'Messaging should be used only for property-related conversation. Spam, harassment, harmful links, or offensive content are not allowed.',
        ),
        MenuBlogSection(
          heading: 'AI price prediction',
          body:
              'The predicted price is an estimate generated by the model. It helps users compare values, but it is not a legal, financial, or guaranteed market valuation.',
        ),
        MenuBlogSection(
          heading: 'Content moderation',
          body:
              'Urban Estate may remove posts, messages, or accounts that violate policies, harm users, or damage the quality of the property marketplace.',
        ),
      ],
    );
  }
}
