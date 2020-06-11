({
    init: function (cmp, helper, event) {
        var data = cmp.get('v.data');
        var header = cmp.get('v.headers');
        var lstRows = [];

        for (var x in data) {
            var lstCells = [];
            for (var i in header) {
                lstCells.push(data[x][header[i].fieldName]);
            }
            lstRows.push(lstCells);
        }
        cmp.set('v.lstdata', lstRows);
    }
})
