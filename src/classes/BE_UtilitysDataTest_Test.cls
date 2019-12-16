/**
* _________________________________________________________________________________
* @Name     BE_UtilitysDataTest_Test
* @Author   Antony de la rosa guzman.
* @Date     2019-11-11
* @Group    DWP Perú
* @Description Clase para crear los Datos de prueba generales de utilería para ser usados
                en las demas clases de prueba.
* _________________________________________________________________________________
* @Changes
* _________________________________________________________________________________
*/
@isTest
public class BE_UtilitysDataTest_Test {
    /**APINAME of the SObject*/ 
    final static String SOBJNAME='Account_Accounting__c';
    /**@general variable*/ 
    final static String FIELDCODE='gl_account_id__c';
    /**@general variable*/ 
    final static String DATEFIELD='year_month_day_date__c';
    /**@general variable*/ 
    final static String UNIQUECODE='203658756Utils'+Date.today();
    
    static Map<String, Profile> perfilMapa = new Map<String, Profile>();
    static Map<String, UserRole> rolMapa   = new Map<String, UserRole>();
    static List<Profile> lstProfile;
    static List<UserRole> userRole;

    static{
        lstProfile = new List<Profile>([SELECT Id, Name FROM Profile WHERE Name != null]);
        userRole   = new List<UserRole>([SELECT Id, Name FROM UserRole WHERE Name != null]);    
        for(Profile perfil:lstProfile){ perfilMapa.put(perfil.Name, perfil); }
        for(UserRole ur:userRole){ rolMapa.put(ur.Name, ur); }    
    }

    @isTest static void test_method_two() {
        Integer MAX_QUERY = Limits.getLimitQueries(); 
        Integer NUM_QUERY = MAX_QUERY - 1;
        System.assert(Limits.getQueries() < NUM_QUERY, 'numero de querys dentro del rango  permitido');
    }
     
    /**
    * @Method:      crearUsuario
    * @param:       String strLastName, String strProfileName, String strRol
    * @Description: Funcion que retorna un objeto User 
    */
    public static User crearUsuario(String strLastName, String strProfileName, String strRol) {
        String email                  = 'tstBBVA'+Math.random()*10000+'@bbva.test.com';   
        final User usuario                  = new User(); 
        usuario.LastName              = strLastName;
        usuario.Alias                 = String.valueOf((Math.random() * 10000).round());
        usuario.Email                 = email;
        usuario.UserName              = email;
        usuario.EmailEncodingKey      = 'UTF-8';
        usuario.LanguageLocaleKey     = 'en_US';
        usuario.TimeZoneSidKey        = 'America/Lima';
        usuario.LocaleSidKey          = 'en_US';
        usuario.IsActive              = true;
        usuario.ProfileId = userinfo.getProfileId();
        if(String.isNotBlank(strRol)) {usuario.UserRoleId = rolMapa.get(strRol).Id;}
        usuario.CompanyName           = 'DWP Perú';
        return usuario;
    }

    /**
    * @Method:      crearCuenta
    * @param:       String strName
    * @Description: Funcion que retorna un objeto cliente
    */
	public static Account crearCuenta(String strName) {
		final Account cliente          = new Account();
		cliente.Name             = strName;
		cliente.unique_id__c = UNIQUECODE;	
		return cliente;
    }
    
    /**
    * @Method:      crearCuenta Accounting
    * @param:       String strName,Id Acc
    * @Description: Funcion que retorna un objeto Account_Accounting__c
    */
	public static Account_Accounting__c crearAccount_Accouting(String strName,Id idAccount) {
		final Account_Accounting__c accAcc = new Account_Accounting__c();
        accAcc.Name = strName;
        accAcc.account_id__c = idAccount;
        accAcc.gl_account_amount__c=200;
        accAcc.year_month_day_date__c=Date.today()-70;
        accAcc.parent_gl_account_id__c='';
        accAcc.gl_account_id__c='PARENT_TEST';
        accAcc.gl_account_id_path_desc__c='1';
        accAcc.gl_account_path_position_id__c='1';
		return accAcc;
    }
    
    /**
    * @Method:      crearOportunidad
    * @param:       String strName, Id idAccount,  Id idOwner, String strTipoProd
    * @Description: Funcion que retorna un objeto Oportunidad
    */
    public static Opportunity crearOportunidad(String strName, Id idAccount,  Id idOwner, String strTipoProd) {     
        final Opportunity objOpp       = new Opportunity();
        objOpp.Name              = strName;
        objOpp.StageName         = '02';
        objOpp.AccountId         = idAccount;
        objOpp.CloseDate         = Date.today().addDays(15);        
        objOpp.OwnerId           = idOwner;
        return objOpp;
    }
    
    /**
    * @Method:      crearVisitas
    * @param:       String strName, Id idAccount,  Id idOwner, String strTipoVisita
    * @Description: Funcion que retorna un objeto Visita
    */
    public static dwp_kitv__Visit__c crearVisita(String strName, Id idAccount, String strTipoVisita) {     
        final dwp_kitv__Visit__c visit = new dwp_kitv__Visit__c();
        visit.Name=strName;
        visit.dwp_kitv__visit_start_date__c = datetime.newInstance(System.today().year(), System.today().Month(), System.today().day(), 13, 30, 0);
        visit.dwp_kitv__visit_duration_number__c='30';
        visit.dwp_kitv__visit_purpose_type__c=strTipoVisita;
        visit.dwp_kitv__visit_status_type__c='01';
        visit.dwp_kitv__account_id__c=idAccount;
        visit.dwp_kitv__visit_location_desc__c='torre bancomer';
        return visit;
    }
    
    /**
    * @Method:      crearVariation
    * @param:       String strName, Id idAccount
    * @Description: Funcion que retorna un objeto Account_variation_information__c
    */
    public static Account_variation_information__c crearVariation(String strName, Id idAccount,String StrColor) {     
        final Account_variation_information__c Variation = new Account_variation_information__c();
        Variation.indicator_name__c=strName;
        Variation.Account_Id__c=idAccount;
        Variation.validation_color_type__c = StrColor;
        Variation.indicator_update_date__c=Date.today();
        return Variation;
    }
    
     /**
    * @Method:      crtVisitTopic
    * @Description: Crea un registro del tipo dwp_kitv__Visit_Topic__c
    * @param: String tipoRegistro
    */
    public static dwp_kitv__Visit_Topic__c crtVisitTopic(String visita) {
        final dwp_kitv__Visit_Topic__c topic = new dwp_kitv__Visit_Topic__c();
        topic.dwp_kitv__visit_id__c = visita;
        return topic;
    }
    
      /**
    * @Method:      crearContacto
    * @param:       Id idCuenta, String strFirstName, String strLastName,  String devNameTipoRegistro
    * @Description: Funcion que retorna un objeto contacto
    */
	public static Contact crearContacto(Id idCuenta, String strFirstName, String strLastName) {
		final Contact contacto   = new Contact();
		contacto.FirstName = strFirstName;
        contacto.Salutation='Sr.';
		contacto.LastName  = strLastName;
		contacto.Phone     = '(234) 567-8987';
        contacto.MobilePhone = '999999999';
        contacto.decision_making_desc__c ='Si';
        contacto.prof_position_type__c = 'APODERADO';
        contacto.Cargo_inicio__c = 'APODERADO';
		contacto.Email     = 'tstBBVA'+ (Math.random()*10000).round()+'@bbva.test.com';
        if(idCuenta!=null){contacto.AccountId = idCuenta;}
		return contacto;
    }
}