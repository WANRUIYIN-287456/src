import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_finalassignment_287456/config.dart';
import 'package:flutter_application_finalassignment_287456/model/product.dart';
import 'package:flutter_application_finalassignment_287456/model/user.dart';
import 'package:intl/intl.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;
  final User user;
  const ProductDetailScreen(
      {super.key, required this.user, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final df = DateFormat('dd-MM-yyyy hh:mm a');
  int index = 0;
  late double screenHeight, screenWidth, cardwitdh;
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(),
      body: Column(children: [
        Flexible(
            flex: 4,
            // height: screenHeight / 2.5,
            // width: screenWidth,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
              child: Card(
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  children: List.generate(3, (index) {
                    return 
                    Container(
                  width: screenWidth,
                  child: CachedNetworkImage(
                    width: screenWidth,
                    fit: BoxFit.cover,
                    imageUrl:
                        "${Config.server}/LabAssign2/assets/images/${widget.product.productId}.${index++}.png",
                    placeholder: (context, url) =>
                        const LinearProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  )
                );

                  }),
                ),
                
              ),
            )),
        Container(
            padding: const EdgeInsets.all(8),
            child: Text(
              widget.product.productName.toString(),
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            )),
        Expanded(
          child: Container(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Table(
              columnWidths: const {
                0: FlexColumnWidth(4),
                1: FlexColumnWidth(6),
              },
              children: [
                TableRow(children: [
                  const TableCell(
                    child: Text(
                      "Description",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  TableCell(
                    child: Text(
                      widget.product.productDesc.toString(),
                    ),
                  )
                ]),
                TableRow(children: [
                  const TableCell(
                    child: Text(
                      "Product Type",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  TableCell(
                    child: Text(
                      widget.product.productType.toString(),
                    ),
                  )
                ]),
                TableRow(children: [
                  const TableCell(
                    child: Text(
                      "Quantity Available",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  TableCell(
                    child: Text(
                      widget.product.productQty.toString(),
                    ),
                  )
                ]),
                TableRow(children: [
                  const TableCell(
                    child: Text(
                      "Product Value",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  TableCell(
                    child: Text(
                      "RM ${double.parse(widget.product.productPrice.toString()).toStringAsFixed(2)}",
                    ),
                  )
                ]),
                TableRow(children: [
                  const TableCell(
                    child: Text(
                      "Location",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  TableCell(
                    child: Text(
                      "${widget.product.productLocality}, ${widget.product.productState}",
                    ),
                  )
                ]),
                TableRow(children: [
                  const TableCell(
                    child: Text(
                      "Date",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  TableCell(
                    child: Text(
                      df.format(DateTime.parse(
                          widget.product.productDate.toString())),
                    ),
                  )
                ]),
              ],
            ),
          ),
        )
      ]),
    );
  }
}
