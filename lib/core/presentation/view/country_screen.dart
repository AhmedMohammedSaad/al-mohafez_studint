import 'package:almohafez/core/models/country_model.dart';
import 'package:almohafez/core/presentation/view/widgets/app_custom_image_view.dart';
import 'package:almohafez/core/presentation/view/widgets/app_default_text_form_field.dart';
import 'package:almohafez/core/theme/app_text_style.dart';
import 'package:almohafez/core/utils/app_strings.dart';
import 'package:almohafez/generated/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nb_utils/nb_utils.dart';

class CountryCodeScreen extends StatefulWidget {
  const CountryCodeScreen({super.key});

  @override
  State<CountryCodeScreen> createState() => _CountryCodeScreenState();
}

class _CountryCodeScreenState extends State<CountryCodeScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<CountryModel> countries = [];
  List<CountryModel> filteredCountries = [];

  @override
  void initState() {
    super.initState();
    countries = Countries.all;
    filteredCountries = countries;
  }

  void filterCountries(String query) {
    setState(() {
      filteredCountries = countries
          .where(
            (country) =>
                country.name.toLowerCase().contains(query.toLowerCase()) ||
                country.dialCode.contains(query),
          )
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          AppStrings.countryCode,
          style: AppTextStyle.medium16.copyWith(color: Colors.black),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.w),
            child: AppDefaultTextFormField(
              controller: _searchController,
              type: TextInputType.text,
              hint: 'Search code or country...',
              prefixIcon: PrefixIconData.image(AssetData.svgSearch),
              onChange: (value) => filterCountries(value),
              validate: (value) => null,
              required: false,
              textStyle: AppTextStyle.regular14,
              borderRadius: 100.r,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredCountries.length,
              itemBuilder: (context, index) {
                final country = filteredCountries[index];
                return InkWell(
                  onTap: () {
                    Navigator.pop(context, country);
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 12.h,
                    ),
                    child: Row(
                      children: [
                        ClipOval(
                          child: AppCustomImageView(
                            imagePath:
                                'https://flagcdn.com/w80/${country.code.toLowerCase()}.png',
                            height: 32.h,
                            width: 32.w,
                            fit: BoxFit.fill,
                            radius: BorderRadius.circular(16.r),
                          ),
                        ),
                        16.width,
                        Expanded(
                          child: Text(
                            country.name,
                            style: AppTextStyle.regular16.copyWith(
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Text(
                          country.dialCode,
                          style: AppTextStyle.regular16.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
