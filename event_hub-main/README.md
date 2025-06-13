




enum AttendeeStatus {notDecided, going, notGoing, interested }
defualt notDecided
if free  going
if paid interested => notify admin (when paid change status to going(notify user also))
can notGoing

on edit event notify attendeees

admin can canel the event but where



if free
 if seats are unlimieted 
   if seats are available 
     if startDate is not before current date 
       if startTime is not beofre current time
         if enum EventStatus  is  ongoing 
           if registrationDeadline is not null and is not before currrent date 

  final String uid;
  final AttendeeStatus status; going
  final bool hasPaid;        if event is not free then false other wise null 
  final bool confirmedSeat;    true
  final Timestamp registeredAt; 