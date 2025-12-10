import 'package:flutter/material.dart';
import 'package:prime_basket_place_mobile/custom/custom_app_bar.dart';
import 'package:prime_basket_place_mobile/custom/custom_drawer.dart';

class Homepage extends StatelessWidget {
	const Homepage({super.key});

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: CustomShopAppBar(),
			drawer: LeftDrawer(),
			body: Padding(
				padding: const EdgeInsets.all(8.0),

			),

		);
	}
}
