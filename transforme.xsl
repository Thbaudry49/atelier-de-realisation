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
                <style>
                    /* Styles pour améliorer l'affichage */
                    .metadata, .introduction, .section, .subsection, .paragraph, .poem, .line, .page-number, .floating-title {
                    margin: 10px 0;
                    padding: 5px 10px;
                    }
                    .metadata { background-color: #f9f9f9; border: 1px solid #ddd; }
                    .poem { font-style: italic; border-left: 3px solid darkgreen; padding: 10px; }
                    .line { margin-left: 20px; }
                    hr.page-divider { visibility: hidden; }
                    .linked-text { border-left: 4px solid #4a0072; background-color: #f0f8ff; padding: 10px; margin: 20px 0; border-radius: 5px; }
                    .linked-text a { text-decoration: none; color: #4a0072; font-weight: bold; }
                    .floating-text h4 { color: #4a0072; font-weight: bold; }
                    .floating-text h5 { color: #555; font-style: italic; }
                </style>
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
    
    <!-- Front (introduction) -->
    <xsl:template match="tei:front">
        <div class="introduction">
            <h2 class="section-title">Introduction</h2>
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    
    <!-- Section principale -->
    <xsl:template match="tei:div1">
        <xsl:if test="position() &gt; 1">
            <hr class="page-divider"/>
        </xsl:if>
        <div class="section" id="{@xml:id}">
            <h2 class="section-title">
                <xsl:value-of select="tei:head"/>
            </h2>
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    
    <!-- Sous-section -->
    <xsl:template match="tei:div2">
        <div class="subsection" id="{@xml:id}">
            <h3 class="subsection-title">
                <xsl:value-of select="tei:head"/>
            </h3>
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    
    <!-- Gestion des titres et hiérarchies pour <head> -->
    <xsl:template match="tei:head">
        <xsl:choose>
            <xsl:when test="ancestor::tei:div1">
                <h2 class="section-title">
                    <xsl:value-of select="."/>
                </h2>
            </xsl:when>
            <xsl:when test="ancestor::tei:div2">
                <h3 class="subsection-title">
                    <xsl:value-of select="."/>
                </h3>
            </xsl:when>
            <xsl:when test="ancestor::tei:floatingText">
                <xsl:choose>
                    <xsl:when test="position() = 1">
                        <h4 class="{ancestor::tei:floatingText/@type}">
                            <xsl:value-of select="."/>
                        </h4>
                    </xsl:when>
                    <xsl:otherwise>
                        <h5>
                            <xsl:value-of select="."/>
                        </h5>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    <!-- Paragraphe -->
    <xsl:template match="tei:p">
        <p class="paragraph">
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    
    <!-- Texte flottant avec gestion des types et des connexions -->
    <xsl:template match="tei:floatingText">
        <div class="floating-text" id="{@xml:id}" data-type="{@type}">
            <!-- Titre principal -->
            <xsl:apply-templates select="tei:head[1]"/>
            <!-- Sous-titre (si présent) -->
            <xsl:apply-templates select="tei:head[position() > 1]"/>
            <!-- Références via corresp -->
            <xsl:if test="@corresp">
                <div class="linked-text">
                    Réponse au texte : 
                    <a href="{@corresp}" title="Voir le texte correspondant">
                        <xsl:value-of select="@corresp"/>
                    </a>
                </div>
            </xsl:if>
            <!-- Contenu du texte flottant -->
            <xsl:apply-templates select="node()[not(self::tei:head)]"/>
        </div>
    </xsl:template>
    
    <!-- Groupe de lignes dans un poème -->
    <xsl:template match="tei:lg">
        <div class="poem-stanza">
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    
    <!-- Ligne dans un poème -->
    <xsl:template match="tei:l">
        <p class="line">
            <xsl:value-of select="."/>
        </p>
    </xsl:template>
    
    <!-- Gestion des numéros de page -->
    <xsl:template match="tei:pb">
        <hr class="page-divider"/>
        <span class="page-number" id="page-{@n}">Page <xsl:value-of select="@n"/></span>
    </xsl:template>
    
    <!-- Gestion des noms de personnages -->
    <xsl:template match="tei:persName">
        <span class="persName" id="pers-{@key}" data-role="{@role}">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    
    <!-- Gestion des noms de lieux -->
    <xsl:template match="tei:placeName">
        <span class="placeName" id="place-{@key}" data-role="{@role}">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
</xsl:stylesheet>
