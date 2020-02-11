({  init: function(component){
    var action = component.get('c.getArea');
    action.setCallback(this, function(response) {
        var state = response.getState();
        if (state == 'SUCCESS') {
            var result = response.getReturnValue();
            console.log('resultat', JSON.stringify(result));
            if (result.error == false ) {
                console.log('result', JSON.stringify(result));
                var regions = result.regions;
                var existedAreaAffari = result.existedQueueAssignement;
                component.set('v.regions', regions);
                if(result.existedQueueAssignement){

               
                    component.set('v.existedAreaAffari', existedAreaAffari);


                    var listItems1 = existedAreaAffari.hasOwnProperty('Q285__c') ? existedAreaAffari.Q285__c : [];
                    var listItemsQ285 = [];
                    console.log('List ItemsQ285',listItems1 );
                    if(listItems1.length > 0) {
                        listItemsQ285 = listItems1.split(';');
                    }
                    console.log('List ItemsQ285',listItemsQ285 );
                    component.set('v.listItemsQ285', listItemsQ285); 

                    var listItems2 = existedAreaAffari.hasOwnProperty('Q281__c') ? existedAreaAffari.Q281__c : [];
                    var listItemsQ281 = [];
                    console.log('List ItemsQ281',listItems2 );
                    if(listItems2.length > 0) {
                        listItemsQ281 = listItems2.split(';');
                    }
                    component.set('v.listItemsQ281', listItemsQ281); 

                    var listItems3 = existedAreaAffari.hasOwnProperty('Q286__c')? existedAreaAffari.Q286__c : [];
                    var listItemsQ286 = [];
                    console.log('List ItemsQ286',listItems3 );
                    if(listItems3.length > 0) {
                        listItemsQ286 = listItems3.split(';');
                    }
                    component.set('v.listItemsQ286', listItemsQ286);

                    var listItems4 = existedAreaAffari.hasOwnProperty('Q287__c') ? existedAreaAffari.Q287__c : [];
                    var listItemsQ287 = [];
                    console.log('List ItemsQ287',listItems4 );
                    if(listItems4.length > 0) {
                        listItemsQ287 = listItems4.split(';');
                    }
                    component.set('v.listItemsQ287', listItemsQ287);

                }
            } 
            
            this.initList(component); 
        }
    });
    $A.enqueueAction(action);
    },  
    initList: function(component) {
        // list of area
        // custom setting
        var listZoneRO = ['1', '2', '3', '4', '5'];
        var listZoneRE = ['6', '7', '8', '9', '10'];
        var listZoneRC = ['11', '12', '13', '14', '15'];
        var listZoneRA = ['16', '17', '18', '19', '20'];
        var listZoneRT = ['21', '22', '23', '24', '25'];
        var listZoneRS = ['26', '27', '28', '29', '30'];

        // list of unita affari
        // requete BD
        var listAffari = [{ value: 'Q281', label: 'Affari e Delibere 1' }, { value: 'Q285', label: 'Affari e Delibere 2' },
            { value: 'Q286', label: 'Affari e Delibere 3' }, { value: 'Q287', label: 'Affari e Delibere 4' }
        ];

        component.set('v.listZoneRO', listZoneRO);
        component.set('v.listZoneRE', listZoneRE);
        component.set('v.listZoneRC', listZoneRC);
        component.set('v.listZoneRA', listZoneRA);
        component.set('v.listZoneRT', listZoneRT);
        component.set('v.listZoneRS', listZoneRS);
        component.set('v.listAffari', listAffari);
    },

    handleSetQueue: function(component) {
        var queue = component.find("unitaAffari").get("v.value");
        component.set('v.unitaAffari', queue);
    },

    handleGetZone: function(component) {
        var regione = component.find("region").get("v.value");
        console.log('region', regione);
        var attributeName = 'v.listZone' + regione;
        var listAreas = component.get(attributeName);
        var listZones = [];
        if (Array.isArray(listAreas)) {
            listAreas.forEach(element => {
                listZones.push({
                    label: element,
                    value: element
                });
            });
            var unitaAffarisSelected = component.get('v.unitaAffarisSelected');
            //component.set('v.selectedAreaList', []);
            /*listZones.forEach(function(el, idx) {
                if (unitaAffarisSelected.indexOf(el.value) != -1) {
                    listZones.splice(idx, 1);
                }
            });*/
            component.set('v.listZones', listZones);
        }
    },

    showToast: function(title, type, message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "type": type,
            "duration": 2000,
            "message": message
        });
        toastEvent.fire();
    }
})