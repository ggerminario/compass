({
    handleSectionToggle: function (cmp, event,helper) {
        console.log('handleSectionToggle');
        var activeSection  = event.getSource().get("v.activeSectionName");
        console.log('activeSection:'+activeSection);
        var newList = activeSection.toString().split(",");
        var listActiveSection = cmp.get('v.listActiveSection');
        console.log('listActiveSection:'+listActiveSection);
        var oldList = listActiveSection.toString().split(",");
        var activeSectionSelected = null;
        for (var i=0;i<newList.length;i++) {
            var found = false;
            for (var j=0;j<oldList.length;j++) {
                if (newList[i]==oldList[j]) {
                    found = true;
                }
            }
            if (!found) {
                activeSectionSelected=newList[i];
                break;
            }

        }
        console.log('activeSectionSelected:'+activeSectionSelected);
        cmp.set('v.listActiveSection',activeSection)
        if (activeSectionSelected!=null) {
  
            var area =activeSectionSelected.substring(1);
            console.log('area:'+area);
            var checkelem = cmp.find('C'+area);
            console.log('checkelem:'+checkelem);
            if (checkelem!=null) {
                var isChecked = checkelem.get("v.checked");
                console.log('isChecked:'+isChecked);
                var elements = document.querySelectorAll('[id^="'+area+'-"]');
                if (elements!=null && elements.length>0) {
                    for (var z = 0; z<elements.length;z++) {
                       elements[z].checked = isChecked;
                       console.log('z:'+z);
                       console.log('elements[z]:'+elements[z]);
                       helper.checkValueArea(cmp, event,area, isChecked, elements[z].value); 
                    }
                }
            }
        }
        
    },
    doInit : function (cmp, event,helper) {
 		console.log('figlio carico '+cmp.get('v.Valore'));
        setTimeout(function(){ helper.openSection (cmp, event); }, 500);
    },
    printState2 : function (cmp, event,helper){
  //      console.log('fifff' +cmp.get('v.name') +JSON.stringify(cmp.get('v.Valore')));
   //     var item = event.getSource().getLocalId();
   //     helper.clearView(cmp, event, item);
  //      helper.openSection(cmp, event);
    },
    onchangeEvent : function( component,event,helper){
        var area = event.getSource().get("v.value");
        var isChecked = event.getSource().get("v.checked");
//        console.log('area:'+area);
//        console.log('isChecked:'+isChecked);
        var elements = document.querySelectorAll('[id^="'+area+'-"]');
        if (elements!=null && elements.length>0) {
            for (var i = 0; i<elements.length;i++) {
               elements[i].checked = isChecked;
               helper.checkValueArea(component, event,area,isChecked,elements[i].value);       
            }
        }
        
    },
    checkValue : function (cmp, event,helper){
        
        var selectObject = event.target;
        var area = selectObject.dataset.area;
        var value = selectObject.dataset.value;
  //      console.log('area:'+area);
 //       console.log('filiale:'+filiale);
 //       console.log('value:'+value);
 //       console.log('selectObject:'+selectObject.checked);
  //      selectObject.style.backgroundColor = "#ffffff";
 //       selectObject.style.backgroundColor = "#ffffff";
 //       selectObject.zoom= "1.5";
        helper.checkValueArea(cmp, event,area,selectObject.checked,value);       
    }
         
})