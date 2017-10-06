public class PDFPageController
{
    public string pdfMode {Get; set;}
    
    public string theValue {Get; set;}

    public PDFPageController()
    {
        String theMode = ApexPages.CurrentPage().getParameters().get('v');
        system.debug('-theMode-->     '+theMode );
        if(theMode != null && theMode == 'pdf')
        {
            pdfMode = 'pdf';
        }
        else
        {
            pdfMode ='';
        }
    }
    
    public PageReference initAction()
    {
        String theMode = ApexPages.CurrentPage().getParameters().get('v');
        system.debug('-theMode--in atcion>     '+theMode );
        if(theMode != null && theMode == 'pdf')
        {
            pdfMode = 'pdf';
        }
        else
        {
            pdfMode ='';
        }
        return null;
    }
    
    
    public PageReference pdfGenerate()
    {
        pdfMode = 'pdf';
        //PageReference pageRef = Page.PDFPage2;
        //pageRef.getParameters().put('v','pdf');
        
        PageReference pageRef = new PageReference('/apex/PDFPage1');
        pageRef.getParameters().put('v',pdfMode);
        
        Blob attachBody = pageRef.getContentAsPDF();
        //system.debug('stringbody        ---  '+attachBody.tostring());
        Attachment attach = new Attachment();
        attach.Name = 'The_Attachment.pdf';
        attach.Body = attachBody;
        attach.ParentId = '0019000001J3c6D';
        attach.ContentType = 'application/pdf';
        insert attach;
        

        
        return null;
    }
}