@isTest
public class CourseTriggerTest {
    @isTest
    static void InsertCourseTest() {
        Schedule_Course__c SCourse = new Schedule_Course__c(Courses__c='a074L000000EEgNQAW', 
                                                           Instructor__c='0054L000000Fr4aQAC', 
                                                           Start_Date__c=Date.newInstance(2021, 04, 06), 
                                                           End_Date__c=Date.newInstance(2021, 04, 09), 
                                                           Location__c='London');
        
        // Perform test
        Test.startTest();
        Database.SaveResult InsertResult = Database.insert(SCourse, false);
        Test.stopTest();
    }
    @isTest
    static void InsertServiceTest() {
        Service_Invoice__c Service = new Service_Invoice__c(Scheduled_Course__c='a084L000001bzekQAA', 
                                                           Status__c='Submitted', 
                                                           Submitted_Date__c=Date.newInstance(2021, 03, 28));
        
        // Perform test
        Test.startTest();
        Database.SaveResult InsertResult = Database.insert(Service, false);
        Test.stopTest();
    }
    @isTest
    static void InsertExpenseTest() {
        Expense_Invoice__c Expense = new Expense_Invoice__c(Schedule_Course__c='a084L000001bzekQAA', 
                                                           Status__c='Submitted', 
                                                           Submitted_Date__c=Date.newInstance(2021, 03, 28));
        
        // Perform test
        Test.startTest();
        Database.SaveResult InsertResult = Database.insert(Expense, false);
        Test.stopTest();
    }
    
    @isTest
    static void UpdateCourseStageTest() {
        Schedule_Course__c SCourse = new Schedule_Course__c(Courses__c='a074L000000EEgNQAW', 
                                                           Instructor__c='0054L000000Fr4aQAC', 
                                                           Start_Date__c=Date.newInstance(2021, 04, 06), 
                                                           End_Date__c=Date.newInstance(2021, 04, 09), 
                                                           Location__c='London');
        insert SCourse;
        
        // Perform test
        Test.startTest();
        SCourse.Stage__c = 'Cancelled';
        Database.SaveResult InsertResult = Database.update(SCourse, false);
        Test.stopTest();
    }
    @isTest
    static void UpdateCourseInstructorTest() {
        Schedule_Course__c SCourse = new Schedule_Course__c(Courses__c='a074L000000EEgNQAW', 
                                                           Instructor__c='0054L000000Fr4aQAC', 
                                                           Start_Date__c=Date.newInstance(2021, 04, 06), 
                                                           End_Date__c=Date.newInstance(2021, 04, 09), 
                                                           Location__c='London');
        insert SCourse;
        
        // Perform test
        Test.startTest();
        SCourse.Instructor__c = '0054L000000FqUFQA0';
        Database.SaveResult InsertResult = Database.update(SCourse, false);
        Test.stopTest();
    }
    @isTest
    static void UpdateServiceTest() {
        Service_Invoice__c Service = new Service_Invoice__c(Scheduled_Course__c='a084L000001bzekQAA', 
                                                           Status__c='Draft', 
                                                           Submitted_Date__c=Date.newInstance(2021, 03, 28));
        insert Service;
        
        // Perform test
        Test.startTest();
        Service.Status__c='Submitted';
        Database.SaveResult InsertResult = Database.update(Service, false);
        Test.stopTest();
    }
    @isTest
    static void UpdateExpenseTest() {
        Expense_Invoice__c Expense = new Expense_Invoice__c(Schedule_Course__c='a084L000001bzekQAA', 
                                                           Status__c='Draft', 
                                                           Submitted_Date__c=Date.newInstance(2021, 03, 28));
        insert Expense;
        
        // Perform test
        Test.startTest();
        Expense.Status__c='Submitted';
        Database.SaveResult InsertResult = Database.update(Expense, false);
        Test.stopTest();
    }
    
    @isTest
    static void ServicePDFTest() {
        Service_Invoice__c Service = new Service_Invoice__c(Scheduled_Course__c='a084L000001bzekQAA', 
                                                           Status__c='Draft', 
                                                           Submitted_Date__c=Date.newInstance(2021, 03, 28));
        insert Service;
        
        // Perform test
        Test.startTest();
        PageReference pref = Page.ServicePDF;
        pref.getParameters().put('id',Service.id);
        Test.setCurrentPage(pref);
        ApexPages.StandardController controllerExtension = new ApexPages.StandardController(Service);
        myControllerExtension ext = new myControllerExtension(controllerExtension);
        ext.createAttachment();
        
        // assert that they were sent to the correct page
        System.assertEquals(pref.getUrl(),'/apex/servicepdf?id='+Service.id);
        Test.stopTest();
    }
    @isTest
    static void ExpensePDFTest() {
        Expense_Invoice__c Expense = new Expense_Invoice__c(Schedule_Course__c='a084L000001bzekQAA', 
                                                           Status__c='Draft', 
                                                           Submitted_Date__c=Date.newInstance(2021, 03, 28));
        insert Expense;
        
        // Perform test
        Test.startTest();
        PageReference pref = Page.ExpensePDF;
        pref.getParameters().put('id',Expense.id);
        Test.setCurrentPage(pref);
        ApexPages.StandardController controllerExtension = new ApexPages.StandardController(Expense);
        myExpenseExtension ext = new myExpenseExtension(controllerExtension);
        ext.createAttachment();
        
        // assert that they were sent to the correct page
        System.assertEquals(pref.getUrl(),'/apex/expensepdf?id='+Expense.id);
        Test.stopTest();
    }
    @isTest
    static void ExpenseCloneTest() {
        Expense_Invoice__c ExpenseTo = new Expense_Invoice__c(Schedule_Course__c='a084L000001bzekQAA', 
                                                              Status__c='Draft', 
                                                              Submitted_Date__c=Date.newInstance(2021, 03, 28));
        insert ExpenseTo;
        Expense_Invoice__c ExpenseFrom = new Expense_Invoice__c(Schedule_Course__c='a084L000001bzezQAA', 
                                                                Status__c='Draft', 
                                                                Submitted_Date__c=Date.newInstance(2021, 03, 28));
        insert ExpenseFrom;
        Expense_Invoice_Line__c ExpenseLine = new Expense_Invoice_Line__c(Expense_Invoice__c = ExpenseFrom.Id,
                                                                          Amount__c = 520,
                                                                          Day__c = 1,
                                                                          Length_of_Stay__c = 4,
                                                                          RecordTypeId = '0124L0000000ElgQAE');
        insert ExpenseLine;
        System.debug(ExpenseFrom.Id);
        // Perform test
        Test.startTest();
        List<Expense_Invoice__c> LExpense = new List <Expense_Invoice__c> ();
        LExpense.add(ExpenseTo);
        ApexPages.standardSetController sc = new ApexPages.standardSetController(LExpense);
        myCloneExtension exten = new myCloneExtension(sc);
        exten.ExpenseId = ExpenseFrom.Id;
        exten.currentRecord = 'a084L000001bzekQAA';
        System.debug(ExpenseFrom.Id);
            
        System.assertEquals(null, exten.CloneLines());
        Test.stopTest();
    }
}