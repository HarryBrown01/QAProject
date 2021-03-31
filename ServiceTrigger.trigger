trigger ServiceTrigger on Service_Invoice__c (after insert, after update) {
    SWITCH ON Trigger.OperationType {
		WHEN AFTER_UPDATE {
            ServiceHandler.UpdateService(Trigger.new, Trigger.oldMap);
        }
        WHEN AFTER_INSERT {
            ServiceHandler.NewService(Trigger.new);
        }
    }
}