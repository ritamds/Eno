<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" xmlns:eno="http://xml.insee.fr/apps/eno"
    xmlns:g="ddi:group:3_2" xmlns:d="ddi:datacollection:3_2" xmlns:s="ddi:studyunit:3_2"
    xmlns:r="ddi:reusable:3_2" xmlns:xhtml="http://www.w3.org/1999/xhtml"
    xmlns:a="ddi:archive:3_2" xmlns:l="ddi:logicalproduct:3_2"
    xmlns:enoddi32="http://xml.insee.fr/apps/eno/out/ddi32" exclude-result-prefixes="xs"
    version="2.0">


    <xd:doc>
        <xd:desc>
            <xd:p>The highest driver, which starts the generation of the xforms.</xd:p>
            <xd:p>It writes codes on different levels for a same driver by adding an element to the
                virtuel tree :</xd:p>
            <xd:p>- Instance : to write the main instance</xd:p>
            <xd:p>- Bind : to writes the binds associated to the elements of the instance</xd:p>
            <xd:p>- Resource : an instance which stores the externalized texts used in the body part
                (xforms labels, hints, helps, alerts)</xd:p>
            <xd:p>- ResourceBind : to write the few binds of the elements of the resource instance
                which are calculated</xd:p>
            <xd:p>- Body : to write the fields</xd:p>
            <xd:p>- Model : to write model elements of the instance which could be potentially added
                by the user in the instance</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template match="Form" mode="model">
        <xsl:param name="source-context" as="item()" tunnel="yes"/>
        <xsl:variable name="citation" select="enoddi32:get-citation($source-context)" as="xs:string"/>
        <xsl:variable name="agency" select="enoddi32:get-agency($source-context)" as="xs:string"/>
        <DDIInstance xmlns="ddi:instance:3_2" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xmlns:g="ddi:group:3_2" xmlns:d="ddi:datacollection:3_2" xmlns:s="ddi:studyunit:3_2"
            xmlns:r="ddi:reusable:3_2" xmlns:xhtml="http://www.w3.org/1999/xhtml"
            xmlns:a="ddi:archive:3_2" xmlns:l="ddi:logicalproduct:3_2"
            xmlns:xs="http://www.w3.org/2001/XMLSchema"
            xsi:schemaLocation="ddi:instance:3_2 ../../../schema/instance.xsd" isMaintainable="true">
            <r:Agency>
                <xsl:value-of select="$agency"/>
            </r:Agency>
            <r:ID>
                <xsl:value-of select="concat('INSEE-',enoddi32:get-id($source-context))"/>
            </r:ID>
            <r:Version>0.1.0</r:Version>
            <r:Citation>
                <r:Title>
                    <r:String>
                        <xsl:value-of select="$citation"/>
                    </r:String>
                </r:Title>
            </r:Citation>
            <g:ResourcePackage isMaintainable="true" versionDate="${current-date()}">
                <r:Agency><xsl:value-of select="$agency"/></r:Agency>
                <r:ID>A définir</r:ID>
                <r:Version>0.1.0</r:Version>
                <d:InterviewerInstructionScheme>
                    <r:Agency><xsl:value-of select="$agency"/></r:Agency>
                    <r:ID>A définir</r:ID>
                    <r:Version>0.1.0</r:Version>
                    <r:Label>
                        <r:Content xml:lang="en-IE">A définir</r:Content>
                    </r:Label>
                    <xsl:apply-templates select="eno:child-fields($source-context)"
                        mode="source">
                        <xsl:with-param name="driver"
                            select="eno:append-empty-element('IIS', .)" tunnel="yes"/>
                        <xsl:with-param name="agency" select="$agency" as="xs:string" tunnel="yes"/>
                    </xsl:apply-templates>
                </d:InterviewerInstructionScheme>

                <d:ControlConstructScheme>
                    <r:Agency>fr.insee</r:Agency>
                    <r:ID>INSEE-SIMPSONS-CCS</r:ID>
                    <r:Version>0.1.0</r:Version>
                </d:ControlConstructScheme>
                <d:QuestionScheme>
                    <r:Agency>fr.insee</r:Agency>
                    <r:ID>INSEE-SIMPSONS-QS</r:ID>
                    <r:Version>0.1.0</r:Version>
                    <r:Label>
                        <r:Content xml:lang="en-IE">QuestionScheme for the Simpsons
                            questionnaire</r:Content>
                    </r:Label>
                </d:QuestionScheme>
                <l:CategoryScheme>
                    <r:Agency>
                        <xsl:value-of select="enoddi32:get-agency($source-context)"/>
                    </r:Agency>
                    <r:ID>INSEE-SIMPSONS-CAS-CL_TOWN</r:ID>
                    <r:Version>0.1.0</r:Version>
                    <r:Label>
                        <r:Content xml:lang="en-IE">CL_TOWN</r:Content>
                    </r:Label>
                </l:CategoryScheme>
                <l:CodeListScheme>
                    <r:Agency>fr.insee</r:Agency>
                    <r:ID>INSEE-SIMPSONS-CLS</r:ID>
                    <r:Version>0.1.0</r:Version>
                    <r:Label>
                        <r:Content xml:lang="en-IE">Codelists for the survey</r:Content>
                    </r:Label>
                    <xsl:apply-templates select="eno:child-fields($source-context)"
                        mode="source">
                        <xsl:with-param name="driver"
                            select="eno:append-empty-element('CLS', .)" tunnel="yes"/>
                        <xsl:with-param name="agency" select="$agency" as="xs:string" tunnel="yes"/>
                    </xsl:apply-templates>                   
                </l:CodeListScheme>
                <l:VariableScheme>
                    <r:Agency>fr.insee</r:Agency>
                    <r:ID>INSEE-SIMPSONS-VS</r:ID>
                    <r:Version>0.1.0</r:Version>
                    <r:Label>
                        <r:Content xml:lang="en-IE">Variable Scheme for the survey</r:Content>
                    </r:Label>
                </l:VariableScheme>
            </g:ResourcePackage>
            <s:StudyUnit xmlns="ddi:studyunit:3_2">
                <r:Agency>fr.insee</r:Agency>
                <r:ID>INSEE-SIMPSONS-SU</r:ID>
                <r:Version>0.1.0</r:Version>
                <r:ExPostEvaluation/>
                <d:DataCollection>
                    <r:Agency>fr.insee</r:Agency>
                    <r:ID>INSEE-SIMPSONS-DC</r:ID>
                    <r:Version>0.1.0</r:Version>
                    <r:QuestionSchemeReference>
                        <r:Agency>fr.insee</r:Agency>
                        <r:ID>INSEE-SIMPSONS-QS</r:ID>
                        <r:Version>0.1.0</r:Version>
                        <r:TypeOfObject>QuestionScheme</r:TypeOfObject>
                    </r:QuestionSchemeReference>
                    <r:ControlConstructSchemeReference>
                        <r:Agency>fr.insee</r:Agency>
                        <r:ID>INSEE-SIMPSONS-CCS</r:ID>
                        <r:Version>0.1.0</r:Version>
                        <r:TypeOfObject>ControlConstructScheme</r:TypeOfObject>
                    </r:ControlConstructSchemeReference>
                    <r:InterviewerInstructionSchemeReference>
                        <r:Agency>fr.insee</r:Agency>
                        <r:ID>INSEE-SIMPSONS-IIS</r:ID>
                        <r:Version>0.1.0</r:Version>
                        <r:TypeOfObject>InterviewerInstructionScheme</r:TypeOfObject>
                    </r:InterviewerInstructionSchemeReference>
                    <d:InstrumentScheme xml:lang="fr-FR">
                        <r:Agency>fr.insee</r:Agency>
                        <r:ID>INSEE-SIMPSONS-InS</r:ID>
                        <r:Version>0.1.0</r:Version>
                        <d:Instrument xmlns:pogues="http://xml.insee.fr/schema/applis/pogues"
                            xmlns:pr="ddi:ddiprofile:3_2" xmlns:c="ddi:conceptualcomponent:3_2"
                            xmlns:cm="ddi:comparative:3_2">
                            <r:Agency>fr.insee</r:Agency>
                            <r:ID>v1</r:ID>
                            <r:Version>0.1.0</r:Version>
                            <r:Label>
                                <r:Content xml:lang="fr-FR">Simpsons questionnaire</r:Content>
                            </r:Label>
                            <d:TypeOfInstrument>DDI XFORMS</d:TypeOfInstrument>
                            <d:ControlConstructReference>
                                <r:Agency>fr.insee</r:Agency>
                                <r:ID>INSEE-SIMPSONS-SEQ</r:ID>
                                <r:Version>0.1.0</r:Version>
                                <r:TypeOfObject>Sequence</r:TypeOfObject>
                            </d:ControlConstructReference>
                        </d:Instrument>
                    </d:InstrumentScheme>
                </d:DataCollection>
            </s:StudyUnit>
        </DDIInstance>
    </xsl:template>

    
    <xsl:template match="IIS//*" mode="model" priority="-1"/>
    
    <xsl:template match="IIS//Instruction" mode="model">
        <xsl:param name="source-context" as="item()" tunnel="yes"/>
        <xsl:param name="agency" as="xs:string" tunnel="yes"/>
        <d:Instruction>
            <r:Agency><xsl:value-of select="$agency"/></r:Agency>
            <r:ID>A définir</r:ID>
            <r:Version>0.1.0</r:Version>
            <d:InstructionName>
                <r:String xml:lang="en-IE"><xsl:value-of select="enoddi32:get-name($source-context)"/></r:String>
            </d:InstructionName>
            <d:InstructionText>
                <d:LiteralText>
                    <d:Text xml:lang="en-IE"><xsl:value-of select="enoddi32:get-text($source-context)"/></d:Text>
                </d:LiteralText>
            </d:InstructionText>
        </d:Instruction>    
    </xsl:template>

    <xsl:template match="CLS//*" mode="model" priority="-1"/>
                
    <xsl:template match="CLS//CodeList" mode="model">
        <xsl:param name="source-context" as="item()" tunnel="yes"/>
        <xsl:param name="agency" as="xs:string" tunnel="yes"/>
            <l:CodeList>
                <r:Agency><xsl:value-of select="$agency"/></r:Agency>
                <r:ID>A définir.</r:ID>
                <r:Version>0.1.0</r:Version>
                <r:Label>
                    <r:Content xml:lang="en-IE"><xsl:value-of select="enoddi32:get-label($source-context)"/></r:Content>
                </r:Label>
                <l:HierarchyType>A définir</l:HierarchyType>
                <l:Level levelNumber="TODO">
                    <l:CategoryRelationship>A définir</l:CategoryRelationship>
                </l:Level>
                <xsl:apply-templates select="eno:child-fields($source-context)"
                    mode="source">
                    <xsl:with-param name="driver"
                        select="." tunnel="yes"/>                    
                </xsl:apply-templates>  
            </l:CodeList>
    </xsl:template>

    <xsl:template match="CLS//Code" mode="model">
        <xsl:param name="source-context" as="item()" tunnel="yes"/>
        <xsl:param name="agency" as="xs:string" tunnel="yes"/>
        <l:Code levelNumber="TODO" isDiscrete="TODO">
            <r:Agency><xsl:value-of select="$agency"/></r:Agency>
            <r:ID>A définir</r:ID>
            <r:Version>0.1.0</r:Version>
            <r:CategoryReference>
                <r:Agency>fr.insee</r:Agency>
                <r:ID>A définir</r:ID>
                <r:Version>0.1.0</r:Version>
                <r:TypeOfObject>Category</r:TypeOfObject>
            </r:CategoryReference>
            <r:Value><xsl:value-of select="enoddi32:get-value($source-context)"/></r:Value>
        </l:Code>
    </xsl:template>
</xsl:stylesheet>