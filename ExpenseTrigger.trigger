trigger ExpenseTrigger on Expense_Invoice__c (after insert, after update) {
    SWITCH ON Trigger.OperationType {
		WHEN AFTER_UPDATE {
            ExpenseHandler.UpdateExpense(Trigger.new, Trigger.oldMap);
        }
        WHEN AFTER_INSERT {
            ExpenseHandler.NewExpense(Trigger.new);
        }
    }
}