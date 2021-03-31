public class CourseHandler {
    public static void NewCourse(List<Schedule_Course__c> triggerNew){
        List <Event> NewEvent = new List <Event> ();
        for (Schedule_Course__c SCourse : triggerNew) {
            Event evt = new Event(whatID = SCourse.ID,
                                  Ownerid = SCourse.Instructor__c, 
                                  Subject = 'Course Scheduled', 
                                  StartDateTime = SCourse.Start_Date__c, 
                                  EndDateTime = SCourse.End_Date__c, 
                                  Location = SCourse.Location__c, 
                                  Description = 'Course Scheduled to be taught on these days.');
			NewEvent.add(evt);
            sendNotifications('Course Scheduled', '', SCourse.Instructor__c, 'A new course has been scheduled with you as the instructor.', '0ML4L000000PB4AWAW', new set<String>{SCourse.Instructor__c});
		}
        insert NewEvent;
    }
    public static void UpdateCourse(List<Schedule_Course__c> triggerNew, Map<Id, Schedule_Course__c> oldMap){
        List <Id> delID_Cancel = new List <Id> ();
        List <Id> delID_Change = new List <Id> ();
        List <Event> NewEvent = new List <Event> ();
        List <Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
            
        for (Schedule_Course__c SCourse : triggerNew) {
            if (SCourse.Stage__c == 'Cancelled'){                    
                delID_Cancel.add(SCourse.ID);
                
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        
                List<String> sendTo = new List<String>();
                sendTo.add(SCourse.InstructorEmail__c);
                System.debug(sendTo);
                mail.setToAddresses(sendTo);                  
                mail.setReplyTo('HBrown@qa.com');
                mail.setSenderDisplayName('System Administrator');
                mail.setSubject('Cancelled Course');
                String body = 'Dear ' + SCourse.Instructor_Name__c + ', ' + SCourse.Courses__c + ' has been cancelled. You are now free to schedule other courses on these date.';
                mail.setHtmlBody(body);
                
                mails.add(mail);
            }
                
            Schedule_Course__c SchedCourse = oldMap.get(SCourse.ID);
            if (SCourse.Instructor__c != SchedCourse.Instructor__c) {
                delID_Change.add(SCourse.ID);

                Event evt = new Event(whatID = SCourse.ID, 
                                      Ownerid = SCourse.Instructor__c, 
                                      Subject = 'Course Scheduled', 
                                      StartDateTime = SCourse.Start_Date__c, 
                                      EndDateTime = SCourse.End_Date__c, 
                                      Location = SCourse.Location__c, 
                                      Description = 'Course Scheduled to be taught on these days.');
                    
                NewEvent.add(evt);
                sendNotifications('Course Scheduled', '', SCourse.Instructor__c, 'A new course has been scheduled with you as the instructor.', '0ML4L000000PB4AWAW', new set<String>{SCourse.Instructor__c});    
            }
        }
        
        List<Messaging.SendEmailResult> emailResultList = Messaging.sendEmail(mails);
        
        List<Event> DelEvnt = [SELECT Id, WhatId, Subject FROM Event WHERE Subject = 'Course Scheduled' AND WhatId = :delID_Cancel];
        try {
            delete DelEvnt;
        } catch (DmlException e) {
            System.debug(e);
        }
        List<Event> DelEvnts = [SELECT Id, WhatId, Subject FROM Event WHERE Subject = 'Course Scheduled' AND WhatId = :delID_Change];
        try {
            delete DelEvnts;
            insert NewEvent;
        } catch (DmlException e) {
            System.debug(e);
        }
    }
    public static void sendNotifications(String strBody, String strSenderId, String strTargetId, String strTitle, String strNotificationId, set<String> setUserIds) {
        Messaging.CustomNotification MSG = new Messaging.CustomNotification();
        MSG.setNotificationTypeId(strNotificationId);
        MSG.setTargetId(strTargetId);
        MSG.setTitle(strTitle);
        MSG.setBody(strBody);
        MSG.send(setUserIds);
    }
}