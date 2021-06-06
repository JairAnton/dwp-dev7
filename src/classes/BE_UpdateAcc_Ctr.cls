/**
   ----------------------------------------------------------------------------------------------------
   @Name <BE_General_Utils>
   @Author Lolo Michel Eduardo Vargas (luis.eduardo.vargas.contractor@bbva.com)
   @Date 2019-09-13
   @Description Class  contains generic logic to use in differents classes.
   @Changes
    Date        Author   Email                                      Type
    2020-02-21  LMBR     luis.eduardo.vargas.contractor@bbva.com    Creation
   ----------------------------------------------------------------------------------------------------
 */
public without sharing class BE_UpdateAcc_Ctr extends BE_CustomQuickActionCRUD_Cls{
    
    /* comment */
    public override BE_CustomQuickActionCRUD_Cls.Response updateRecord(SObject sObj,Map<String,Object> params) {
        Final BE_CustomQuickActionCRUD_Cls.Response res = new BE_CustomQuickActionCRUD_Cls.Response();

        try {
            update sObj;
            res.isSuccess=true;
            res.data=sObj;
        } catch(DmlException ex) {
            res.message=ex.getMessage();
        }
        
        return res;
    }
}