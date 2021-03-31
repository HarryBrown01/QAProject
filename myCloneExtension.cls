public class myCloneExtension {
    public String ExpenseId{get; set;}
    public String currentRecord{get; set;}
    
    public myCloneExtension(ApexPages.StandardSetController stdController) {
        this.currentRecord=ApexPages.currentPage().getParameters().get('id');
    }
    
    public PageReference CloneLines(){
        System.debug(ExpenseId);
        List<Expense_Invoice_Line__c> ToClone = [SELECT Amount__c, Call_Length__c, Company_Name__c, Day__c, From__c, Length_of_Stay__c, Length_of_Trip__c, Miles_Travelled__c, RecordTypeId, To__c, Toll_Location__c, Who_was_called__c, Expense_Invoice__r.Name FROM Expense_Invoice_Line__c WHERE Expense_Invoice__r.Id = :ExpenseId];
        List<Expense_Invoice_Line__c> Cloned = new List <Expense_Invoice_Line__c> ();
        
        for (Expense_Invoice_Line__c Expenses : ToClone) {
            Expense_Invoice_Line__c Expense = new Expense_Invoice_Line__c(Expense_Invoice__c = currentRecord,
                                                                         Amount__c = Expenses.Amount__c,
                                                                         Call_Length__c = Expenses.Call_Length__c,
                                                                         Day__c = Expenses.Day__c,
                                                                         From__c = Expenses.From__c,
                                                                         Length_of_Stay__c = Expenses.Length_of_Stay__c,
                                                                         Length_of_Trip__c = Expenses.Length_of_Trip__c,
                                                                         Miles_Travelled__c = Expenses.Miles_Travelled__c,
                                                                         RecordTypeId = Expenses.RecordTypeId,
                                                                         To__c = Expenses.To__c,
                                                                         Toll_Location__c = Expenses.Toll_Location__c,
                                                                         Who_was_called__c = Expenses.Who_was_called__c);
            
            Cloned.add(Expense);
        }
        try {
        	insert Cloned;
        } catch (DmlException e) {
        	System.debug(e);
        }
        return null;
    }
}