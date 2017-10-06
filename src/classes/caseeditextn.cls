public class caseeditextn
{
    public Case csRec {get; set;}
    
    public Boolean saveButtonDisabled {get; set;}
    public Boolean isError {get; set;}
    
    public caseeditextn(ApexPages.StandardController cnt)
    {
        csRec = new Case();
        csRec = (Case)cnt.getRecord();
        saveButtonDisabled  = false;
        isError = false;
    }
    
    public PageReference saveRecord()
    {
        
        saveButtonDisabled  = true;
        try
        {
            insert csRec;
            isError = false;
            
        }
        catch(Exception E)
        {   
            saveButtonDisabled  = false;
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,E.getMessage());
            ApexPages.addMessage(myMsg);
            isError = true;
        }
        return null;
        
    }
}