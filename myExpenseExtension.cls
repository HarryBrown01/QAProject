public class myExpenseExtension {
    private final Expense_Invoice__c course;
    
    public myExpenseExtension(ApexPages.StandardController stdController) {
        this.course = (Expense_Invoice__c)stdController.getRecord();
    }
    public void createAttachment(){
        PageReference pdf = Page.ServicePDF;
        pdf.getParameters().put('id', course.Id);
    
        Attachment attach = new Attachment();
        
        Blob body;
        
        try {
            body = pdf.getContent();
        } catch (VisualforceException e) {
            body = Blob.valueOf('Some Text');
        }
        
        attach.Body = body;
        attach.Name = 'Expense Invoice PDF.pdf';
        attach.IsPrivate = false;
        attach.ParentId = course.Schedule_Course__c;
        insert attach;
    }
    
}