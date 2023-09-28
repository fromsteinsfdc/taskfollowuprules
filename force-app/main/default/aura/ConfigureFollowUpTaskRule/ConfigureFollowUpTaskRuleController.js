({
    init : function (component) {
        // Find the component whose aura:id is "flowData"
        var flow = component.find("flowCmp");
        // In that component, start your flow. Reference the flow's API Name.
        var inputVariables = [
            { name : "recordId", type : "String", value: component.get("v.recordId") || "" }
        ];

        flow.startFlow("New_Task_Follow_Up_Rule", inputVariables);
    },
})