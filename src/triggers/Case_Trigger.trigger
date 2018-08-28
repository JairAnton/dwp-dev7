/*
*Modificcacion: Se agrega La metodologia Kevin Hohara 
* 
* 
*/
trigger Case_Trigger on Case (after update, after insert,before Update, Before Insert) {
    new Case_Handler().run();
}