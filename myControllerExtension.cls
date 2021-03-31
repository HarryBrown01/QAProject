public class myControllerExtension {
    private final Service_Invoice__c course;
    
    public myControllerExtension(ApexPages.StandardController stdController) {
        this.course = (Service_Invoice__c )stdController.getRecord();
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
        attach.Name = 'Service Invoice PDF.pdf';
        attach.IsPrivate = false;
        attach.ParentId = course.Scheduled_Course__c;
        insert attach;
    }
}