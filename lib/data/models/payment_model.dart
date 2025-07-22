class PaymentModel {
  final String id;
  final String rideId;
  final String passengerId;
  final double amount;
  final DateTime paymentTime;
  final String status; // pending, completed, failed

  PaymentModel({
    required this.id,
    required this.rideId,
    required this.passengerId,
    required this.amount,
    required this.paymentTime,
    required this.status,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json['id'],
      rideId: json['rideId'],
      passengerId: json['passengerId'],
      amount: json['amount'].toDouble(),
      paymentTime: DateTime.parse(json['paymentTime']),
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'rideId': rideId,
      'passengerId': passengerId,
      'amount': amount,
      'paymentTime': paymentTime.toIso8601String(),
      'status': status,
    };
  }
}