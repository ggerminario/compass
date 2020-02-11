({
    doInit: function(component) {
        var action = component.get("c.getProfiles");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                console.log("data >>", data);
                if (data.error) {
                    console.log("data error>>", data.message);
                    //this.showToast(data.message, "ERROR");
                } else {
                    var profiles = data.profiles;
                    var options = [];
                    var pr      = {}
                    var pr1     = {}
                    var profileIdBranchManager;
                    
                    profiles.forEach(function(profile) {
                        if( profile.Name === 'Trainer' )
					    {
                            pr = { 'label':'Invia a tutti i Trainer', 'value':profile.Id };
                            //pr = { 'label':'Invia a tutti i '+profile.Name, 'value': profile.Id };
                        
                        }else if( profile.Name === 'Area Manager' )
                        {
                            //alert('1');
                            //pr1 = { 'label': 'Invia a tutti i Region Manager' , 'value': profile.Id };
                            pr = { 'label': 'Invia ' + profile.Name, 'value': profile.Id };
                            //pr1   = { 'label': 'Invia a tutti i Region Manager', 'value':profile.Id };
                            //pr    = { 'label': 'Invia Branch Manager', 'value':profile.Id};
                            profileIdBranchManager = profile.Id+'__xxx';
                        
                        }else if( profile.Name === 'Branch Manager' ){
                        
                            pr = { 'label': 'Invia ' + profile.Name, 'value': profile.Id };
                        
                        }
                        
                        options.push(pr);
                        //alert(JSON.stringify(options));

                    });
                    pr1   = { 'label': 'Invia a tutti i Region Manager', 'value':profileIdBranchManager };

                    options.push(pr1);
                    //alert(JSON.stringify(options));
                    component.set("v.profiles", options);
                    console.log("data >>", data);
                    //this.showToast(data.message, "SUCCESS");
                    //alert('04_12_2019 options->'+JSON.stringify(options));
                }
            } else {
                console.log("data >>", data);
                //this.showToast("Salvataggio non effettuato!", "ERROR");
            }
        });
        $A.enqueueAction(action);
    },
    openSection : function (cmp, event) {
        var sec1 = cmp.get('v.sec1');
        var sec2 = cmp.get('v.sec2');
        var sec3 = cmp.get('v.sec3');
        var sec4 = cmp.get('v.sec4');
        var sec5 = cmp.get('v.sec5');
        
        var l1 = [];
        var l2 = [];
        var l3 = [];
        var l4 = [];
        var l5 = [];
        
        var loaded = cmp.get('v.Parent');
        
        /*loaded.forEach(function(value, key) {
            if(sec1.includes(key) && value){
                l1.push(key);
            }
            else  if(sec1.includes(key) && value){
                l2.push(key);
            }
            else if(sec1.includes(key) && value){
                l3.push(key);
            }
            else if(sec1.includes(key) && value){
                l4.push(key);
            }
            else if(sec1.includes(key) && value){
                l5.push(key);
            }
            
            
        }, loaded)*/
        
        
        
        for(var key in loaded){
            if(sec1.includes(key) && loaded[key]){
                l1.push(key);
            }
            else  if(sec2.includes(key) && loaded[key]){
                l2.push(key);
            }
                else if(sec3.includes(key) && loaded[key]){
                    l3.push(key);
                }
                    else if(sec4.includes(key) && loaded[key]){
                        l4.push(key);
                    }
                        else if(sec5.includes(key) && loaded[key]){
                            l5.push(key);
                        }
        }
        
        cmp.set('v.activeSections',l1);
        //console.log('sec1 '+l1);
        cmp.set('v.activeSections2',l2);
        //console.log('sec1 '+l2);
        cmp.set('v.activeSections3',l3);
        //console.log('sec1 '+l3);
        cmp.set('v.activeSections4',l4);
        //console.log('sec1 '+l4);
        cmp.set('v.activeSections5',l5);
        //console.log('sec1 '+l5);
    },
    getType : function(component) {
        var idAcc = component.get('v.recordId');
        var tip = component.get('v.type');
        var action = component.get("c.getType");
        action.setParams({"idA":idAcc});
        action.setCallback(this, function(response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                var tip =response.getReturnValue();
                component.set("v.type",tip);
                console.log('Tipo '+tip);
            }
        });
        $A.enqueueAction(action);
        
    },
    concatMap: function(list,map2,listKeys){
       if (map2!=null) {
            for (const [key, value] of map2.entries()) {
                 
                if (listKeys.includes(key)) {
                    var filiale = new Object();
                    filiale.id = key;
                    filiale.figli = new Array;
                    if (value!=null) {
                        for (var i=0;i<value.length;i++) {
                            var figlio = new Object();
                            figlio.id = value[i];
                            filiale.figli.push(figlio);
                        }

                    }
                    var isPresent = list.some(fil => (fil.id === filiale.id));
                    if (!isPresent) {
                        list.push(filiale);
                    }
                }
            }
        }
        return list;
    },
    sendMail: function(component){
        
        var childIstance          = component.find("compChild");
        var MappaCheckBox         = component.get("v.Parent");
        //alert(childIstance.get("v.Checked_RA"));
        //alert(JSON.stringify(MappaCheckBox));
        //return;
        //Retrive checkBox Regioni
        var RA                    = component.get("v.Parent.Check_RA");
        var RC                    = component.get("v.Parent.Check_RC");
        var RE                    = component.get("v.Parent.Check_RE");
        var RO                    = component.get("v.Parent.Check_RO");
        var RS                    = component.get("v.Parent.Check_RS");
        var RT                    = component.get("v.Parent.Check_RT");
        var profileIds            = component.get('v.Parent.value');
        var message               = component.find("noteText").get('v.value');
        //Retrive checkBox Operazioni da effettuare
        var AreaManager           = component.get("v.Checked_Area_Manager");
        var BranchManager         = component.get("v.Checked_Branch_Manager");
        var Trainer               = component.get("v.Checked_Trainer");
        var RegionManager         = component.get("v.Checked_Region_Manager");
        var BranchEmployer         = component.get("v.Checked_Branch_Employer");
        var Borg         = component.get("v.Checked_Borg");
 
        //alert('AreaManager->'+AreaManager+BranchManager+Trainer+RegionManager);
        //alert('BranchManager->'+BranchManager);
 
        //Check compilazione campi Obbligatori
        if( message  === undefined )
        {
            this.showToast("Inserire obbligatoriamente del testo da inviare alla mail","ERROR");
            return;
        }
        if( AreaManager === false && BranchManager === false &&
            Trainer     === false && RegionManager === false && BranchEmployer === false && Borg === false)
        {
            this.showToast("Selezionare almeno un'operazione da effettuare!","ERROR");
            return;
        }


        var spinner = component.find("csvSpinner");
        $A.util.toggleClass(spinner, "slds-hide");
    
        var compChild_RA = component.find('compChild_RA');
        var compChild_RC = component.find('compChild_RC');
        var compChild_RE = component.find('compChild_RE');
        var compChild_RO = component.find('compChild_RO');
        var compChild_RS = component.find('compChild_RS');
        var compChild_RT = component.find('compChild_RT');
        var map_RA = compChild_RA.get('v.checkValue');
        var map_RC = compChild_RC.get('v.checkValue');
        var map_RE = compChild_RE.get('v.checkValue');
        var map_RO = compChild_RO.get('v.checkValue');
        var map_RS = compChild_RS.get('v.checkValue');
        var map_RT = compChild_RT.get('v.checkValue');
        //console.log('map_RA:'+map_RA.get('16'));
        var listFiliali = new Array();
        listFiliali = this.concatMap(listFiliali,map_RA,['16','17','18','19','20']);
        listFiliali = this.concatMap(listFiliali,map_RC,['11','12','13','14','15']);
        listFiliali = this.concatMap(listFiliali,map_RE,['10','6','7','8','9']);
        listFiliali = this.concatMap(listFiliali,map_RO,['1','2','3','4','5']);
        listFiliali = this.concatMap(listFiliali,map_RS,['26','27','28','29','30']);
        listFiliali = this.concatMap(listFiliali,map_RT,['21','22','23','24','25']);
        console.log('listFiliali:'+listFiliali);

        
        var action = component.get("c.sendingMail");
            action.setParams({ 'message': message , 'RA':RA , 'RC':RC , 'RE':RE , 'RO':RO , 'RS':RS , 'RT':RT ,
                              'AreaManager': AreaManager , 'BranchManager': BranchManager , 'Trainer': Trainer , 'RegionManager': RegionManager , 'BranchEmployer':BranchEmployer, 
                              'Borg' : Borg, 'MappaCheckBox': MappaCheckBox, 'listaFiliali' : JSON.stringify(listFiliali)
                             });
            action.setCallback(this, function(response) 
            {
                  var state = response.getState();
                  if( state === "SUCCESS" )
                  {
                      var data = response.getReturnValue();
                      //alert("data >>", data);
                      if( data.error )
                      {
                          console.log("data error>>", data.message);
                          //this.showToast(data.message, "ERROR");
                      }else{
                          var users = data.message;
                          console.log("users >>", users);
                          component.set('v.value', []);
                          component.find("noteText").set('v.value', '');
                          $A.get('e.force:refreshView').fire();
                          var spinner = component.find("csvSpinner");
                          $A.util.addClass(spinner, "slds-hide");
                          this.showToast(data.message, "SUCCESS");
                     }
            
                  }else{
                          console.log("data >>", data);
                          this.showToast("Email not send!", "ERROR");
                  }
            });
            $A.enqueueAction(action);
    },
    showToast: function(message, type){
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            message: message,
            type: type
        });
        toastEvent.fire();
    }
    
})