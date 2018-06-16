/*
@Autor: Arsenio Perez Lopez
@Proyect: BBVA PERU
@Version:1
@HIstorial de cambios:
- Creacion del Desencadenador
*/
trigger OpportunityLineT on OpportunityLineItem (Before Insert) {
    new PE_OpportunityLITTriggerHandler().run();
}