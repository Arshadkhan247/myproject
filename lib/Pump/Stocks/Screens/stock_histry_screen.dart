import 'package:flutter/material.dart';
import 'package:myproject/Pump/Stocks/Models/stock_histry_Item.dart';
import 'package:myproject/Pump/common/screens/sidebar.dart';
import 'package:myproject/Pump/common/widgets/sidebar_menue_item.dart';

class StockHistoryScreen extends StatelessWidget {
  final List<StockHistoryItem> stockHistory;
  final String historyType;

  const StockHistoryScreen({
    super.key,
    required this.stockHistory,
    required this.historyType,
  });

  @override
  Widget build(BuildContext context) {
    List<StockHistoryItem> filteredHistory = List.from(stockHistory)
      ..sort((a, b) => (b.timestamp ?? DateTime.now())
          .compareTo(a.timestamp ?? DateTime.now()));

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white, // Change the color of the back icon here
        ),
        title: Text(
          '$historyType History',
          style: const TextStyle(
              fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF6789CA),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 600) {
            // Mobile layout
            return buildMobileLayout(filteredHistory);
          } else {
            // Web layout
            return buildWebLayout(context, filteredHistory);
          }
        },
      ),
    );
  }

  Widget buildWebLayout(
      BuildContext context, List<StockHistoryItem> filteredHistory) {
    return Row(
      children: [
        //sidebar
        SideBar(
          menuItems: getMenuItems(context),
        ),
        // Main Content
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredHistory.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          title: Text(
                              '${filteredHistory[index].type}: ${filteredHistory[index].amount}'),
                          subtitle: Text(
                              'Updated on ${filteredHistory[index].timestamp.toString()}'),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildMobileLayout(List<StockHistoryItem> filteredHistory) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: filteredHistory.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    title: Text(
                        '${filteredHistory[index].type}: Stock ${filteredHistory[index].amount}'),
                    subtitle: Text(
                        'Updated on ${filteredHistory[index].timestamp.toString()}'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
