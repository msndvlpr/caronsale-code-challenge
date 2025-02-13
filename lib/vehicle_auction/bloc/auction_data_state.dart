part of 'auction_data_bloc.dart';

sealed class AuctionDataState extends Equatable {

  @override
  List<Object?> get props => [];
}

class AuctionDataStateInitial extends AuctionDataState {}

class AuctionDataStateLoading extends AuctionDataState {}

class AuctionDataStateSuccess extends AuctionDataState {
  final AuctionData auctionData;

  AuctionDataStateSuccess({
    required this.auctionData
  });

  @override
  List<Object?> get props => [auctionData];
}

class AuctionDataStateMultipleChoice extends AuctionDataState {
  final VehicleOptionItems vehicleOptionItems;

  AuctionDataStateMultipleChoice({
    required this.vehicleOptionItems
  });

  @override
  List<Object?> get props => [vehicleOptionItems];
}

class AuctionDataStateFailure extends AuctionDataState {
  final ErrorResponse errorResponse;

  AuctionDataStateFailure({required this.errorResponse});

  @override
  List<Object?> get props => [errorResponse];
}

class AuctionDataStateException extends AuctionDataState {
  final String errorMessage;

  AuctionDataStateException({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}

