({
    saveNumber : function(component, event, helper){

        var invoiceNumber = component.find("invoiceInput").get("v.value");
        var sObjectType = component.get("v.sObjectName");
        var recordId = component.get("v.recordId");
        
        console.log("type: " + sObjectType);
        console.log('recordId: ' + recordId);

        var action;

        if (sObjectType == "Opportunity"){
            action = component.get("c.addInvoiceNumberOpp");
        }else if(sObjectType == "Account"){
            action = component.get("c.addInvoiceNumberAcc");
        }

        action.setParams({
            "recordId": component.get("v.recordId"),
            "invoiceNum": invoiceNumber
        });

        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                var resultToast = $A.get("e.force:showToast");
                resultToast.setParams({
                    "type": "success",
                    "title": "Success!",
                    "message": "Invoice Number succesfully added."
                });
                resultToast.fire();

                $A.get("e.force:closeQuickAction").fire();
                console.log("fillInvoiceNumber success");
            }else{
                console.log("fillInvoiceNumber failed with state " + state);
            }
        });
        $A.enqueueAction(action);
    }
})