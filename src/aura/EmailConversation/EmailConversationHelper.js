({
    getEmailMessages : function(component,event,currentRec) {
        console.log('###helper record id##'+currentRec);        
        var action = component.get("c.getEmailMessages");
        action.setParams({
            "RecId": currentRec             
        });
        
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {  
                var jsnResourcesArray = [];
                var iconblue = [];
                var icongreen = [];
                var jsonLastArray=[];
                jsnResourcesArray  =  response.getReturnValue();
                console.log(JSON.stringify(jsnResourcesArray[1]));
               // console.log('MessageDate>>>>>>'+jsnResourcesArray.MessageDate);
                for(var i=0;i<jsnResourcesArray.length;i++  ){
                    if(jsnResourcesArray[i].Incoming==true){                         
                        jsonLastArray.push({
                            'Incoming':jsnResourcesArray[i].Incoming,
                            'Subject':jsnResourcesArray[i].Subject,
                            'FromName':jsnResourcesArray[i].FromName,
                            'FromAddress':jsnResourcesArray[i].FromAddress,
                            'ToAddress':jsnResourcesArray[i].ToAddress,
                            'HtmlBody':jsnResourcesArray[i].HtmlBody,
                            'Id':jsnResourcesArray[i].Id,
                            'MessageDate':jsnResourcesArray[i].MessageDate,
                            'iconBlue':false
                        });
                    }
                    else{
                        /*  jsnResourcesArray[i].iconblue=True;
                        jsnResourcesArray[i].icongreen=false;*/
                        jsonLastArray.push({
                            'Incoming':jsnResourcesArray[i].Incoming,
                            'Subject':jsnResourcesArray[i].Subject,
                            'FromName':jsnResourcesArray[i].FromName,
                            'FromAddress':jsnResourcesArray[i].FromAddress,
                            'ToAddress':jsnResourcesArray[i].ToAddress,
                            'HtmlBody':jsnResourcesArray[i].HtmlBody,
                            'Id':jsnResourcesArray[i].Id,
                            'MessageDate':jsnResourcesArray[i].MessageDate,
                            'iconBlue':true
                        });
                    }
                }
                //component.set("v.EmailMsgs", response.getReturnValue());
                component.set("v.EmailMsgs", jsonLastArray);
            } 
            else if (state === "INCOMPLETE") {
                console.log("No response from server or client is offline.")
                var myErrMsg='No response from server or client is offline.';
                
            } else if (state === "ERROR") {                
                console.log("Error: ");
            }
        });
        $A.enqueueAction(action);        
    },
    
    sendemail:function(component,event,passRec) {
        var action = component.get("c.getpassemaildetails");
        action.setParams({
            "RecordId": passRec
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS") {
                var emailAddress =  response.getReturnValue();
                console.log('@@@@emailAddress'+ emailAddress);
                var modalBody;
                $A.createComponent("c:EmailComponent", {
                    "email": emailAddress,
                    "recordId":passRec
                },
                                   
                                   function(content, status) {
                                       if (status === "SUCCESS") {
                                           
                                           console.log('INside success >>'+content);
                                           modalBody = content;
                                           component.find('overlayLib').showCustomModal({
                                               header: "",
                                               body: modalBody,
                                               showCloseButton: true,
                                               cssClass: "mymodal",
                                               closeCallback: function() {                                                                                                                                
                                                   console.log('You closed the alert!');
                                               }
                                           }).then(function (overlay) {
                                               component.set('v.overlayPanel', overlay);
                                               
                                           });
                                           
                                       }
                                   });
                
            } else {
                console.log('Problem getting account, response state: ' + state);
            }
        });
        $A.enqueueAction(action);
    },
    replyEmail:function(component,event,repid,emidrply){
        console.log('camein');
        var action = component.get("c.getemailAddress");
        action.setParams({
            "EMsgId": repid
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var email='';
            var subject='';
            var htmlbody ='';
            if(state === "SUCCESS") {
                var emailMsg =  response.getReturnValue();
                component.set("v.body",cleanText);
                console.log('emailMsg[0]'+emailMsg[0]);
                console.log('@@@@emailAddress'+ emailMsg);
                console.log('emailMsg.Incoming  '+ emailMsg.Incoming );
                console.log('emailMsg.FromAddress  '+ emailMsg.FromAddress );
                console.log('emailMsg.Subject  '+ emailMsg.Subject );
                console.log('emailMsg.HtmlBody  '+ emailMsg.HtmlBody );
                console.log('emailMsg.TextBody  '+ emailMsg.TextBody );
                var cleanText ='';
                var str = emailMsg.HtmlBody;
                cleanText = str.replace(/<\/?[^>]+(>|$)/g, "");
                console.log('strip_html_tags '+ cleanText);
                if (emailMsg.Incoming  == true){
                    console.log('called true');
                    email= emailMsg.FromAddress;
                    subject= emailMsg.Subject;
                }
                if(emailMsg.Incoming == false){
                    email= emailMsg.ToAddress;
                    subject= emailMsg.Subject;
                }
                console.log('email'+ email);
                var modalBody ;
                $A.createComponent("c:EmailComponent", {
                    'email':email,
                    'subject':subject,
                    'bodytext':cleanText,
                    'recordId':emidrply
                },               
                                   function(content, status) {
                                       if (status === "SUCCESS") {
                                           console.log('INside success >>'+content);
                                           modalBody = content;
                                           component.find('overlayLib').showCustomModal({
                                               header: "",
                                               body: modalBody,
                                               showCloseButton: true,
                                               cssClass: "mymodal",
                                               closeCallback: function() {                                                                                                                                
                                                   console.log('You closed the alert!');
                                               }
                                           })
                                           
                                       }
                                   });
                
            }
        });
        $A.enqueueAction(action);
    }
    
})