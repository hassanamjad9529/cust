import 'package:event_hub/src/configs/color/color.dart';
import 'package:event_hub/src/features/attendees/view_model/attendees_view_model.dart';
import 'package:event_hub/src/model/event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class UserAttendingEvent extends StatefulWidget {
  final EventModel eventModel;

  const UserAttendingEvent({super.key, required this.eventModel});

  @override
  State<UserAttendingEvent> createState() => _UserAttendingEventState();
}

class _UserAttendingEventState extends State<UserAttendingEvent> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<AttendeesViewModel>(
        context,
        listen: false,
      ).fetchAttendees(widget.eventModel.id);
    });
  }

  void _showAttendeeDetails(BuildContext context, AttendeeWithUser item) {
    final attendee = item.attendee;
    final isFree = !(widget.eventModel.isPaid);

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text(item.user.name),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Email: ${item.user.email}'),
                SizedBox(height: 8),

                if (!isFree) ...[
                  SizedBox(height: 8),
                  Text('Has Paid: ${attendee.hasPaid ? 'Yes' : 'No'}'),
                  SizedBox(height: 8),
                ],

                Text('Is Invited: ${attendee.isInvited ? 'Yes' : 'No'}'),
                SizedBox(height: 8),
                Text(
                  'Confirmed Seat: ${attendee.confirmedSeat ? 'Yes' : 'No'}',
                ),
                if (!attendee.confirmedSeat) ...[
                  SizedBox(height: 8),
                  Text(
                    'In Waiting List: Yes',
                    style: TextStyle(color: Colors.orange),
                  ),
                ],
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isFree = !(widget.eventModel.isPaid);

    return Scaffold(
      appBar: AppBar(title: Text('People who are going...')),
      body: Consumer<AttendeesViewModel>(
        builder: (context, vm, _) {
          if (vm.isLoading) return Center(child: CircularProgressIndicator());
          if (vm.error != null) {
            return Center(child: Text('Error: ${vm.error}'));
          }
          if (vm.attendees.isEmpty) return Center(child: Text('No User Found'));

          return ListView.builder(
            itemCount: vm.attendees.length,
            itemBuilder: (context, index) {
              final item = vm.attendees[index];
              final attendee = item.attendee;

              return GestureDetector(
                onTap: () => _showAttendeeDetails(context, item),
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(12.sp),
                  ),
                  child: ListTile(
                    title: Text(item.user.name),
                    subtitle: Text(item.user.email),
                    leading: Icon(
                      attendee.hasPaid
                          ? Icons.verified
                          : attendee.isInvited
                          ? Icons.mail_outline
                          : Icons.dangerous,
                      color: attendee.isInvited ? Colors.blue : Colors.green,
                    ),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) async {
                        switch (value) {
                          case 'invite':
                          case 'invite_again':
                            await vm.sendInvite(
                              context,
                              vm,
                              item,
                              widget.eventModel.title,
                              widget.eventModel.id,
                            );
                            break;
                          case 'cancel':
                            await vm.cancelReservation(
                              eventId: widget.eventModel.id,
                              userId: item.user.uid,
                            );
                            break;
                          case 'refund':
                            await vm.refundPayment(
                              eventId: widget.eventModel.id,
                              userId: item.user.uid,
                            );
                            break;
                          case 'mark_paid':
                            await vm.markAsPaidAndConfirmSeat(
                              eventId: widget.eventModel.id,
                              userId: item.user.uid,
                            );
                            break;
                          case 'unconfirm':
                            await vm.unconfirmSeat(
                              eventId: widget.eventModel.id,
                              userId: item.user.uid,
                            );
                            break;
                        }
                      },

                      itemBuilder: (context) {
                        List<PopupMenuEntry<String>> items = [];

                        // Invite or Invite Again
                        if (attendee.isInvited) {
                          items.add(
                            const PopupMenuItem(
                              value: 'invite_again',
                              child: Text('Invite Again'),
                            ),
                          );
                        } else if (!attendee.confirmedSeat) {
                          items.add(
                            const PopupMenuItem(
                              value: 'invite',
                              child: Text('Invite'),
                            ),
                          );
                        }

                        // Confirm or Mark as Paid
                        if (!attendee.confirmedSeat) {
                          items.add(
                            PopupMenuItem(
                              value: 'mark_paid',
                              child: Text(
                                isFree
                                    ? 'Confirm Seat'
                                    : 'Mark as Paid and Confirm Seat',
                              ),
                            ),
                          );
                        } else {
                          items.add(
                            const PopupMenuItem(
                              value: 'unconfirm',
                              child: Text('Unconfirm Seat'),
                            ),
                          );
                        }

                        // Remove / Cancel
                        items.add(
                          PopupMenuItem(
                            value: 'cancel',
                            child: Text(
                              attendee.confirmedSeat ? 'Remove' : 'Remove',
                            ),
                          ),
                        );

                        // Refund (only if paid event and has paid)
                        if (attendee.hasPaid && widget.eventModel.isPaid) {
                          items.add(
                            const PopupMenuItem(
                              value: 'refund',
                              child: Text('Refund'),
                            ),
                          );
                        }

                        return items;
                      },
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
