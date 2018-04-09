({
    doInit : function(component, event, helper) {
        var currentRec = component.get("v.recordId");
        console.log('>>>>>>'+currentRec);
        helper.getEmailMessages(component,event,currentRec);		
    },
    sendemailmsg : function(component, event, helper) {
        var passRec = component.get("v.recordId");
        console.log('>>>>>>@@@'+passRec);
        helper.sendemail(component,event,passRec);
        
    },
    replyEmailmsg:function(component, event, helper) {
        console.log('$$$$$$$$$');
        var emidrply = component.get("v.recordId");
        console.log('>>>>>>@@@'+emidrply);
        var repid = event.getSource().get("v.value")
        console.log(repid);
        helper.replyEmail(component,event,repid,emidrply);
    },
    handleEventCloseModelPopup:function(component, event, helper) {
        console.log('called handleEventCloseModelPopup');
        var overlayPanel = component.get('v.overlayPanel');
        overlayPanel[0].close(); 
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Success!",
            "type": "Success",
            "message": "Email Sent successfully"
        });
        toastEvent.fire();
        
    },
})