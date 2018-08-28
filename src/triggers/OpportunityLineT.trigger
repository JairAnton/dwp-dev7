/*
@Autor: Arsenio Perez Lopez
@Proyect: BBVA PERU
@Version:1
@HIstorial de cambios:
- Creacion del Desencadenador
- Add After Delete
*/
trigger OpportunityLineT on OpportunityLineItem (Before Insert, Before Update,After Insert,After Update, After Delete) {
    new PE_OpportunityLITTriggerHandler().run();
}