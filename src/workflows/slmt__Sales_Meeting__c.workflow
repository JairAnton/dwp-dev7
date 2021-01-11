<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>BE_SM_SetStartTime_FU</fullName>
        <field>slmt__mngmt_plan_meeting_start_desc__c</field>
        <formula>TIMEVALUE( DateTime__c )</formula>
        <name>Sales Meeting Set StartTime</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SM_Planning_CloseDate_Ejecutivo</fullName>
        <description>La fecha de cierre es sexto día habil del mes.</description>
        <field>CloseDate__c</field>
        <formula>DATETIMEVALUE(DATE(YEAR(DATEVALUE(DateTime__c)), MONTH(DATEVALUE(DateTime__c)), 
CASE(MOD( DATE(YEAR(DATEVALUE(DateTime__c)), MONTH(DATEVALUE(DateTime__c)), 1) - DATE( 1900, 1, 8 ), 7 ),
0, 8,
1, 8,
2, 8,
3, 8,
4, 8,
5, 10,
9)))</formula>
        <name>SM Planning Close Date Ejecutivo</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SM_Planning_and_Tracing_Close_Date_GOF</fullName>
        <description>La fecha de cierre debe ser 2 días habiles despues de la fecha planificada.
0,1,2,6=LMMD=&gt; +2,
3,4=JV=&gt; +4,
5=S=&gt; +3</description>
        <field>CloseDate__c</field>
        <formula>DATETIMEVALUE(
CASE( 
  MOD( DATEVALUE(DateTime__c) - DATE( 1900, 1, 8 ), 7 ),
  3, DATEVALUE(DateTime__c) + 4,
  4, DATEVALUE(DateTime__c) + 4,
  5, DATEVALUE(DateTime__c) + 3,
  DATEVALUE(DateTime__c) + 2
)
)</formula>
        <name>SM Planning and Tracing Close Date GOF</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SM_Tracing_CloseDate_Ejecutivo</fullName>
        <description>La fecha de cierre debe ser el martes futuro mas cercano a la fecha planificada.
0=Lunes=&gt; 1, 
1=Martes=&gt; 0, 
2=Miercoles=&gt; 6, 
3=Jueves=&gt; 5, 
4=Viernes=&gt; 4, 
5=Sabado=&gt; 3, 
Domingo=&gt; 2</description>
        <field>CloseDate__c</field>
        <formula>CASE(
  MOD( DATEVALUE(DateTime__c) - DATE( 1900, 1, 8 ), 7 ),
  0, DateTime__c + 1,
  1, DateTime__c,
  2, DateTime__c + 6,
  3, DateTime__c + 5,
  4, DateTime__c + 4,
  5, DateTime__c + 3, 
  DateTime__c + 2
)</formula>
        <name>SM Tracing Close Date Ejecutivo</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>SM Planning - Determine Close Date - Ejecutivo</fullName>
        <actions>
            <name>SM_Planning_CloseDate_Ejecutivo</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Determina la fecha de cierre para reuniones de tipo &quot;Planificación&quot;, creadas para colaboradores ejecutivos.</description>
        <formula>ISPICKVAL(Type_of_meeting__c, &apos;Planning&apos;) &amp;&amp; 
(Collaborator__r.prof_position_id__c == &apos;E03&apos; || 
Collaborator__r.prof_position_id__c == &apos;I32&apos;) &amp;&amp;
(ISCHANGED(DateTime__c) ||  ISNEW() )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SM Planning and Tracing - Determine Close Date - GOF</fullName>
        <actions>
            <name>SM_Planning_and_Tracing_Close_Date_GOF</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Determina la fecha de cierre para reuniones de tipo &quot;Planificación&quot; o &quot;Seguimiento&quot;, creadas para colaboradores gerentes de oficina.</description>
        <formula>(ISPICKVAL(Type_of_meeting__c, &apos;Planning&apos;) || 
	ISPICKVAL(Type_of_meeting__c, &apos;Tracing&apos;)) &amp;&amp; 
(Collaborator__r.prof_position_id__c == &apos;E01&apos; || 
		Collaborator__r.prof_position_id__c == &apos;I21&apos;) &amp;&amp;
(ISCHANGED(DateTime__c) ||  ISNEW() )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SM Tracing - Determine Close Date - Ejecutivo</fullName>
        <actions>
            <name>SM_Tracing_CloseDate_Ejecutivo</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Determina la fecha de cierre para reuniones de tipo &quot;Seguimiento&quot;, creadas para colaboradores ejecutivos.</description>
        <formula>ISPICKVAL(Type_of_meeting__c, &apos;Tracing&apos;) &amp;&amp; 
(Collaborator__r.prof_position_id__c == &apos;E03&apos; || 
		Collaborator__r.prof_position_id__c == &apos;I32&apos;) &amp;&amp;
(ISCHANGED(DateTime__c) ||  ISNEW() )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Sales meeting set time value</fullName>
        <actions>
            <name>BE_SM_SetStartTime_FU</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>slmt__Sales_Meeting__c.DateTime__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>set the value for the time field</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
