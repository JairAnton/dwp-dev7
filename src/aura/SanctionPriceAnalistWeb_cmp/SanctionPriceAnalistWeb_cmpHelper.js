({
    init: function (cmp, helper, event) {
        var action = cmp.get("c.getInfo");
        var recordId = cmp.get('v.recordId');
        action.setParams({
            'oppId': recordId
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var ret = response.getReturnValue();
                var generr = ret.errormessage;
                if (generr !== undefined) {
                    cmp.set('v.strErrorMessage', generr);
                    cmp.set('v.isLoad', true);
                    cmp.set('v.checkError', true);
                } else {
                    cmp.set('v.isLoad', true);
                    cmp.set('v.headers', [
                        { label: '', fieldName: 'empty', type: 'text' },
                        { label: ret.headers[0], fieldName: 'MIN', type: 'number', cellAttributes: { alignment: 'left' } },
                        { label: ret.headers[1], fieldName: 'MODEL', type: 'number', cellAttributes: { alignment: 'left' } },
                        { label: ret.headers[2], fieldName: 'REQU', type: 'number', cellAttributes: { alignment: 'left' } },
                        { label: ret.headers[3], fieldName: 'AUTH', type: 'number', cellAttributes: { alignment: 'left' } }
                    ]);
                    var formatNumber;
                    var teaminim = ret.teaminim;
                    if (teaminim !== undefined && teaminim !== '' && teaminim !== null) {
                        formatNumber = parseFloat(teaminim);
                        teaminim = formatNumber.toFixed(2);
                    }
                    var teamodel = ret.teamodel;
                    if (teamodel !== undefined && teamodel !== '' && teamodel !== null) {
                        formatNumber = parseFloat(teamodel);
                        teamodel = formatNumber.toFixed(2);
                    }
                    var teareq = ret.teareq;
                    if (teareq !== undefined && teareq !== '' && teareq !== null) {
                        formatNumber = parseFloat(teareq);
                        teareq = formatNumber.toFixed(2);
                    }
                    var teaapp = ret.teaapp;
                    if (teaapp !== undefined && teaapp !== '' && teaapp !== null) {
                        formatNumber = parseFloat(teaapp);
                        teaapp = formatNumber.toFixed(2);
                    }
                    var DI = ret.DI;
                    if (DI !== undefined && DI !== '' && DI !== null) {
                        formatNumber = parseFloat(DI);
                        DI = formatNumber.toFixed(2);
                    }
                    var spreadmodel = ret.spreadmodel;
                    if (spreadmodel !== undefined && spreadmodel !== '' && spreadmodel !== null) {
                        formatNumber = parseFloat(spreadmodel);
                        spreadmodel = formatNumber.toFixed(2);
                    }
                    var spreadreq = ret.spreadreq;
                    if (spreadreq !== undefined && spreadreq !== '' && spreadreq !== null) {
                        formatNumber = parseFloat(spreadreq);
                        spreadreq = formatNumber.toFixed(2);
                    }
                    var spreadapp = ret.spreadapp;
                    if (spreadapp !== undefined && spreadapp !== '' && spreadapp !== null) {
                        formatNumber = parseFloat(spreadapp);
                        spreadapp = formatNumber.toFixed(2);
                    }
                    var baiminim = ret.baiminim;
                    if (baiminim !== undefined && baiminim !== '' && baiminim !== null) {
                        formatNumber = parseFloat(baiminim);
                        baiminim = formatNumber.toFixed(2);
                    }
                    var baimodel = ret.baimodel;
                    if (baimodel !== undefined && baimodel !== '' && baimodel !== null) {
                        formatNumber = parseFloat(baimodel);
                        baimodel = formatNumber.toFixed(2);
                    }
                    var baireq = ret.baireq;
                    if (baireq !== undefined && baireq !== '' && baireq !== null) {
                        formatNumber = parseFloat(baireq);
                        baireq = formatNumber.toFixed(2);
                    }
                    var baiapp = ret.baiapp;
                    if (baiapp !== undefined && baiapp !== '' && baiapp !== null) {
                        formatNumber = parseFloat(baiapp);
                        baiapp = formatNumber.toFixed(2);
                    }
                    var rarmodel = ret.rarmodel;
                    if (rarmodel !== undefined && rarmodel !== '' && rarmodel !== null) {
                        formatNumber = parseFloat(rarmodel);
                        rarmodel = formatNumber.toFixed(2);
                    }
                    var rarreq = ret.rarreq;
                    if (rarreq !== undefined && rarreq !== '' && rarreq !== null) {
                        formatNumber = parseFloat(rarreq);
                        rarreq = formatNumber.toFixed(2);
                    }
                    var rarapp = ret.rarapp;
                    if (rarapp !== undefined && rarapp !== '' && rarapp !== null) {
                        formatNumber = parseFloat(rarapp);
                        rarapp = formatNumber.toFixed(2);
                    }
                    var raPE = ret.PE;
                    if (raPE !== undefined && raPE !== '' && raPE !== null) {
                        formatNumber = parseFloat(raPE);
                        raPE = formatNumber.toFixed(2);
                    }
                    var raCE = ret.CE;
                    if (raCE !== undefined && raCE !== '' && raCE !== null) {
                        formatNumber = parseFloat(raCE);
                        raCE = formatNumber.toFixed(2);
                    }
                    var raCR = ret.CR;
                    if (raCR !== undefined && raCR !== '' && raCR !== null) {
                        formatNumber = parseFloat(raCR);
                        raCR = formatNumber.toFixed(2);
                    }
                    /*2 new fields*/
                    var DI_FC = ret.DI_FC;
                    if (DI_FC !== undefined && DI_FC !== '' && DI_FC !== null) {
                        formatNumber = parseFloat(DI_FC);
                        DI_FC = formatNumber.toFixed(2);
                    }
                    var SPREAD = ret.SPREAD;
                    if (SPREAD !== undefined && SPREAD !== '' && SPREAD !== null) {
                        formatNumber = parseFloat(SPREAD);
                        SPREAD = formatNumber.toFixed(2);
                    }
                    cmp.set('v.StringSPREAD', SPREAD);
                    cmp.set('v.StringDI_FC', DI_FC);
                    cmp.set('v.StringPE', raPE);
                    cmp.set('v.StringCE', raCE);
                    cmp.set('v.StringCR', raCR);
                    cmp.set('v.data', [
                        {
                            id: 'TEA',
                            empty: 'TEA (%)',
                            MIN: teaminim,
                            MODEL: teamodel,
                            REQU: teareq,
                            AUTH: teaapp
                        },
                        {
                            id: 'DI',
                            empty: 'DI (%)',
                            MIN: null,
                            MODEL: DI,
                            REQU: DI,
                            AUTH: DI
                        },
                        {
                            id: 'SPREAD',
                            empty: 'SPREAD (%)',
                            MIN: null,
                            MODEL: spreadmodel,
                            REQU: spreadreq,
                            AUTH: spreadapp
                        },
                        {
                            id: 'BAI',
                            empty: 'BAI (%)',
                            MIN: baiminim,
                            MODEL: baimodel,
                            REQU: baireq,
                            AUTH: baiapp
                        },
                        {
                            id: 'RAR',
                            empty: 'RAR (%)',
                            MIN: null,
                            MODEL: rarmodel,
                            REQU: rarreq,
                            AUTH: rarapp
                        }
                    ]);
                }
                cmp.set('v.teainput', ret.proposed);
                cmp.set('v.spreadinput', spreadreq);
                cmp.set('v.validityDate', ret.validityDate);
                cmp.set('v.changeDate', false);
            }
        });
        $A.enqueueAction(action);
    },
    calculatebutton: function (cmp, helper, event) {
        cmp.set('v.isLoad', false);
        var action = cmp.get("c.calculate");
        var recordId = cmp.get('v.recordId');
        var inputtea = cmp.get('v.teainput');
        action.setParams({
            'oppId': recordId,
            'tea': inputtea
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                cmp.set('v.isLoad', true);
                var ret = response.getReturnValue();
                var body = ret.body;
                var strjson = JSON.parse(body);
                var state = ret.state;
                var generr = ret.errormessage;
                if (state == 200) { // Yulino 13/12/2018 : Se agreg =
                    var datalst = cmp.get('v.data');
                    var spreadReq;
                    var baiReq;
                    var rarReq;
                    var adjTea;
                    if (strjson.data != null && strjson.data.liquidityIndicators != null) {
                        var liquidity = strjson.data.liquidityIndicators;
                        for (var x in liquidity) {
                            if (liquidity[x].id == 'LIQUIDITY_MARGIN_BASED_ON_REQUESTED_TEA') {
                                spreadReq = (liquidity[x].detail.percentage);
                            }
                            if (liquidity[x].id == 'BENEFIT_BEFORE_TAX') {
                                baiReq = (liquidity[x].detail.percentage);
                            }
                        }
                    }
                    if (strjson.data != null && strjson.data.financialIndicators != null) {
                        var financial = strjson.data.financialIndicators;
                        for (var y in financial) {
                            if (financial[y].id == 'RAR') {
                                rarReq = (financial[y].value);
                            }
                        }
                    }
                    adjTea = cmp.get('v.teainput');
                    var formatNumber;
                    if (adjTea !== undefined && adjTea !== '' && adjTea !== null) {
                        formatNumber = parseFloat(adjTea);
                        adjTea = formatNumber.toFixed(2);
                    }
                    if (rarReq !== undefined && rarReq !== '' && rarReq !== null) {
                        formatNumber = parseFloat(rarReq);
                        formatNumber = formatNumber * 100;
                        rarReq = formatNumber.toFixed(2);
                    }
                    if (baiReq !== undefined && baiReq !== '' && baiReq !== null) {
                        formatNumber = parseFloat(baiReq);
                        formatNumber = formatNumber * 100;
                        baiReq = formatNumber.toFixed(2);
                    }
                    if (spreadReq !== undefined && spreadReq !== '' && spreadReq !== null) {
                        formatNumber = parseFloat(spreadReq);
                        formatNumber = formatNumber * 100;
                        spreadReq = formatNumber.toFixed(2);
                    }
                    for (var i in datalst) {
                        switch (datalst[i].id) {
                            case 'SPREAD':
                                datalst[i].AUTH = spreadReq;
                                break;
                            case 'BAI':
                                datalst[i].AUTH = baiReq;
                                break;
                            case 'RAR':
                                datalst[i].AUTH = rarReq;
                                break;
                            case 'TEA':
                                datalst[i].AUTH = adjTea;
                                break;
                        }
                    }
                    cmp.set("v.StringSPREAD", ret.SPREAD);
                    cmp.set('v.data', datalst);
                    cmp.set('v.spreadinput', spreadReq);
                } else {
                    cmp.set('v.checkError', true);
                    cmp.set('v.strErrorMessage', generr);
                }
            }
        });
        $A.enqueueAction(action);
    }
})
