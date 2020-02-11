({

    // Your renderer method overrides go here
    render: function(component, helper) {
        console.log("---entry in render---");
        var ret = this.superRender();
        console.log('################  ret' + ret);
        console.log('##################### comp ' + component.get("v.dealer"));

        return ret;
    },
    afterRender: function(component, helper) {
        this.superAfterRender();
        console.log("---entry in afterRender---");
        // helper.performShowingLoggedInUserDetails(component);
        console.log('################  Account ' + component.get("v.dealer"));
        var account = component.get("v.dealer");
        if (account.Cases !== undefined) {
            console.log('################  account.Cases ' + JSON.stringify(account.Cases));
            component.set("v.caseDealer", account.Cases[0]);
        }
        helper.handleManageContact(component, event, helper);

        /* console.log('############# capo fi' + component.get('v.capoFiliale'));
         component.set("v.test", "test ok");*/
        helper.searchDisponibilitaFiliale(component, event);
        helper.verificaRequisitiDematerializzazioneDealer(component, event);

    },
    /*  rerender: function(component, helper) {
        console.log("---entry in rerender---");
        this.superRerender();
        var capo = component.get('v.capoFiliale');
        console.log('############# capo rerender' + component.get('v.capoFiliale'));
        console.log('############# capo rerender' + JSON.stringify(capo));
        console.log('############# capo rerender' + capo.Name);
        //   component.set("v.usercapoFiliale", capo.resultat);
 
    } */

})