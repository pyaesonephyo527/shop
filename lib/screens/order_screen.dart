import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/orders.dart' show Orders;
import '../widgets/order_item.dart';
import '../widgets/app_drawer.dart';

class OrderScreen extends StatefulWidget {
  static const routeName = '/orders';

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  late Future _orderFuture;

  Future _obtainedFuture() {
    return Provider.of<Orders>(context,listen: false).fetchAndSetOrders();
  }

  @override
  void initState() {
    //setState(() {
      _orderFuture = _obtainedFuture();
    //});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('Orders building');
    // final orderData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Order'),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _orderFuture,
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (dataSnapshot.error != null) {
              return Center(
                child: Text('An Error Occured'),
              );
            } else {
              return Consumer(builder: (ctx, Orders orderData, child) {
                return ListView.builder(
                  itemCount: orderData.orders.length,
                  itemBuilder: (ctx, i) => OrderItem(
                    order: orderData.orders[i],
                  ),
                );
              });
            }
          }
        },
      ),
    );
  }
}
