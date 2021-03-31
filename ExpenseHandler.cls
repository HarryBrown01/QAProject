public class ExpenseHandler {
    public static void NewExpense(List<Expense_Invoice__c> triggerNew){
        List <Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
            
            for (Expense_Invoice__c EInvoice : triggerNew) {
                if (EInvoice.Status__c == 'Submitted'){
                    PageReference pdf = Page.ServicePDF;
                    pdf.getParameters().put('id',EInvoice.Id);
                    Blob body;
                    try {
                      body = pdf.getContent();
                    } catch (VisualforceException e) {
                      body = Blob.valueOf('Some Text');
                    }
                    
                    Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
                    attach.setContentType('application/pdf');
                    attach.setFileName('Expense Invoice PDF.pdf');
                    attach.setInline(false);
                    attach.Body = body;
                    
                    List<String> sendTo = new List<String>();
                    sendTo.add('jpeters01@qa.com');
                    
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    mail.setUseSignature(false);
                    mail.setToAddresses(sendTo);
                    mail.setSubject('Completed Expense Invoice');
                    mail.setHtmlBody('Attached is the complete Expense Invoice for course: ' + EInvoice.Schedule_Course__c + '.');
                    mail.setFileAttachments(new Messaging.EmailFileAttachment[] { attach });
                    mails.add(mail);
                }
            }
            if (mails.size() > 0){
                Messaging.sendEmail(mails);
			}
    }
    public static void UpdateExpense(List<Expense_Invoice__c> triggerNew, Map<Id, Expense_Invoice__c> oldMap){
        List <Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
            
            for (Expense_Invoice__c EInvoice : triggerNew) {
                Expense_Invoice__c OldInvoice = oldMap.get(EInvoice.ID);
                if (EInvoice.Status__c == 'Submitted' && EInvoice.Status__c != OldInvoice.Status__c){
                    PageReference pdf = Page.ServicePDF;
                    pdf.getParameters().put('id',EInvoice.Id);
                    Blob body;
                    try {
                      body = pdf.getContent();
                    } catch (VisualforceException e) {
                      body = Blob.valueOf('Some Text');
                    }
                    
                    Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
                    attach.setContentType('application/pdf');
                    attach.setFileName('Expense Invoice PDF.pdf');
                    attach.setInline(false);
                    attach.Body = body;
                    
                    List<String> sendTo = new List<String>();
                    sendTo.add('jpeters01@qa.com');
                    
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    mail.setUseSignature(false);
                    mail.setToAddresses(sendTo);
                    mail.setSubject('Completed Expense Invoice');
                    mail.setHtmlBody('Attached is the complete Expense Invoice for course: ' + EInvoice.Schedule_Course__c + '.');
                    mail.setFileAttachments(new Messaging.EmailFileAttachment[] { attach });
                    mails.add(mail);
                }
            }
            if (mails.size() > 0){
                Messaging.sendEmail(mails);
			}
    }
}