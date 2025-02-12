import 'dart:convert';

// Response for the response code 400
class ErrorResponse{
  final String msgKey;
  final MessageParams params;
  final String message;

  ErrorResponse({
    required this.msgKey,
    required this.params,
    required this.message,
  });

  factory ErrorResponse.fromJson(Map<String, dynamic> json) => ErrorResponse(
    msgKey: json["msgKey"],
    params: MessageParams.fromJson(json["params"]),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "msgKey": msgKey,
    "params": params.toJson(),
    "message": message,
  };

  static ErrorResponse errorResponseFromJson(String str) =>
      ErrorResponse.fromJson(json.decode(str));

  static String errorResponseToJson(ErrorResponse data) => json.encode(data.toJson());
}

class MessageParams {
  final int delaySeconds; // Changed to int

  MessageParams({
    required this.delaySeconds,
  });

  factory MessageParams.fromJson(Map<String, dynamic> json) => MessageParams(
    delaySeconds: int.parse(json["delaySeconds"]), // Parse to int
  );

  Map<String, dynamic> toJson() => {
    "delaySeconds": delaySeconds.toString(), // Convert back to String if needed
  };
}