/**
 * Created by Igor on 06.02.2020.
 */
({
    doInit : function (component, event, helper) {
        var recordId = component.get("v.recordId");
        console.log("recordId " + recordId);
        var action = component.get("c.hasInvoiceNumber");

        action.setParams({
            "accId" : recordId
        });

        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                console.log('doInit success');
                component.set("v.hasNumber", response.getReturnValue());
            }else{
                console.log("doInit failed with state: " + state);
            }
        });
        $A.enqueueAction(action);
    }
})