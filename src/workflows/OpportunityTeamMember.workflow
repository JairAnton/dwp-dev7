<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>BE_OpportunityTeam_EA</fullName>
        <description>Email notification when a user is added to opportunity team</description>
        <protected>false</protected>
        <recipients>
            <field>UserId</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/OpportunityTeam_Notification_VF</template>
    </alerts>
</Workflow>
