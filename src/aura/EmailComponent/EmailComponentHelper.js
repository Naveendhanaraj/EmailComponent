({
    sendHelper: function(component,event,helper, getEmail, getSubject, getbody,getrecid) {
        console.log('helperrecid'+getrecid);
        // call the server side controller method 	
        var action = component.get("c.sendMailMethod");
        // set the 3 params to sendMailMethod method 
        action.setParams({
            'mMail': getEmail,
            'mSubject': getSubject,
            'mbody': getbody,
            'recid':getrecid
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                var applicationEvent = $A.get("e.c:EventCloseModelPopup");
                applicationEvent.setParams({"message" : 'success'})
                applicationEvent.fire();
                console.log('cmpEvent '+applicationEvent);
                console.log('applicationEvent event fired');                
            }
            
        });
        $A.enqueueAction(action);
    }
})