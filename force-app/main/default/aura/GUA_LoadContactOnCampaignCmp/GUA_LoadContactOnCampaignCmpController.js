({
    handleUpload: function (cmp, evt, helper) {
        var txtFile = cmp.find("file").get("v.value");
        var campaignId = cmp.get("v.campaignId");
        console.log("campaignId  handle upload: " + campaignId);
        cmp.set("v.campaignId", campaignId);
        if (txtFile == '') {
            helper.showToast("Inserimento del file obbligatorio!", "ERROR");
        } else {
            helper.readCSV(cmp, campaignId);
        }

    },
    handleSave: function (cmp, event, helper) {
        helper.saveEscluso(cmp);
    },
    handleAnnulla: function (cmp, evt, helper) {
        helper.AnnullaHelper(cmp);
    },
    setSelectedCampaign: function (component, event, helper) {
        var campaignId = event.getParam("updateCampaign");
        console.log("campaignId selected before save Case: " + campaignId);
        component.set("v.campaignId", campaignId);
    },
    cancelField: function (component, event, helper) {
        helper.cancelField(component, event, helper);
    },
    handleDownload: function(component, event, helper){
     // get the Records [contact] list from 'ListOfContact' attribute 
     var stockData = component.get("v.linesWithErrors");
    
     // call the helper function which "return" the CSV data as a String   
     var csv = helper.convertArrayOfObjectsToCSV(component,stockData);   
      if (csv == null){return;} 
     
     // ####--code for create a temp. <a> html tag [link tag] for download the CSV file--####     
      var hiddenElement = document.createElement('a');
       hiddenElement.href = 'data:text/csv;charset=utf-8,' + encodeURI(csv);
       hiddenElement.target = '_self'; // 
       hiddenElement.download = 'ErrorInsertContact.csv';  // CSV file Name* you can change it.[only name not .csv] 
       document.body.appendChild(hiddenElement); // Required for FireFox browser
       hiddenElement.click(); // using click() js function to download csv file
     }
})