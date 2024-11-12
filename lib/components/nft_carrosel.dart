import 'package:flutter/material.dart';
import 'package:nft_app/components/nft_card.dart';

class NftCarrosel extends StatelessWidget {
  final List<String> nftImages;

  const NftCarrosel({super.key, required this.nftImages});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: nftImages.length,
      itemBuilder: (context, index) {
        return Column(
          children: [
            NftCard(imagePath: nftImages[index]),

          ],
        );
      },
    );
  }
}