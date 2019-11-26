/**
* ------------------------------------------------------------------------------------------------
* @Name Sharing_VisitTeam_User_cls
* @Author Diego Carbajal diego.carbajal@bbva.com
* @Date Created: 2019-11-20
* @Group 
* @Description Clase que permite compartir registros de visitas a través del Process Builder "Visit Management Team Sharing"
*/
global without sharing class Sharing_VisitTeam_User_cls {

    /*Constructor Method*/
    private Sharing_VisitTeam_User_cls() {}
    
    /**
     * Metodo Invocado desde el Process Builder "Visit Management Team Sharing", aplicando los filtros de dicho process builder
     * */
    @InvocableMethod
    public static void sharingVisitTeamMember(List<WrapperVMT> lstVMT) {
        Final List<dwp_kitv__Visit__Share> lstVisitShare = new List<dwp_kitv__Visit__Share>();
        for(WrapperVMT tmp:lstVMT) {
            lstVisitShare.add(new dwp_kitv__Visit__Share(ParentId = tmp.visitId, UserOrGroupId  = tmp.userId, AccessLevel = 'Edit', RowCause = 'Manual'));
        }
        Final Integer visitShareSize = lstVisitShare.size();
        if(visitShareSize > 0) {insert lstVisitShare;}
    }
	
    /*Global class for parameters in process builder*/
    global class WrapperVMT {
        @InvocableVariable(required=true)
		/*Variable Id visit*/
        public Id visitId;//NOSONAR
        @InvocableVariable(required=true)
        /*Variable Id User*/
        public Id userId;//NOSONAR
    }
    
}