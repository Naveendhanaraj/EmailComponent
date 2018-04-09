/** Class Name   : TXP_EmailConversationCntl
*  Description  : This is Email Conversation Controller
*  Created By   : Naveen  
*  Created On   : 18th Feb 2018
*
*  Modification Log:  
*  --------------------------------------------------------------------------------------------------------------------------------------
*   Developer                Date                   Modification ID      Description 
*  ---------------------------------------------------------------------------------------------------------------------------------------
**/
global with sharing class EmailConversationCntl{
    
/**
* @description : To get all Email messages related to Record ID 
* @param : RecID
* @return : List<EmailMessage>
**/
    
    @AuraEnabled
    global static List<EmailMessage> getEmailMessages(String RecId){
        
        system.debug('>>>>>>>>>>Id>>>'+ RecId);
        String ObjectName='';
        List<String> myFilter = new List<String>();    
        if(RecId.startsWith('00Q')){
            ObjectName='Lead__c';
            myFilter.add('Lead__c  =\''+ RecId+'\'');
        }
        else if(RecId.startsWith('006')){
            ObjectName='Opportunity__c';
            myFilter.add('Opportunity__c  =\''+ RecId+'\'');
        }
        else if(RecId.startsWith('001')){
            ObjectName='Account__c';
            myFilter.add('Account__c  =\''+ RecId+'\'');
        }
        /*else if(recid.startsWith('a1B')){
             ObjectName='Reservation__c';
            myFilter.add('Reservation__c  =\''+ RecId+'\'');
        }*/
        else if(recid.startsWith('0Q0')){
             ObjectName='Quote__c';
            myFilter.add('Quote__c  =\''+ RecId+'\'');
        }  
        else if(recid.startsWith('003')){
             ObjectName='Contact__c';
            myFilter.add('Contact__c  =\''+ RecId+'\'');
        }   
        
        System.debug('@@@@@Obejct NAme@@'+ObjectName);
        System.debug('@@@@@REcord Id@@'+RecId);
        
        String  queryString='SELECT Id, Subject,Status,TextBody,Incoming,HtmlBody,Headers,FromName,FromAddress,ToAddress,Contact__c,Opportunity__c,MessageDate,Lead__c,Account__c FROM EmailMessage';
        
        if(myFilter.size()>0){
            queryString += ' WHERE ' + myFilter[0];
            
        }
        else {
            string ss = 'No Emails';
        }
        system.debug('Structured Query>>>'+queryString);
        List<EmailMessage> allEmailMessages= database.query(queryString);
        system.debug('>>>>>>>>>>All Records>>>'+allEmailMessages);
        return allEmailMessages;
        
    }
    
    @AuraEnabled
    global static string getpassemaildetails(String RecordId){
        system.debug('>>>>>>>>>>Id>>>'+ RecordId);
        string idm = RecordId;
        string email='';
        system.debug('>>>>>>>>>>RecordId>>>'+ idm);
        
        If (idm.startsWith('003')){
            List<Contact> passvalues = [select id,Name,Email from Contact WHERE id =: idm limit 1];
            for(Contact l:passvalues ){
                email= l.Email ;
            }
            return email;
        }
        else if(idm.startsWith('00Q')){
            List<Lead> passvalues = [select id,Name,Email from Lead WHERE id =: idm limit 1];
            for(Lead l:passvalues ){
                email= l.Email ;
            }
            return email;
        }
        else if(idm.startsWith('006')){
             List<OpportunityContactRole> passvalues = [select id,ContactId,IsPrimary,OpportunityId,Role,Contact.Email from OpportunityContactRole where OpportunityId=: idm limit 1];
            for(OpportunityContactRole l:passvalues ){
                email = l.Contact.Email;
            }
            return email;
        }
         else if(idm.startsWith('0Q0')){
         List<Quote>quoid = [select id,Name,ContactId,Email from Quote where id =: idm LIMIT 1];
            for (Quote opc : quoid ){
                email = opc.Email;
            }
             return email;
         }
        else if(idm.startsWith('001')){
            List<Account>accid = [SELECT Id, (SELECT Contact.Name,Contact.Email FROM AccountContactRelations) FROM Account where id =: idm LIMIT 1 ];
            System.debug('accid '+accid[0]);
            for (Account acc:accid){
                for (AccountContactRelation actr : acc.AccountContactRelations ){
                    system.debug('act.Contact.Email = '+actr.Contact.Email);
                    email = actr.Contact.Email;
                }
            }
            return email;
        }
       /* else if(idm.startsWith('a1B')){
             List<Reservation__c> passvalues = [select id,Name,Guest__r.Name,Guest__r.Email__c from Reservation__c  WHERE id =: idm limit 1];
            for(Reservation__c l:passvalues ){
                email= l.Guest__r.Email__c ;
                system.debug('email '+ email);
            }
            return email;
        }*/
        return email;
    }
    
    
    @AuraEnabled
    global static EmailMessage getemailAddress(String EMsgId){
        system.debug('>>>>>>>>>>Id>>>'+ EMsgId);
        string emid = EMsgId;
        system.debug('>>>>>>>>>>RecordId>>>'+ emid);
        List<EmailMessage> passemid = [select id,FromAddress,Lead__c,Contact__c,Account__c,TextBody,ToAddress,Subject,Opportunity__c,HtmlBody,Incoming from EmailMessage WHERE id =: emid limit 1];
        string email='';
                
        return passemid[0];
    }
    
}