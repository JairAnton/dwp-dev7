({
    init : function(cmp, helper, event) {
        var action = cmp.get("c.getInfo");
        var recordId = cmp.get('v.recordId');
        action.setParams({
            'oppId' : recordId
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var ret = response.getReturnValue();
                var generr = ret.errormessage;
                
                if(generr != undefined){
                    cmp.set('v.strErrorMessage',generr);
                    cmp.set('v.isLoad',true);
                    cmp.set('v.checkError',true);                    
                }else{
                    cmp.set('v.isLoad',true);
                    cmp.set('v.headers',[
                        { label: '', fieldName: 'empty', type: 'text'},
                        { label: ret.headers[0], fieldName: 'MIN', type: 'number',alignment: 'center', cellAttributes: { alignment: 'center' }},
                        { label: ret.headers[1], fieldName: 'MODEL', type: 'number',alignment: 'center', cellAttributes: { alignment: 'center' }},
                        { label: ret.headers[2], fieldName: 'REQU', type: 'number',alignment: 'center', cellAttributes: { alignment: 'center' }},
                        { label: ret.headers[3], fieldName: 'AUTH', type: 'number',alignment: 'center', cellAttributes: { alignment: 'center' }}                    
                    ]);
                    var teaminim = ret.teaminim;
                    if(teaminim != undefined && teaminim != ''){
                        var formatNumber = parseFloat(teaminim);
                        teaminim = formatNumber.toFixed(2);                        
                    }
                    var teamodel = ret.teamodel;
                    if(teamodel != undefined && teamodel != ''){
                        var formatNumber = parseFloat(teamodel);
                        teamodel = formatNumber.toFixed(2);                        
                    }
                    var teareq = ret.teareq;
                    if(teareq != undefined && teareq != ''){
                        var formatNumber = parseFloat(teareq);
                        teareq = formatNumber.toFixed(2);                        
                    }
                    var teaapp = ret.teaapp;
                    if(teaapp != undefined && teaapp != ''){
                        var formatNumber = parseFloat(teaapp);
                        teaapp = formatNumber.toFixed(2);                        
                    }
                    var DI = ret.DI;
                    if(DI != undefined && DI != ''){
                        var formatNumber = parseFloat(DI);
                        DI = formatNumber.toFixed(2);                        
                    }
                    var spreadmodel = ret.spreadmodel;
                    if(spreadmodel != undefined && spreadmodel != ''){
                        var formatNumber = parseFloat(spreadmodel);
                        spreadmodel = formatNumber.toFixed(2);                        
                    }
                    var spreadreq = ret.spreadreq;
                    if(spreadreq != undefined && spreadreq != ''){
                        var formatNumber = parseFloat(spreadreq);
                        spreadreq = formatNumber.toFixed(2);                        
                    }
                    var spreadapp = ret.spreadapp;
                    if(spreadapp != undefined && spreadapp != ''){
                        var formatNumber = parseFloat(spreadapp);
                        spreadapp = formatNumber.toFixed(2);                        
                    }
                    var baiminim = ret.baiminim;
                    if(baiminim != undefined && baiminim != ''){
                        var formatNumber = parseFloat(baiminim);
                        baiminim = formatNumber.toFixed(2);                        
                    }
                    var baimodel = ret.baimodel;
                    if(baimodel != undefined && baimodel != ''){
                        var formatNumber = parseFloat(baimodel);
                        baimodel = formatNumber.toFixed(2);                        
                    }
                    var baireq = ret.baireq;
                    if(baireq != undefined && baireq != ''){
                        var formatNumber = parseFloat(baireq);
                        baireq = formatNumber.toFixed(2);                        
                    }
                    var baiapp = ret.baiapp;
                    if(baiapp != undefined && baiapp != ''){
                        var formatNumber = parseFloat(baiapp);
                        baiapp = formatNumber.toFixed(2);                        
                    }
                    var rarmodel = ret.rarmodel;
                    if(rarmodel != undefined && rarmodel != ''){
                        var formatNumber = parseFloat(rarmodel);
                        rarmodel = formatNumber.toFixed(2);                        
                    }
                    var rarreq = ret.rarreq;
                    if(rarreq != undefined && rarreq != ''){
                        var formatNumber = parseFloat(rarreq);
                        rarreq = formatNumber.toFixed(2);                        
                    }
                    var rarapp = ret.rarapp;
                    if(rarapp != undefined && rarapp != ''){
                        var formatNumber = parseFloat(rarapp);
                        rarapp = formatNumber.toFixed(2);                        
                    }
                    
                    
                    cmp.set('v.data',[
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
                cmp.set('v.teainput',ret.proposed);
                cmp.set('v.spreadinput',spreadreq);
                
            }
            
        });
        $A.enqueueAction(action);
        
    },
    calculatebutton : function(cmp, helper, event){
        cmp.set('v.isLoad',false);
        var action = cmp.get("c.calculate");
        var recordId = cmp.get('v.recordId');
        var inputtea = cmp.get('v.teainput');
        action.setParams({
            'oppId' : recordId,
            'tea' : inputtea
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                cmp.set('v.isLoad',true);
                var ret = response.getReturnValue();
                var body = ret.body;
                var strjson = JSON.parse(body);
                var state = ret.state;
                if(state = 200){
                    var datalst = cmp.get('v.data');
                    var spreadReq;
                    var baiReq;
                    var rarReq;
                    var adjTea;
                    if(strjson.data != null && strjson.data.liquidityIndicators != null){
                        var liquidity = strjson.data.liquidityIndicators;                        
                        for(var x in liquidity){                                   
                            if(liquidity[x].id == 'LIQUIDITY_MARGIN_BASED_ON_REQUESTED_TEA'){
                                spreadReq = (liquidity[x].detail.percentage);
                            }
                            
                            if(liquidity[x].id == 'BENEFIT_BEFORE_TAX'){
                                baiReq = (liquidity[x].detail.percentage); 
                            }                                                                     
                            
                        }
                    }
                    if(strjson.data != null && strjson.data.financialIndicators != null){                        
                        var financial = strjson.data.financialIndicators;
                        for(var y in financial){
                            if(financial[y].id == 'RAR'){
                                rarReq = (financial[y].value);
                            }
                        }
                    }
                    if(strjson.data != null && strjson.data.interestRates != null && 
                       strjson.data.interestRates.effectiveRates != null){                        
                        var effective = strjson.data.interestRates.effectiveRates;
                        for(var z in effective){
                            if(effective[z].id == 'ADJUSTED_TEA'){
                                adjTea = (effective[y].percentage);
                            }
                        }
                    }
                    if(adjTea != undefined && adjTea != ''){
                        var formatNumber = parseFloat(adjTea);
                        adjTea = formatNumber.toFixed(2);                        
                    }
                    if(rarReq != undefined && rarReq != ''){
                        var formatNumber = parseFloat(rarReq);
                        rarReq = formatNumber.toFixed(2);                        
                    }
                    if(baiReq != undefined && baiReq != ''){
                        var formatNumber = parseFloat(baiReq);
                        baiReq = formatNumber.toFixed(2);                        
                    }
                    if(spreadReq != undefined && spreadReq != ''){
                        var formatNumber = parseFloat(spreadReq);
                        spreadReq = formatNumber.toFixed(2);                        
                    }
                    
                    for(var i in datalst){
                        switch (datalst[i].id){
                            case 'SPREAD':
                                datalst[i].REQU = '';
                                datalst[i].AUTH = spreadReq;
                                break;
                            case 'BAI':
                                datalst[i].REQU = '';
                                datalst[i].AUTH = baiReq;
                                break;
                            case 'RAR':
                                datalst[i].REQU = '';
                                datalst[i].AUTH = rarReq;
                                break;
                            case 'TEA':
                                datalst[i].AUTH = adjTea;
                                break;
                        }
                    }                   
                    cmp.set('v.data',datalst);
                    cmp.set('v.spreadinput',spreadReq);
                }else{
                    cmp.set('v.checkError',true);
                }
            }
        });
        $A.enqueueAction(action);
    }
})