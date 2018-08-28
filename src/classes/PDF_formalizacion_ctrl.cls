/**PDF_formalizacion_ctrl
*  object.
* <p /><p />
* Modification log:<p />
* -------------------------------------------------------------------
* Developer                    Date                Description<p />
* -------------------------------------------------------------------
* Julio Medellin               18/05/2018          Original version.<p />
*
* @author Julio Medellin
*/
public virtual  class PDF_formalizacion_ctrl extends OpportunityPDFWrap   {

    public  PDF_formalizacion_ctrl(ApexPages.StandardController controller){
       setValues(controller.getId());
    }

     public static string msg(string Id){
      return setValues(Id);
    }

}
