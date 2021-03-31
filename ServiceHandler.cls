public class ServiceHandler {
    public static void NewService(List<Service_Invoice__c> triggerNew){
        List <Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
            
            for (Service_Invoice__c SInvoice : triggerNew) {
                if (SInvoice.Status__c == 'Submitted'){
                    PageReference pdf = Page.ServicePDF;
                    pdf.getParameters().put('id',SInvoice.Id);
                    Blob body;
                    try {
                      body = pdf.getContent();
                    } catch (VisualforceException e) {
                      body = Blob.valueOf('Some Text');
                    }
                    
                    Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
                    attach.setContentType('application/pdf');
                    attach.setFileName('Service Invoice PDF.pdf');
                    attach.setInline(false);
                    attach.Body = body;
                    
                    List<String> sendTo = new List<String>();
                    sendTo.add('jpeters01@qa.com');
                    
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    mail.setUseSignature(false);
                    mail.setToAddresses(sendTo);
                    mail.setSubject('Completed Service Invoice');
                    mail.setHtmlBody('Attached is the complete Service Invoice for course: ' + SInvoice.Scheduled_Course__c + '.');
                    mail.setFileAttachments(new Messaging.EmailFileAttachment[] { attach });
                    mails.add(mail);
                }
            }
            if (mails.size() > 0){
                Messaging.sendEmail(mails);
			}
    }
    public static void UpdateService(List<Service_Invoice__c> triggerNew, Map<Id, Service_Invoice__c> oldMap){
        List <Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
            
            for (Service_Invoice__c SInvoice : triggerNew) {
                Service_Invoice__c OldInvoice = oldMap.get(SInvoice.ID);
                if (SInvoice.Status__c == 'Submitted' && SInvoice.Status__c != OldInvoice.Status__c){
                    PageReference pdf = Page.ServicePDF;
                    pdf.getParameters().put('id',SInvoice.Id);
                    Blob body;
                    try {
                      body = pdf.getContent();
                    } catch (VisualforceException e) {
                      body = Blob.valueOf('Some Text');
                    }
                    
                    Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
                    attach.setContentType('application/pdf');
                    attach.setFileName('Service Invoice PDF.pdf');
                    attach.setInline(false);
                    attach.Body = body;
                    
                    List<String> sendTo = new List<String>();
                    sendTo.add('jpeters01@qa.com');
                    
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    mail.setUseSignature(false);
                    mail.setToAddresses(sendTo);
                    mail.setSubject('Completed Service Invoice');
                    mail.setHtmlBody('Attached is the complete Service Invoice for course: ' + SInvoice.Scheduled_Course__c + '.');
                    mail.setFileAttachments(new Messaging.EmailFileAttachment[] { attach });
                    mails.add(mail);
                }
            }
            if (mails.size() > 0){
                Messaging.sendEmail(mails);
			}
    }
}