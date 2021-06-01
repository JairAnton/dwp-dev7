/**
   -------------------------------------------------------------------------------------------------
   @Name BE_SM_ProductQVC_Cls
   @Author Gerson R. Díaz Alvarado (gerson.diaz@bbva.com)
   @Date 2021-06-01
   @Description
   @Changes
   Date        Author   Email                  				Type
   2021-06-01  GDIAZ    gerson.diaz@bbva.com    			Creation
   -------------------------------------------------------------------------------------------------
 */
global without sharing class BE_SM_ProductQVC_Cls implements slmt.Sales_Meeting_Item_Details_Itf {
    /*
	 * @Description method getCardDetails
	 */
    public List<Map<String,String>> getCardDetails(sObject contextRecord, String cardId) {
        Final List<Map<String,String>> lstReturn = new List<Map<String,String>>();
        lstReturn.add(createItem(new List<String>{'', 'Competitividad', '08', cardId}));
        lstReturn.add(createItem(new List<String>{'', ' ', '06', cardId}));
        lstReturn.add(createItem(new List<String>{'', ' ', '06', cardId}));
        lstReturn.add(createItem(new List<String>{'', ' ', '06', cardId}));
        lstReturn.add(createItem(new List<String>{'', ' ', '06', cardId}));
        lstReturn.add(createItem(new List<String>{'', ' ', '06', cardId}));
        return lstReturn;
    }
    
    
    /*
	 * @Description method createItem
	 */
    private Map<String,String> createItem(List<String> ltsObj) {
        Final Map<String,String> item = new Map<String,String>();
        item.put('value',ltsObj[1]);
        item.put('type',ltsObj[2]);
        item.put('format','###,###,##0');
        item.put('icon','NOTHING');
        //item.put('icon','/resource/BBVALogo');
        item.put('typeIcon','NOTHING');
        item.put('idRecord',ltsObj[3]);
        item.put('isSubtitle','true');
        if(String.isNotBlank(ltsObj[0])) {
            item.put('label',ltsObj[0]);
            item.put('isSubtitle','false');
        }
        return item;
    }
}