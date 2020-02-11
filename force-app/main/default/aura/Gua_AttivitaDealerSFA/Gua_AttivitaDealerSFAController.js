({
    doInit: function (component, event, helper) {
        var pageSize = component.get('v.pageSize');
        component.set('v.columns', [
            { label: 'Tipo Attività', fieldName: 'Subject', type: 'String' },
            { label: 'Priorità', fieldName: 'Priority', type: 'String' },
            { label: 'Pianificazione Per', fieldName: '', type: '' },
        ]);
        helper.getAllCasesByAccountId(component, pageSize);
    }

})