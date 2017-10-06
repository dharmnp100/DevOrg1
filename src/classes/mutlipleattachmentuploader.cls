public class mutlipleattachmentuploader
{
    public List<Blob> attachFile {get; set;}

    public mutlipleattachmentuploader()
    {
        attachFile = new list<Blob>();
        Blob b = Blob.valueOf('2423');
        attachFile.add(b);
    }
    
    public PageReference addrow()
    {
        Blob b = Blob.valueOf('2423');
        attachFile.add(b);
        return null;
    }
    
    public PageReference insertAttach()
    {
        List<Attachment> attList = new List<Attachment>();
        for(Blob attachBody : attachFile)
        {
            Attachment att = new Attachment();
            att.ParentId = 'a009000000zdK9n';
            att.Body = attachBody;
            att.Name = 'TestFIle.txt.';
            attList.add(att);
        }
        insert attList;
        return null;
    }
}