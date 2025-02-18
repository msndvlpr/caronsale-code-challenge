import 'package:caronsale_code_challenge/vehicle_auction/model/auction_data_entity.dart';
import 'package:flutter/material.dart';

class ExpandableView extends StatelessWidget {
  final AuctionDataEntity model;

  const ExpandableView({
    super.key,
    required this.model
  });

  @override
  Widget build(BuildContext context) {

    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        iconColor: Theme.of(context).colorScheme.primary,
          initiallyExpanded: false,
          title: _buildCollapsedView(context),
          children: [_buildExpandedView(context)],
            ),
      );
  }

  Widget _buildCollapsedView(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(model.make,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary)),
                ),
                Expanded(
                  child: Text(model.model,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary)),
                ),
                Text("${model.price} €",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary)),
              ],
            ),
            Divider(),
            _buildSectionTitle("Auction Details", context),
            _buildDetailRow("Make", model.make, context),
            _buildDetailRow("Model", model.model, context),
            _buildDetailRow("Price", "${model.price} €", context),
            _buildDetailRow("Feedback", model.feedback, context),
            _buildDetailRow("Customer Feedback", model.positiveCustomerFeedback, context),
            _buildDetailRow("Origin", model.origin, context),
          ],
        ),
      ),
    );
  }

  /// Expanded View: Shows all details
  Widget _buildExpandedView(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(),
          _buildSectionTitle("More Information", context),
          _buildDetailRowForExpanded("Created At", model.createdAt, context),
          _buildDetailRowForExpanded("Updated At", model.updatedAt, context),
          _buildDetailRowForExpanded("Requested At", model.requestedAt, context),
          _buildDetailRowForExpanded("Inspector Requested At", model.inspectorRequestedAt, context),
          _buildDetailRowForExpanded("Valuated At", model.valuatedAt, context),
          const Divider(),
          _buildDetailRowForExpanded("Estimation ID", model.estimationRequestId, context),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  // Builds a single row for details
  Widget _buildDetailRow(String label, String value, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary)),
          Flexible(child: Text(value, overflow: TextOverflow.ellipsis, maxLines: 1, softWrap: true)),
        ],
      ),
    );
  }
  Widget _buildDetailRowForExpanded(String label, String value, BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Theme.of(context).colorScheme.inversePrimary : Theme.of(context).colorScheme.primary)),
          Flexible(child: Text(value, overflow: TextOverflow.ellipsis, maxLines: 1, softWrap: true,
              style: TextStyle(color: Colors.black))),
        ],
      ),
    );
  }

  // Section titles for organization
  Widget _buildSectionTitle(String title, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Text(
        title,
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.inversePrimary),
      ),
    );
  }
}
