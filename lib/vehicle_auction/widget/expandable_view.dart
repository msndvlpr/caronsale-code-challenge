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
        iconColor: Colors.blue[800],
          initiallyExpanded: false,
          title: _buildCollapsedView(),
          children: [_buildExpandedView()],
            ),
      );
  }

  Widget _buildCollapsedView() {
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
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue[900])),
                ),
                Expanded(
                  child: Text(model.model,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue[900])),
                ),
                Text("${model.price} €",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue[900])),
              ],
            ),
            Divider(),
            _buildSectionTitle("Auction Details"),
            _buildDetailRow("Make", model.make),
            _buildDetailRow("Model", model.model),
            _buildDetailRow("Price", "${model.price} €"),
            _buildDetailRow("Feedback", model.feedback),
            _buildDetailRow("Customer Feedback", model.positiveCustomerFeedback ? "Positive" : "Negative"),
            _buildDetailRow("Origin", model.origin),
          ],
        ),
      ),
    );
  }

  /// Expanded View: Shows all details
  Widget _buildExpandedView() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(),
          _buildSectionTitle("More Information"),
          _buildDetailRow("Created At", model.createdAt),
          _buildDetailRow("Updated At", model.updatedAt),
          _buildDetailRow("Requested At", model.requestedAt),
          _buildDetailRow("Inspector Requested At", model.inspectorRequestedAt),
          _buildDetailRow("Valuated At", model.valuatedAt),
          const Divider(),
          _buildDetailRow("Estimation ID", model.estimationRequestId),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  /// Builds a single row for details
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          Flexible(child: Text(value, overflow: TextOverflow.ellipsis, maxLines: 1, softWrap: true)),
        ],
      ),
    );
  }

  /// Builds a simple text label and value
  Widget _buildLabelValue(String label, String value) {
    return Text(
      "$label: $value",
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.blueAccent),
    );
  }

  /// Section titles for organization
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Text(
        title,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.blueGrey),
      ),
    );
  }
}
