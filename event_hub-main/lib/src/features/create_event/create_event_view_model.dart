import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_hub/src/features/event/view_model/event_view_model.dart';
import 'package:event_hub/src/model/event.dart';
import 'package:event_hub/src/features/auth/view_model/auth_view_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class CreateEventViewModel extends ChangeNotifier {
  // Controllers
  final _titleController = TextEditingController();
  final _descController = TextEditingController();

  final _venueController = TextEditingController();
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();
  final _startTimeController = TextEditingController();
  final _endTimeController = TextEditingController();
  final _capacityController = TextEditingController();
  final _priceController = TextEditingController();
  final _registrationDeadlineController = TextEditingController();

  // State variables
  EventType _selectedType = EventType.seminar;
  EventCategory _selectedCategory = EventCategory.technical;
  bool _isPaid = false;
  bool _isUnlimited = false;
  bool _isFeatured = false;
  File? _imageFile;
  String? _existingImageUrl;
  bool _isUploadingImage = false;
  bool _isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final EventModel? _event;

  // Getters
  TextEditingController get titleController => _titleController;
  TextEditingController get descController => _descController;

  TextEditingController get venueController => _venueController;
  TextEditingController get startDateController => _startDateController;
  TextEditingController get endDateController => _endDateController;
  TextEditingController get startTimeController => _startTimeController;
  TextEditingController get endTimeController => _endTimeController;
  TextEditingController get capacityController => _capacityController;
  TextEditingController get priceController => _priceController;
  TextEditingController get registrationDeadlineController =>
      _registrationDeadlineController;
  EventType get selectedType => _selectedType;
  EventCategory get selectedCategory => _selectedCategory;
  bool get isPaid => _isPaid;
  bool get isUnlimited => _isUnlimited;
  bool get isFeatured => _isFeatured;
  File? get imageFile => _imageFile;
  String? get existingImageUrl => _existingImageUrl;
  bool get isUploadingImage => _isUploadingImage;
  bool get isLoading => _isLoading;
  GlobalKey<FormState> get formKey => _formKey;
  bool get isEditing => _event != null;

  CreateEventViewModel({EventModel? event}) : _event = event {
    if (event != null) {
      // Initialize for editing
      _titleController.text = event.title;
      _descController.text = event.description;

      _venueController.text = event.venue;
      _startDateController.text = event.startDate;
      _endDateController.text = event.endDate;
      _startTimeController.text = event.startTime;
      _endTimeController.text = event.endTime;
      _capacityController.text = event.capacity?.toString() ?? '';
      _priceController.text = event.price.toString();
      _registrationDeadlineController.text = event.registrationDeadline != null
          ? DateTime.fromMillisecondsSinceEpoch(
              event.registrationDeadline!.millisecondsSinceEpoch)
              .toString()
              .split(' ')
              .first
          : '';
      _selectedType = event.type;
      _selectedCategory = event.category;
      _isPaid = event.isPaid;
      _isUnlimited = event.isUnlimitedCapacity;
      _isFeatured = event.isFeatured;
      _existingImageUrl = event.imageUrl;
    }
  }

  // Setters for dropdowns and switches
  void setSelectedType(EventType type) {
    _selectedType = type;
    notifyListeners();
  }

  void setSelectedCategory(EventCategory category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setIsPaid(bool value) {
    _isPaid = value;
    notifyListeners();
  }

  void setIsUnlimited(bool value) {
    _isUnlimited = value;
    notifyListeners();
  }

  void setIsFeatured(bool value) {
    _isFeatured = value;
    notifyListeners();
  }

  // Image handling
  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _imageFile = File(pickedFile.path);
      notifyListeners();
    } else {
      // Log if no image was picked
      debugPrint('No image selected');
    }
  }

  void clearImage() {
    _imageFile = null;
    notifyListeners();
  }

  Future<String?> _uploadImage() async {
    if (_imageFile == null) {
      debugPrint('No new image to upload, using existing: $_existingImageUrl');
      return _existingImageUrl;
    }
    _isUploadingImage = true;
    notifyListeners();
    try {
      final ref = FirebaseStorage.instance
          .ref()
          .child('event_images')
          .child('${DateTime.now().millisecondsSinceEpoch}.jpg');
      debugPrint('Uploading image to: ${ref.fullPath}');
      final uploadTask = await ref.putFile(_imageFile!);
      final url = await uploadTask.ref.getDownloadURL();
      debugPrint('Image uploaded successfully: $url');
      return url;
    } catch (e) {
      debugPrint('Image upload failed: $e');
      return null; // Error handled in submitForm
    } finally {
      _isUploadingImage = false;
      notifyListeners();
    }
  }

  // Form submission
  Future<String?> submitForm(
    BuildContext context,
    AuthViewModel authVM,
    EventViewModel eventVM,
  ) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      _isLoading = true;
      notifyListeners();

      final imageUrl = await _uploadImage();
      if (imageUrl == null && _imageFile != null) {
        _isLoading = false;
        notifyListeners();
        return 'Failed to upload image';
      }

      final event = EventModel(
        id: _event?.id ?? '', // Use existing ID for update, empty for create
        title: _titleController.text,
        description: _descController.text,
        type: _selectedType,
        category: _selectedCategory,

        venue: _venueController.text,
        startDate: _startDateController.text,
        endDate: _endDateController.text,
        startTime: _startTimeController.text,
        endTime: _endTimeController.text,
        isUnlimitedCapacity: _isUnlimited,
        capacity: _isUnlimited ? null : int.tryParse(_capacityController.text),
        isPaid: _isPaid,
        price: _isPaid ? double.tryParse(_priceController.text) ?? 0.0 : 0.0,
        status: _event?.status ?? EventStatus.ongoing, // Preserve or set default
        createdBy: _event?.createdBy ?? authVM.currentUser?.uid ?? '', // Preserve or set
        createdAt: _event?.createdAt ?? Timestamp.now(), // Preserve or set
        attendees: _event?.attendees ?? [], // Preserve or empty
        imageUrl: imageUrl,
        registrationDeadline: _registrationDeadlineController.text.isNotEmpty
            ? Timestamp.fromDate(
                DateTime.parse(_registrationDeadlineController.text))
            : null,
        isFeatured: _isFeatured,
      );

      String? error;
      if (_event == null) {
        debugPrint('Creating new event');
        error = await eventVM.createEvent(event);
      } else {
        debugPrint('Updating event: ${event.id}');
        error = await eventVM.updateEvent(event);
      }

      _isLoading = false;
      notifyListeners();

      if (error == null) {
        debugPrint('Event ${event.id.isEmpty ? "created" : "updated"} successfully');
        eventVM.fetchAllEvents();
      } else {
        debugPrint('Error: $error');
      }
      return error;
    }
    return 'Form validation failed';
  }

  // Clean up
  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();

    _venueController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    _startTimeController.dispose();
    _endTimeController.dispose();
    _capacityController.dispose();
    _priceController.dispose();
    _registrationDeadlineController.dispose();
    super.dispose();
  }
}