({
  init: function(cmp, event, helper) {
    if ($A.util.isUndefinedOrNull(cmp.get("v.PVForm.isCheckFax"))) {
      cmp.set("v.PVForm.isCheckFax", false);
    }
  },
  
  ShowButtonLink: function(cmp, event, helper){
    helper.ShowButtonLink(cmp);
  },

  gotoURL: function(cmp, event, helper) {
    helper.gotoURL(cmp, event, helper);
  },

  gotoURLotp: function(cmp, event, helper) {
    helper.gotoURLotp(cmp, event, helper);
  }

  
});