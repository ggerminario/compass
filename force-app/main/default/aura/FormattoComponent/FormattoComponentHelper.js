({
	openSection : function (cmp, event) {
        var sec1 = cmp.get('v.sec1');
        var sec2 = cmp.get('v.sec2');
       
        var l1 = [];
        var l2 = [];
        
        
        var loaded = cmp.get('v.Valore');
        
        
        
        
        console.log('figlio '+JSON.stringify(loaded));
        for(var key in loaded){
            if(sec1.includes(key) && loaded[key]){
                l1.push(key);
            }
            else  if(sec2.includes(key) && loaded[key]){
                l2.push(key);
            }
            
        }
        
        cmp.set("v.activeSections6",l1);
        console.log('sec6 '+l1);
        cmp.set("v.activeSections7",l2);
        console.log('sec7 '+l2);
        
    },
    clearView : function (cmp, event, item){
        var valori = cmp.get('v.Valore');
        
        var newMap = new Map();
        console.log('111 '+JSON.stringify(valori)+'    '+item);
        var flag= valori[item];
        if(!flag){
            for(var key in valori){
                console.log(key+'  y  '+item);
                if(key.startsWith(item)){
                    newMap.set(key,false);
                }
                else{
                    newMap.set(key,valori[key]);
                }
            }
            function mapToObj(map){
                const obj = {}
                for (let [k,v] of map)
                    obj[k] = v
                    return obj
            }
            var myMap2 = mapToObj(newMap);
            cmp.set('v.Valore',myMap2);
            console.log('222 '+JSON.stringify(myMap2));
        }
        
        
    },
    checkValueArea : function (cmp, event,area,isChecked,value){
        
        var mapCheckValue = cmp.get("v.checkValue");
        if (mapCheckValue==null) {
            mapCheckValue = new Map;
        }
        var listValue = mapCheckValue.get(area);
        if (isChecked) {
            // aggiungi elemento
            if (listValue==null) {
                listValue = [];
            }
            if (listValue.indexOf(value)==-1) {
                listValue.push(value);
            }
            mapCheckValue.set(area,listValue);
        }
        else {
            // leva elemento
            if (listValue!=null) {
                var index = listValue.indexOf(value);
                if (index !== -1) {
                    listValue.splice(index, 1);
                } 
            }
            mapCheckValue.set(area,listValue);
        }            
        cmp.set("v.checkValue",mapCheckValue);
//        console.log('listValue ('+area+'):'+listValue);        
    }

})