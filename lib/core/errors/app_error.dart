import 'package:cloud_firestore/cloud_firestore.dart';

import '../../data/repo/sale_repo.dart';

abstract class AppError {
  const AppError(this.message);

  final String message;
}

class FirestoreError extends AppError {
  const FirestoreError(super.message);
}

class InsufficientStockError extends AppError {
  const InsufficientStockError(this.available)
    : super('Only $available in stock.');

  final int available;
}

class UnknownAppError extends AppError {
  const UnknownAppError([super.message = 'Something went wrong.']);
}

AppError mapFirestoreError(Object error) {
  if (error is InsufficientStockException) {
    return InsufficientStockError(error.available);
  }
  if (error is FirebaseException) {
    return FirestoreError(error.message ?? error.code);
  }
  return UnknownAppError(error.toString());
}
