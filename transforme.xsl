<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0" version="1.0">
    <xsl:output method="html" indent="yes" encoding="UTF-8"/>
    
    <!-- Template racine -->
    <xsl:template match="/">
        <html>
            <head>
                <title>
                    <xsl:value-of select="//tei:titleStmt/tei:title"/>
                </title>
            </head>
            <body>
                <!-- Métadonnées -->
                <div class="metadata">
                    <h1 class="title">
                        <xsl:value-of select="//tei:titleStmt/tei:title"/>
                    </h1>
                    <p><strong>Auteur :</strong> <xsl:value-of select="//tei:titleStmt/tei:author"/></p>
                    <p><strong>Date d'édition :</strong> <xsl:value-of select="//tei:editionStmt/tei:edition/tei:date"/></p>
                    <p><strong>Éditeur :</strong> <xsl:value-of select="//tei:publicationStmt/tei:publisher"/></p>
                </div>
                
                <!-- Texte principal -->
                <xsl:apply-templates select="//tei:text"/>
            </body>
        </html>
    </xsl:template>
    
    <!-- Front avec transformation des <head> en <p> -->
    <xsl:template match="tei:front">
        <div class="front">
            <xsl:for-each select="tei:head">
                <p class="front-paragraph">
                    <xsl:value-of select="."/>
                </p>
            </xsl:for-each>
            <xsl:apply-templates select="node()[not(self::tei:head)]"/>
        </div>
    </xsl:template>
    
    <!-- Section principale -->
    <xsl:template match="tei:div1">
        <div class="section" id="{@xml:id}">
            <h2 class="section-title">
                <xsl:value-of select="tei:head"/>
            </h2>
            <xsl:apply-templates select="node()[not(self::tei:head)]"/>
        </div>
    </xsl:template>
    
    <!-- Sous-section -->
    <xsl:template match="tei:div2">
        <div class="subsection" id="{@xml:id}">
            <h3 class="subsection-title">
                <xsl:value-of select="tei:head"/>
            </h3>
            <xsl:apply-templates select="node()[not(self::tei:head)]"/>
        </div>
    </xsl:template>
    
    <!-- Gestion des `floatingText` -->
    <xsl:template match="tei:floatingText">
        <div class="floating-text" id="{@xml:id}" data-type="{@type}">
            <!-- Premier <head> en h4 -->
            <xsl:for-each select="tei:body/tei:div/tei:head">
                <xsl:choose>
                    <xsl:when test="position() = 1">
                        <h4 class="floating-text-title">
                            <xsl:value-of select="."/>
                        </h4>
                    </xsl:when>
                    <xsl:otherwise>
                        <h5 class="floating-text-subtitle">
                            <xsl:value-of select="."/>
                        </h5>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
            <!-- Gestion de @corresp -->
            <xsl:if test="@corresp">
                <div class="linked-text">
                    Lié à :
                    <xsl:for-each select="tokenize(@corresp, ' ')">
                        <a href="{.}" title="Voir le texte correspondant">
                            <xsl:value-of select="substring-after(., '#')"/>
                        </a>
                        <xsl:if test="position() != last()">, </xsl:if>
                    </xsl:for-each>
                </div>
            </xsl:if>
            <!-- Contenu -->
            <xsl:apply-templates select="tei:body/tei:div/node()[not(self::tei:head)]"/>
        </div>
    </xsl:template>
    
    <!-- Gestion des titres dans `lg` -->
    <xsl:template match="tei:lg">
        <div class="poem-stanza">
            <!-- Titres des strophes en h5 -->
            <xsl:if test="tei:head">
                <h5 class="poem-title">
                    <xsl:value-of select="tei:head"/>
                </h5>
            </xsl:if>
            <!-- Contenu -->
            <xsl:apply-templates select="node()[not(self::tei:head)]"/>
        </div>
    </xsl:template>
    
    <!-- Paragraphe -->
    <xsl:template match="tei:p">
        <p class="paragraph">
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    
    <!-- Ligne dans un poème -->
    <xsl:template match="tei:l">
        <p class="line">
            <xsl:value-of select="."/>
        </p>
    </xsl:template>
    
    <!-- Ignorer les numéros de page -->
    <xsl:template match="tei:pb">
        <!-- Aucun contenu à générer pour les balises <pb> -->
    </xsl:template>
    
    <!-- Gestion des noms de personnages -->
    <xsl:template match="tei:persName">
        <span class="persName" id="pers-{@key}" data-role="{@role}">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
        
        <xsl:template match="tei:placeName">
            <span class="placeName" id="place-{@key}" data-role="{@role}">
                <xsl:apply-templates/>
            </span>
        </xsl:template>
</xsl:stylesheet>
