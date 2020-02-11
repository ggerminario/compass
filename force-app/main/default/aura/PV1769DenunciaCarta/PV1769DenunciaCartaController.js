({
    init: function(cmp, event, helper) {
        if ($A.util.isUndefinedOrNull(cmp.get("v.PVForm.isCheckFax"))) {
          cmp.set("v.PVForm.isCheckFax", false);
        }
    }
})