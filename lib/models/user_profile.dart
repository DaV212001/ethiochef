import 'package:ethio_chef/models/subscriptionplans.dart';
import 'package:ethio_chef/models/user.dart';

class UserProfile {
  final int? id;
  final int? userId;
  User? user;
  final int? subscriptionId;
  final SubscriptionPlans? subscription;
  final String? status;
  final int? dueDate;
  final DateTime? lastPaidDate;
  String? message;
  bool? isFromSMS;

  UserProfile({
    this.id,
    this.userId,
    this.user,
    this.subscriptionId,
    this.subscription,
    this.status,
    this.dueDate,
    this.lastPaidDate,
    this. message = 'User is subscribed',
    this.isFromSMS
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    print("UserProfile.fromJson $json");
    return UserProfile(
      id: json['id'],
      userId: json['user_id'],
      user: User.fromJson(json['user']),
      subscriptionId: json['subscription_id'],
      subscription: SubscriptionPlans.fromJson(json),
      status: json['status'],
      dueDate: json['due_date']??0,
      lastPaidDate: DateTime.parse(json['last_paid_date']),
      isFromSMS: json['isFromSMS']
    );
  }
}