({
    first: function (component, event, helper) {

        var membList = component.get("v.objects");

        var pageSize = component.get("v.pageSize");

        var numberOfLinesToDisplay = [];

        for (var i = 0; i < pageSize; i++) {

            numberOfLinesToDisplay.push(membList[i]);

        }

        component.set('v.numberOfLinesToDisplay', numberOfLinesToDisplay);

    },

    last: function (component, event, helper) {

        var membList = component.get("v.objects");

        var pageSize = component.get("v.pageSize");

        var totalSize = component.get("v.totalSize");

        var numberOfLinesToDisplay = [];

        for (var i = totalSize - pageSize + 1; i < totalSize; i++) {

            numberOfLinesToDisplay.push(membList[i]);

        }

        component.set('v.numberOfLinesToDisplay', numberOfLinesToDisplay);

    },

    next: function (component, event, helper) {

        var membList = component.get("v.objects");
        var end = component.get("v.end");
        var start = component.get("v.start");
        var pageSize = component.get("v.pageSize");
        var totalSize = component.get("v.totalSize");
        var numberOfLinesToDisplay = [];
        var counter = 0;
        for (var i = end + 1; i < end + pageSize + 1; i++) {
            if (totalSize >= i) {
               if (totalSize != i) {
                    numberOfLinesToDisplay.push(membList[i]);
                    counter++;
               } 
            }
        }
        start = start + counter;
        end = end + counter;
        component.set("v.start", start);
        component.set("v.end", end);
        component.set('v.numberOfLinesToDisplay', numberOfLinesToDisplay);

    },

    previous: function (component, event, helper) {

        var membList = component.get("v.objects");

        var end = component.get("v.end");

        var start = component.get("v.start");

        var pageSize = component.get("v.pageSize");

        var numberOfLinesToDisplay = [];

        var counter = 0;

        for (var i = start - pageSize; i < start; i++) {

            if (i > -1) {

                numberOfLinesToDisplay.push(membList[i]);

                counter++;

            }

            else {

                start++;

            }

        }

        start = start - counter;

        end = end - counter;

        component.set("v.start", start);

        component.set("v.end", end);

        component.set('v.numberOfLinesToDisplay', numberOfLinesToDisplay);

    }
})