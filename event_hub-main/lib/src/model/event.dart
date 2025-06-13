import 'package:cloud_firestore/cloud_firestore.dart';

enum EventType { seminar, workshop, talk, competition, meetup, webinar, other }

enum EventCategory {
  technical,
  nonTechnical,
  cultural,
  academic,
  recreational,
  networking,
  community,
  sports, // Added for sports events
  food, // Added for food-related events
  art, // Added for art events
  career, // Added for career-focused events
  wellness, // Added for wellness events
}

// Extension to add `name` to the enum
extension EventCategoryName on EventCategory {
  String get name {
    return toString().split('.').last.toUpperCase();
  }
}

enum EventStatus { ongoing, completed, cancelled }

enum AttendeeStatus { notDecided, going, notGoing, isInWaitingList }

class Attendee {
  final String uid;
  final AttendeeStatus status;
  final bool hasPaid;
  final bool confirmedSeat;
  final Timestamp registeredAt;

  final bool isInvited;

  Attendee({
    required this.uid,
    required this.status,
    required this.hasPaid,
    required this.confirmedSeat,
    required this.registeredAt,

    required this.isInvited,
  });

  factory Attendee.fromMap(Map<String, dynamic> data) {
    return Attendee(
      uid: data['uid'],
      status: AttendeeStatus.values.firstWhere((e) => e.name == data['status']),
      hasPaid: data['hasPaid'] ?? false,
      confirmedSeat: data['confirmedSeat'] ?? false,
      registeredAt: data['registeredAt'] ?? Timestamp.now(),

      isInvited: data['isInvited'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'status': status.name,
      'hasPaid': hasPaid,
      'confirmedSeat': confirmedSeat,
      'registeredAt': registeredAt,

      'isInvited': isInvited,
    };
  }
}

class EventModel {
  final String id;
  final String title;
  final String description;
  final EventType type;
  final EventCategory category;

  final String venue;
  final String startDate;
  final String endDate;
  final String startTime;
  final String endTime;
  final bool isUnlimitedCapacity;
  final int? capacity;
  final bool isPaid;
  final double price;
  EventStatus status;
  final String createdBy;
  final Timestamp createdAt;
  final List<Attendee> attendees;
  final String? imageUrl;
  final Timestamp? registrationDeadline;

  final bool isFeatured;

  EventModel({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.category,

    required this.venue,
    required this.startDate,
    required this.endDate,
    required this.startTime,
    required this.endTime,
    required this.isUnlimitedCapacity,
    required this.capacity,
    required this.isPaid,
    required this.price,
    required this.status,
    required this.createdBy,
    required this.createdAt,
    required this.attendees,
    this.imageUrl,
    this.registrationDeadline,
    required this.isFeatured,
  });

  factory EventModel.fromMap(Map<String, dynamic> data, String docId) {
    return EventModel(
      id: docId,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      type: EventType.values.firstWhere((e) => e.name == data['type']),
      category: EventCategory.values.firstWhere(
        (e) => e.name == data['category'],
      ),

      venue: data['venue'] ?? '',
      startDate: data['startDate'] ?? '',
      endDate: data['endDate'] ?? '',
      startTime: data['startTime'] ?? '',
      endTime: data['endTime'] ?? '',
      isUnlimitedCapacity: data['isUnlimitedCapacity'] ?? false,
      capacity: data['capacity'],
      isPaid: data['isPaid'] ?? false,
      price: (data['price'] ?? 0).toDouble(),
      status: EventStatus.values.firstWhere((e) => e.name == data['status']),
      createdBy: data['createdBy'] ?? '',
      createdAt: data['createdAt'] ?? Timestamp.now(),
      attendees:
          (data['attendees'] as List<dynamic>?)
              ?.map((a) => Attendee.fromMap(a as Map<String, dynamic>))
              .toList() ??
          [],
      imageUrl: data['imageUrl'],
      registrationDeadline: data['registrationDeadline'],
      isFeatured: data['isFeatured'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type.name,
      'category': category.name,
      'venue': venue,
      'startDate': startDate,
      'endDate': endDate,
      'startTime': startTime,
      'endTime': endTime,
      'isUnlimitedCapacity': isUnlimitedCapacity,
      'capacity': capacity,
      'isPaid': isPaid,
      'price': price,
      'status': status.name,
      'createdBy': createdBy,
      'createdAt': createdAt,
      'attendees': attendees.map((a) => a.toMap()).toList(),
      'imageUrl': imageUrl,
      'registrationDeadline': registrationDeadline,
      'isFeatured': isFeatured,
    };
  }

  EventModel copyWith({
    String? id,
    String? title,
    String? description,
    EventType? type,
    EventCategory? category,

    String? venue,
    String? startDate,
    String? endDate,
    String? startTime,
    String? endTime,
    bool? isUnlimitedCapacity,
    int? capacity,
    bool? isPaid,
    double? price,
    EventStatus? status,
    String? createdBy,
    Timestamp? createdAt,
    List<Attendee>? attendees,
    String? imageUrl,
    Timestamp? registrationDeadline,
    String? externalLink,
    bool? isFeatured,
    // List<String>? tags,
  }) {
    return EventModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      category: category ?? this.category,

      venue: venue ?? this.venue,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      isUnlimitedCapacity: isUnlimitedCapacity ?? this.isUnlimitedCapacity,
      capacity: capacity ?? this.capacity,
      isPaid: isPaid ?? this.isPaid,
      price: price ?? this.price,
      status: status ?? this.status,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      attendees: attendees ?? this.attendees,
      imageUrl: imageUrl ?? this.imageUrl,
      registrationDeadline: registrationDeadline ?? this.registrationDeadline,

      isFeatured: isFeatured ?? this.isFeatured,
      // tags: tags ?? this.tags,
    );
  }
}
