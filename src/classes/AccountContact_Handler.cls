/**
 * Handler of Trigger of the AccountContactRelation object.
 * <p /><p />
 * Modification log:<p />
 * -------------------------------------------------------------------
 * Developer                    Date                Description<p />
 * -------------------------------------------------------------------
 * Julio Medellin               22/02/2018          Original version.<p />
 * Alberto Gómez                27/02/2018          Added updateValuesRelationInContact method.<p />
 *
 * @author Julio Medellin
 */
public class AccountContact_Handler {

    /**
     * Method for set values in AccountContactRelation records.
     *
     * @param lstAccountContactRelation Account Contact Relation List.
     */
    public static void setValuesRelation(List<AccountContactRelation> lstAccountContactRelation) {
      
     AccountContactParentAssociation.setValuesRelation(lstAccountContactRelation);
      
    }

    /**
     * Method for update Contact values according to AccountContactRelation updates.
     *
     * @param lstAccountContactRelation Account Contact Relation List.
     */
    public static void updateValuesRelationInContact(List<AccountContactRelation> lstAccountContactRelation) {
      AccountContactParentAssociation.updateValuesRelationInContact(lstAccountContactRelation);  
    }
}