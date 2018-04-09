({
    sendMail: function(component, event, helper) {
        // when user click on Send button 
        // First we get all 3 fields values 	
        var getEmail = component.get("v.email");
        var getSubject = component.get("v.subject");
        var getbody = component.get("v.bodytext");
        var getrecid = component.get("v.recordId");
        console.log('Id>>>>>'+ getrecid);
        
        // check if Email field is Empty or not contains @ so display a alert message 
        // otherwise call call and pass the fields value to helper method    
        if ($A.util.isEmpty(getEmail) || !getEmail.includes("@")) {
            alert('Please Enter valid Email Address');
        } else {
            helper.sendHelper(component, event, helper,getEmail, getSubject, getbody,getrecid);
        }
    },
 
    // when user click on the close buttton on message popup ,
    // hide the Message box by set the mailStatus attribute to false
    // and clear all values of input fields.   
    closeMessage: function(component, event, helper) {
        component.set("v.mailStatus", false);
        component.set("v.email", null);
        component.set("v.subject", null);
        component.set("v.bodytext", null);
    },
})