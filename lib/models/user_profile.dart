import 'package:ethio_chef/models/subscriptionplans.dart';
import 'package:ethio_chef/models/user.dart';

class UserProfile {
  final int? id;
  final int? userId;
   User? user;
  final int? subscriptionId;
  final SubscriptionPlans? subscription;
  final String? status;
  final DateTime? dueDate;
  final DateTime? lastPaidDate;
  String? message;

  UserProfile( {
    this.id,
    this.userId,
    this.user,
    this.subscriptionId,
    this.subscription,
    this.status,
    this.dueDate,
    this.lastPaidDate, this. message = 'User is subscribed',
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'],
      userId: json['user_id'],
      user: User.fromJson(json['user']),
      subscriptionId: json['subscription_id'],
      subscription: SubscriptionPlans.fromJson(json['subscription']),
      status: json['status'],
      dueDate: DateTime.parse(json['due_date']),
      lastPaidDate: DateTime.parse(json['last_paid_date']),
    );
  }
}
