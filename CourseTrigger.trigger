trigger CourseTrigger on Schedule_Course__c (after insert, after update) {
    SWITCH ON Trigger.OperationType {
		WHEN AFTER_UPDATE {
            CourseHandler.UpdateCourse(Trigger.new, Trigger.oldMap);
		}
		WHEN AFTER_INSERT {
            CourseHandler.NewCourse(Trigger.new);
		}
	}
}