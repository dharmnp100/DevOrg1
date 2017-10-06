trigger TestAttachment on Attachment (before update) {
for(Attachment att : trigger.new)
{
    if(att.OwnerId != userInfo.getUserid())
    {
        att.addError('You are not the owner of this attachment, you can\'t update it.');
    }
}    
}