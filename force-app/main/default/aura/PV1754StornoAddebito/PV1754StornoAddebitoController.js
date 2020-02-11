({
    
        doInit: function(component, event, helper) {
           helper.init(component, event);

        },
    
        

        
        
        sommaTotali: function(component, event, helper){
            var somma = component.get("v.tipoRimborso").reduce((accumulator, currentValue) => ({value: Number(accumulator.value) + Number(currentValue.value)}));
            component.set("v.sommaStorni", somma.value);
        }
       
    
})