/** Class Name  : EmailServiceOutbound
*  Description  : This class used to sending the email messages to contact,lead,
*  Created By   : Naveen  
*  Created On   : 01st Feb 2018
*
*  Modification Log:  
*  --------------------------------------------------------------------------------------------------------------------------------------
*   Developer                Date                   Modification ID      Description 
*  ---------------------------------------------------------------------------------------------------------------------------------------
**/
public class EmailServiceOutbound {
    @AuraEnabled 
    public static void sendMailMethod(String mMail ,String mSubject ,String mbody,string recid){
        system.debug('>>>>recordid>&&'+ recid);
        system.debug('>>main>>>'+mMail);
        system.debug('>>subject>>>'+mSubject);
        system.debug('>>body>>>'+mbody);
        //Inserting the record id in Email subject
        string subrec= '('+ recid +')';  
        // For storing Relation Id
        string opcid ='';
        //Email Sending Start
        List<Messaging.SingleEmailMessage> mails =  new List<Messaging.SingleEmailMessage>();  
        //Create a new Email
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();        
        //Set list of people who should get the email        
        List<String> sendTo = mMail.split(',');
        //Setting Senders
        mail.setToAddresses(sendTo);        
        String addrUrl='replyemailtocontact@1xa8w2dg2mv8jwboee0zu8kf5yl5i45x4x2sy11h5871sme9vu.28-s3hgeay.ap6.apex.salesforce.com';
        
        // Set who the email is sent from
        mail.setReplyTo(addrUrl); // change it with your mail address.
        mail.setSenderDisplayName(UserInfo.getName() ); 
        system.debug('>>>>>=='+ UserInfo.getName() );   
        // Subject from Email Component and Record ID
        mail.setSubject(mSubject + subrec );
        //Setting Body from Email Component
        mail.setHtmlBody(mbody);        
        // Add your email to the master list
        mails.add(mail);        
        try {
            
            //Add Inbound Email Message for contact
            EmailMessage caseEmailMessage = new EmailMessage();
            caseEmailMessage.fromAddress= UserInfo.getUserEmail();
            caseEmailMessage.ToAddress = mMail;
            caseEmailMessage.FromName = UserInfo.getName();
            caseEmailMessage.Subject = mSubject;
            caseEmailMessage.HtmlBody = mbody;
            caseEmailMessage.Incoming= False;
            caseEmailMessage.TextBody = mbody;
            caseEmailMessage.status = '3';
            
            if(recid.startsWith('003')){
                caseEmailMessage.Contact__c = recid;
            }
            else if(recid.startsWith('001')){
                caseEmailMessage.Account__c = recid;
            }
            else if(recid.startsWith('00Q')){
                caseEmailMessage.Lead__c = recid;
            }
            else if(recid.startsWith('006')){
                caseEmailMessage.Opportunity__c = recid;
            }
            else if(recid.startsWith('0Q0')){
                caseEmailMessage.Quote__c = recid;
            }
            
            //For Custom Object
            /* else if(recid.startsWith('a1B')){
            caseEmailMessage.Reservation__c = recid;
            }
            */
            insert caseEmailMessage;  
            
            system.debug('>>>>>=='+ caseEmailMessage ); 
            system.debug('>>>>>=='+ caseEmailMessage.Id );
            
            // Add Email Message Relation for id of the sender
            EmailMessageRelation emr = new EmailMessageRelation();
            emr.EmailMessageId = caseEmailMessage.id;
            emr.RelationAddress = UserInfo.getUserEmail();
            emr.RelationType = 'FromAddress';
            
            //Contact Email Message Relation Id
            if(recid.startsWith('003')){
                emr.RelationId = recid;
            }
            
            //Opportunity Email Message Relation Id
            else if(recid.startsWith('006')){
                List<OpportunityContactRole>pasid = [select id,ContactId,IsPrimary,OpportunityId,Role from OpportunityContactRole where OpportunityId=: recid];
                for (OpportunityContactRole opc : pasid ){
                    opcid = opc.ContactId;
                }
                system.debug('#####'+ opcid);
                emr.RelationId = opcid;
            }
            
            //Lead Email Message Relation Id
            else if(recid.startsWith('00Q')){
                emr.RelationId = recid;
            }
            
            //Quote Email Message Relation Id
            else if(recid.startsWith('0Q0')){
                List<Quote>quoid = [select id,Name,ContactId from Quote where id =:recid LIMIT 1];
                for (Quote opc : quoid ){
                    opcid = opc.ContactId;
                }
                emr.RelationId = opcid;
            }
            
            //Account Email Message Relation Id
            else if(recid.startsWith('001')){
                List<Account>accid = [SELECT Id, (SELECT Id,Contact.Id, Contact.Name,Contact.Email FROM AccountContactRelations) FROM Account where id =: recid LIMIT 1 ];
                for (Account acc:accid){
                    for (AccountContactRelation actr : acc.AccountContactRelations ){
                        system.debug('act.Contact.Id = '+actr.Contact.Id);
                        opcid = actr.Contact.Id;
                    }
                }
                emr.RelationId = opcid ;
            }
            
            /* //Reservation Email Message Relation Id custom object
            else if(recid.startsWith('a1B')){
            emr.RelationId = recid;
            }
            */
            
            insert emr;     
            system.debug('>>>>>=='+ emr ); 
            system.debug('>>>>>=='+ emr.Id );
            
            // Send all emails in the master list
            Messaging.sendEmail(mails);
            system.debug('>>>>>=='+ mails);           
            
        }
        catch(Exception e){
            System.debug('Query Issue: ' + e);
        } 
        
    }   
}