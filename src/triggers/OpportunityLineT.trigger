/*
@Autor: Arsenio Perez Lopez
@Proyect: BBVA PERU
@Version:1
@HIstorial de cambios:
- Creacion del Desencadenador
*/
trigger OpportunityLineT on OpportunityLineItem (Before Insert,After Insert,After Update) {
    new PE_OpportunityLITTriggerHandler().run();
}