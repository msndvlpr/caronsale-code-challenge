part of 'auction_data_bloc.dart';

sealed class AuctionDataEvent extends Equatable{}

class AuctionDataFetched extends AuctionDataEvent{
  final String vin;
  AuctionDataFetched({required this.vin});

  @override
  List<Object> get props => [vin];
}

class VehicleDataFetched extends AuctionDataEvent{
  final String eid;
  VehicleDataFetched({required this.eid});

  @override
  List<Object> get props => [eid];
}