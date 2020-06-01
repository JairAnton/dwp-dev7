/**
 * @Name     BE_OppsCommercialActivity_Cls
 * @Author   Antony de la rosa guzman.
 * @Date     2019-11-13
 * @Group    DWP Perú
 * @Description Creación de la clase controladora para el componente lightning
 *              BE_OppsCommercialActivity_Cmp. Funciona obteniendo los datos del cliente para mostrarlos en el cintillo.
 *              *Clase de pruebas BE_OppsCommercialActivity_Test.
 * @Changes
            - Actualización getOppInfo se cambio el filtro de fecha de CreatedDate por CloseDate
 *****************************
            Modificaciones:
            Martín Alejandro Mori Chávez  2020-02-25
 */
public with sharing class BE_OppsCommercialActivity_Cls {
	/*
	 * Attribute
	 */
	private static final String STAGE06 = '06';
	/*
	 * Attribute
	 */
	private static final String STAGE07 = '07';

    /*
    * @Description Constructor de la clase
    * @Author Antony de la rosa guzman.
    * @Date 2019-11-13
    * @example BE_DetailRowBusiness_Cls example = new BE_DetailRowBusiness_Cls();
    **/
	@testVisible private BE_OppsCommercialActivity_Cls() {
	}

    /*
    * @Description funcion que retorna la lista con la informacion para el cintillo Oportunidades.
    * @Author Antony de la rosa guzman.
    * @Date 2019-11-13
    * @example Account example = getOppInfo(9098098);
    **/
	@auraEnabled
	public static String getOppInfo(String accId) {
		Decimal sumWon = 0;
		Integer sizeWon = 0;
		Decimal sumLost = 0;
		Integer sizeLost = 0;
		Decimal sumLive = 0;
		Integer sizeLive = 0;
		Integer numOpp = 0;
		final String oppType = '';
		final List<wrapperClass> lWrapClassAux = new List<wrapperClass>();
		final List<Opportunity> oppDenormList = [SELECT Id, Amount, StageName FROM Opportunity WHERE AccountId =: accId AND CloseDate = THIS_YEAR AND StageName IN('06', '07')];
		if(!oppDenormList.isEmpty()) {
			for(Opportunity i : oppDenormList) {
				if(i.StageName == STAGE06) {
					sumWon = sumWon + (i.Amount == null ? 0 : i.Amount);
					sizeWon = sizeWon + 1;
				} else if(i.StageName == STAGE07) {
					sumLost = sumLost + (i.Amount == null ? 0 : i.Amount);
					sizeLost = sizeLost + 1;
				} else {
					sumLive = sumLive + (i.Amount == null ? 0 : i.Amount);
					sizeLive = sizeLive + 1;
				}
			}
			numOpp = oppDenormList.size();
		}
		lWrapClassAux.add(new wrapperClass(numOpp, sumWon, sumLost, sizeWon, sizeLost, oppType, sizeLive, sumLive));
		return JSON.serialize(lWrapClassAux);
	}
    
	/*
	 * wrapperClass
	 */
	public class wrapperClass {
		/*
		 * Attribute
		 */
		private Integer returnTotalOpp; //NOSONAR
		/*
		 * Attribute
		 */
		private String returnWon; //NOSONAR
		/*
		 * Attribute
		 */
		private String returnLost; //NOSONAR
		/*
		 * Attribute
		 */
		private String returnCurrencyCode; //NOSONAR
		/*
		 * Attribute
		 */
		private Integer oppWonNumber; //NOSONAR
		/*
		 * Attribute
		 */
		private Integer oppLostNumber; //NOSONAR
		/*
		 * Attribute
		 */
		private String oppType; //NOSONAR
		/*
		 * Attribute
		 */
		private String hitMiss; //NOSONAR
		/*
		 * Attribute
		 */
		private Integer oppLiveNumber; //NOSONAR
		/*
		 * Attribute
		 */
		private String returnLive; //NOSONAR

		/**
		 * @author Global Desktop
		 * @description Contruye la lista wrapper
		 */
		public wrapperClass(Integer totalOpp, Decimal won, Decimal lost, Integer sizeOppWon, Integer sizeOppLost, String oppType, Integer sizeOppLive, Decimal live) {
			this.returnTotalOpp = totalOpp;

			final List<String> args = new String[] {'0', 'number', '###.###.##0,00'};
			final String sWonFormat = Dwp_Utils_helper.formatAmount(won, 'PEN');
			this.returnWon = sWonFormat;

			final Decimal lostFormat = lost.setScale(2);
			final String sLostFormat =  Dwp_Utils_helper.formatAmount(lostFormat, 'PEN');
			this.returnLost = sLostFormat;

			final Decimal liveFormat = live.setScale(2);
			final String sLiveFormat = String.format(liveFormat.format(), args);
			this.returnLive = sLiveFormat;

			this.returnCurrencyCode = UserInfo.getDefaultCurrency();
			this.oppWonNumber = sizeOppWon;
			this.oppLostNumber = sizeOppLost;
			this.oppLiveNumber = sizeOppLive;
			this.oppType = oppType;
			Decimal value = 0;
			if(oppWonNumber > 0) {
				value = (oppWonNumber * 100.0) / (oppWonNumber + oppLostNumber);
			}
			final Decimal hitMissFormat = value.setScale(2);
			final String sHitMissFormat = String.format(hitMissFormat.format(), args);
			this.hitMiss = sHitMissFormat;
		}
	}
}
