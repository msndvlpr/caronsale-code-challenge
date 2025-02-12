
import 'package:auction_repository/auction_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:network_api/network_api_service.dart';

part 'auction_data_event.dart';

part 'auction_data_state.dart';

class AuctionDataBloc extends Bloc<AuctionDataEvent, AuctionDataState> {

  final AuctionRepository auctionRepository;

  AuctionDataBloc(this.auctionRepository) : super(AuctionDataStateInitial()) {
    on<AuctionDataFetched>(_getAuctionDataByVin);
    on<VehicleDataFetched>(_getVehicleDataByEid);
  }

  void _getAuctionDataByVin(
      AuctionDataFetched event,
      Emitter<AuctionDataState> emit) async {

    emit(AuctionDataStateLoading());
    try {
      final data = await auctionRepository.fetchAuctionDataByVin(event.vin, 'userId');
      if(data is AuctionData){
        emit(AuctionDataStateSuccess(auctionData: data));

      } else if(data is VehicleOptionItems){
        emit(AuctionDataStateMultipleChoice(vehicleOptionItems: data));

      } else if(data is ErrorResponse){
        emit(AuctionDataStateFailure(errorResponse: data));
      } else {
        emit(AuctionDataStateException(errorMessage: "No data available, please try again in a moment."));
      }

    } catch (e) {
      emit(AuctionDataStateException(errorMessage: e.toString()));
    }
  }

  void _getVehicleDataByEid(
      VehicleDataFetched event,
      Emitter<AuctionDataState> emit) async {

    emit(AuctionDataStateLoading());
    try {
      final data = await auctionRepository.fetchVehicleDataByExternalId(event.eid, 'userId');
      if(data is AuctionData){
        emit(AuctionDataStateSuccess(auctionData: data));

      } else if(data is ErrorResponse){
        emit(AuctionDataStateFailure(errorResponse: data));
      } else {
        emit(AuctionDataStateException(errorMessage: "No data available, please try again in a moment."));
      }

    } catch (e) {
      emit(AuctionDataStateException(errorMessage: e.toString()));
    }
  }

}
