class Payment {
  final String id;
  final String rideId;
  final String passengerId;
  final double amount;
  final DateTime paymentTime;
  final String status; // 'pending', 'completed', 'failed', 'refunded'

  Payment({
    required this.id,
    required this.rideId,
    required this.passengerId,
    required this.amount,
    required this.paymentTime,
    required this.status,
  });
}