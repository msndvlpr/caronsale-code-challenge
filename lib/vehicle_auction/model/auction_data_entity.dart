
import 'package:intl/intl.dart';
import 'package:network_api/network_api_service.dart';

class AuctionDataEntity {
  final int id;
  final String feedback;
  final String valuatedAt;
  final String requestedAt;
  final String createdAt;
  final String updatedAt;
  final String make;
  final String model;
  final int price;
  final String positiveCustomerFeedback;
  final String inspectorRequestedAt;
  final String origin;
  final String estimationRequestId;

  AuctionDataEntity({
    required this.id,
    required this.feedback,
    required this.valuatedAt,
    required this.requestedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.make,
    required this.model,
    required this.price,
    required this.positiveCustomerFeedback,
    required this.inspectorRequestedAt,
    required this.origin,
    required this.estimationRequestId,
  });

  // Method to convert ISO date time to human readable date time based on the given locale
  static String _formatDateTime(DateTime dateTime, String locale) {
    return DateFormat.yMMMMd(locale).add_jm().format(dateTime);
  }

  /// Convert from the existing `AuctionData` model
  factory AuctionDataEntity.fromAuctionData(AuctionData data, {String locale = 'de_DE'}) {
    return AuctionDataEntity(
        id: data.id,
        feedback: data.feedback,
        valuatedAt: _formatDateTime(data.valuatedAt, locale),
        requestedAt: _formatDateTime(data.requestedAt, locale),
        createdAt: _formatDateTime(data.createdAt, locale),
        updatedAt: _formatDateTime(data.updatedAt, locale),
        make: data.make,
        model: data.model,
        price: data.price,
        positiveCustomerFeedback: data.positiveCustomerFeedback ? 'Positive' : 'Negative',
        inspectorRequestedAt: _formatDateTime(data.inspectorRequestedAt, locale),
        origin: data.origin,
        estimationRequestId: data.estimationRequestId
    );
  }
}